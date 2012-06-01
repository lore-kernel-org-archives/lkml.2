Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965423Ab2FAQQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:16:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965374Ab2FAQQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:16:26 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI interrupts
To: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com
Cc: jan.kiszka@siemens.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Date: Fri, 01 Jun 2012 10:16:19 -0600
Message-ID: <20120601161521.26935.25606.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel no longer allows us to pass NULL for a hard interrupt
handler without IRQF_ONESHOT.  Should have been using this flag
anyway.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=43328

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 virt/kvm/assigned-dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 01f572c..e804d14 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -347,7 +347,7 @@ static int assigned_device_enable_host_msi(struct kvm *kvm,
 
 	dev->host_irq = dev->dev->irq;
 	if (request_threaded_irq(dev->host_irq, NULL,
-				 kvm_assigned_dev_thread_msi, 0,
+				 kvm_assigned_dev_thread_msi, IRQF_ONESHOT,
 				 dev->irq_name, dev)) {
 		pci_disable_msi(dev->dev);
 		return -EIO;
@@ -375,7 +375,7 @@ static int assigned_device_enable_host_msix(struct kvm *kvm,
 	for (i = 0; i < dev->entries_nr; i++) {
 		r = request_threaded_irq(dev->host_msix_entries[i].vector,
 					 NULL, kvm_assigned_dev_thread_msix,
-					 0, dev->irq_name, dev);
+					 IRQF_ONESHOT, dev->irq_name, dev);
 		if (r)
 			goto err;
 	}

