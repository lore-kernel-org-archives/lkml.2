Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0LCXiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 18:38:18 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:44071 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab0LCXhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 18:37:38 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 4/5] KVM: Clean up unneeded void pointer casts
Date: Sat,  4 Dec 2010 00:37:30 +0100
Message-Id: <f35631331c3b2fa1583751f664a58b2b8095f549.1291419444.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1291419444.git.jan.kiszka@web.de>
References: <cover.1291419444.git.jan.kiszka@web.de>
In-Reply-To: <cover.1291419444.git.jan.kiszka@web.de>
References: <cover.1291419444.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX18xU2zxyd148LBSiky8U9pnPf4no+mHwVnvJEwu
	Cg2ds+ge4GAOAbPrMu06HV00+Dm9p74VpdqN3jfrYX89DHIldq
	cPSvyUa7Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 virt/kvm/assigned-dev.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 3f8a745..c6114d3 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -149,7 +149,7 @@ static void deassign_host_irq(struct kvm *kvm,
 
 		for (i = 0; i < assigned_dev->entries_nr; i++)
 			free_irq(assigned_dev->host_msix_entries[i].vector,
-				 (void *)assigned_dev);
+				 assigned_dev);
 
 		assigned_dev->entries_nr = 0;
 		kfree(assigned_dev->host_msix_entries);
@@ -159,7 +159,7 @@ static void deassign_host_irq(struct kvm *kvm,
 		/* Deal with MSI and INTx */
 		disable_irq(assigned_dev->host_irq);
 
-		free_irq(assigned_dev->host_irq, (void *)assigned_dev);
+		free_irq(assigned_dev->host_irq, assigned_dev);
 
 		if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSI)
 			pci_disable_msi(assigned_dev->dev);
@@ -238,7 +238,7 @@ static int assigned_device_enable_host_intx(struct kvm *kvm,
 	 * are going to be long delays in accepting, acking, etc.
 	 */
 	if (request_threaded_irq(dev->host_irq, NULL, kvm_assigned_dev_thread,
-				 IRQF_ONESHOT, dev->irq_name, (void *)dev))
+				 IRQF_ONESHOT, dev->irq_name, dev))
 		return -EIO;
 	return 0;
 }
@@ -257,7 +257,7 @@ static int assigned_device_enable_host_msi(struct kvm *kvm,
 
 	dev->host_irq = dev->dev->irq;
 	if (request_threaded_irq(dev->host_irq, NULL, kvm_assigned_dev_thread,
-				 0, dev->irq_name, (void *)dev)) {
+				 0, dev->irq_name, dev)) {
 		pci_disable_msi(dev->dev);
 		return -EIO;
 	}
@@ -284,7 +284,7 @@ static int assigned_device_enable_host_msix(struct kvm *kvm,
 	for (i = 0; i < dev->entries_nr; i++) {
 		r = request_threaded_irq(dev->host_msix_entries[i].vector,
 					 NULL, kvm_assigned_dev_thread_msix,
-					 0, dev->irq_name, (void *)dev);
+					 0, dev->irq_name, dev);
 		if (r)
 			goto err;
 	}
@@ -292,7 +292,7 @@ static int assigned_device_enable_host_msix(struct kvm *kvm,
 	return 0;
 err:
 	for (i -= 1; i >= 0; i--)
-		free_irq(dev->host_msix_entries[i].vector, (void *)dev);
+		free_irq(dev->host_msix_entries[i].vector, dev);
 	pci_disable_msix(dev->dev);
 	return r;
 }
-- 
1.7.1

