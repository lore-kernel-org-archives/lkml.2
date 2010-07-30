Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab0G3Rpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:45:47 -0400
Received: from kroah.org ([198.145.64.141]:36094 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759302Ab0G3Rfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:50 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:12 2010
Message-Id: <20100730173112.841928832@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [112/140] KVM: read apic->irr with ioapic lock held
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

Read ioapic->irr inside ioapic->lock protected section.

KVM-Stable-Tag
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
(cherry picked from comit 07dc7263b99e4ddad2b4c69765a428ccb7d48938)
---
 virt/kvm/ioapic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -177,12 +177,13 @@ static int ioapic_deliver(struct kvm_ioa
 
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
 {
-	u32 old_irr = ioapic->irr;
+	u32 old_irr;
 	u32 mask = 1 << irq;
 	union kvm_ioapic_redirect_entry entry;
 	int ret = 1;
 
 	mutex_lock(&ioapic->lock);
+	old_irr = ioapic->irr;
 	if (irq >= 0 && irq < IOAPIC_NUM_PINS) {
 		entry = ioapic->redirtbl[irq];
 		level ^= entry.fields.polarity;


