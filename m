Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab1BPAvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:51:33 -0500
Received: from kroah.org ([198.145.64.141]:46137 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933375Ab1BPAvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:13 2011
Message-Id: <20110216002113.535935005@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
        avi@redhat.com, mtosatti@redhat.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 145/176] KVM: i8259: initialize isr_ack
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Avi Kivity <avi@redhat.com>

commit a0272630bb594b4eac03a79e77957df7dad8eade upstream.

isr_ack is never initialized.  So, until the first PIC reset, interrupts
may fail to be injected.  This can cause Windows XP to fail to boot, as
reported in the fallout from the fix to
https://bugzilla.kernel.org/show_bug.cgi?id=21962.

Reported-and-tested-by: Nicolas Prochazka <prochazka.nicolas@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/i8259.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -570,6 +570,8 @@ struct kvm_pic *kvm_create_pic(struct kv
 	s->pics[1].elcr_mask = 0xde;
 	s->pics[0].pics_state = s;
 	s->pics[1].pics_state = s;
+	s->pics[0].isr_ack = 0xff;
+	s->pics[1].isr_ack = 0xff;
 
 	/*
 	 * Initialize PIO device


