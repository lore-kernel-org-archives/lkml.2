Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab0ELVr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:47:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717Ab0ELVr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:47:57 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] kvm: remove CAP_SYS_RAWIO requirement from
	kvm_vm_ioctl_assign_irq
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, chrisw@redhat.com,
       alex.williamson@redhat.com
Date: Wed, 12 May 2010 09:46:31 -0400
Message-ID: <20100512134619.30602.63792.stgit@virtlab9.virt.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove this check in an effort to allow kvm guests to run without
root privileges.  This capability check doesn't seem to add any
security since the device needs to have already been added via the
assign device ioctl and the io actually occurs through the pci
sysfs interface.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 virt/kvm/assigned-dev.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 4d10b1e..64672e2 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -448,9 +448,6 @@ static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 	struct kvm_assigned_dev_kernel *match;
 	unsigned long host_irq_type, guest_irq_type;
 
-	if (!capable(CAP_SYS_RAWIO))
-		return -EPERM;
-
 	if (!irqchip_in_kernel(kvm))
 		return r;
 

