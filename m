Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2F2P4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:56:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab2F2P42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:56:28 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v3 3/3] kvm: Sanitize KVM_IRQFD flags
To: avi@redhat.com, mst@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        cornelia.huck@de.ibm.com
Date: Fri, 29 Jun 2012 09:56:24 -0600
Message-ID: <20120629155622.30535.24831.stgit@bling.home>
In-Reply-To: <20120629154940.30535.17132.stgit@bling.home>
References: <20120629154940.30535.17132.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only know of one so far.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 virt/kvm/eventfd.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index c307c24..7d7e2aa 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -340,6 +340,9 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 int
 kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
 {
+	if (args->flags & ~KVM_IRQFD_FLAG_DEASSIGN)
+		return -EINVAL;
+
 	if (args->flags & KVM_IRQFD_FLAG_DEASSIGN)
 		return kvm_irqfd_deassign(kvm, args);
 

