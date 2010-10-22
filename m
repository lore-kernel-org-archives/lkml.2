Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab0JVTFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:05:36 -0400
Received: from kroah.org ([198.145.64.141]:34346 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759467Ab0JVS4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:54 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:34 2010
Message-Id: <20101022185234.178945675@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        mtosatti@redhat.com, avi@redhat.com, Gleb Natapov <gleb@redhat.com>
Subject: [076/103] KVM: i8259: fix migration
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit eebb5f31b8d9a2620dcf32297096f8ce1240b179 upstream.

Top of kvm_kpic_state structure should have the same memory layout as
kvm_pic_state since it is copied by memcpy.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/irq.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -45,7 +45,6 @@ struct kvm_kpic_state {
 	u8 irr;		/* interrupt request register */
 	u8 imr;		/* interrupt mask register */
 	u8 isr;		/* interrupt service register */
-	u8 isr_ack;	/* interrupt ack detection */
 	u8 priority_add;	/* highest irq priority */
 	u8 irq_base;
 	u8 read_reg_select;
@@ -58,6 +57,7 @@ struct kvm_kpic_state {
 	u8 init4;		/* true if 4 byte init */
 	u8 elcr;		/* PIIX edge/trigger selection */
 	u8 elcr_mask;
+	u8 isr_ack;	/* interrupt ack detection */
 	struct kvm_pic *pics_state;
 };
 


