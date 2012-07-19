Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2GSKzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 06:55:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340Ab2GSKzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 06:55:18 -0400
Date: Thu, 19 Jul 2012 13:55:53 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: switch to symbolic name for irq_states size
Message-ID: <20120719105553.GA4155@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PIC_NUM_PINS instead of hard-coded 16 for pic pins.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/irq.h  | 2 +-
 virt/kvm/irq_comm.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 2086f2b..2d03568 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -70,7 +70,7 @@ struct kvm_pic {
 	struct kvm_io_device dev_slave;
 	struct kvm_io_device dev_eclr;
 	void (*ack_notifier)(void *opaque, int irq);
-	unsigned long irq_states[16];
+	unsigned long irq_states[PIC_NUM_PINS];
 };
 
 struct kvm_pic *kvm_create_pic(struct kvm *kvm);
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 83402d7..7118be0 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -321,11 +321,11 @@ static int setup_routing_entry(struct kvm_irq_routing_table *rt,
 		switch (ue->u.irqchip.irqchip) {
 		case KVM_IRQCHIP_PIC_MASTER:
 			e->set = kvm_set_pic_irq;
-			max_pin = 16;
+			max_pin = PIC_NUM_PINS;
 			break;
 		case KVM_IRQCHIP_PIC_SLAVE:
 			e->set = kvm_set_pic_irq;
-			max_pin = 16;
+			max_pin = PIC_NUM_PINS;
 			delta = 8;
 			break;
 		case KVM_IRQCHIP_IOAPIC:
-- 
MST
