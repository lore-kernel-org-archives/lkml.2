Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab2F0JNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:13:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab2F0JNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:13:42 -0400
Date: Wed, 27 Jun 2012 12:13:43 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com
Subject: [PATCH] kvm: don't clear level from irqfd
Message-ID: <20120627091343.GA17693@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irqfd sets and clears the level immediately.
This used to be necessary for MSI interrupts but isn't anymore.

Note! We never officially supported irqfd for level
interrupts but it usually seemed to kind of work,
and this change will break it. There are no known
real users of that feature though - only old vfio prototypes.
Removing this line will make it easier to add
real support for level irqfds in the future.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 virt/kvm/eventfd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index f59c1e8..4db6b01 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -68,7 +68,6 @@ irqfd_inject(struct work_struct *work)
 	struct kvm *kvm = irqfd->kvm;
 
 	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
-	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
 }
 
 /*
-- 
MST
