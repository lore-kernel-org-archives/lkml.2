Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab1C3VMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:12:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:45379 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965343Ab1C3VKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411279413"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mtosatti@redhat.com, avi@redhat.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [270/275] KVM: i8259: initialize isr_ack
Message-Id: <20110330210837.E38383E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Avi Kivity <avi@redhat.com>

commit a0272630bb594b4eac03a79e77957df7dad8eade upstream.

isr_ack is never initialized.  So, until the first PIC reset, interrupts
may fail to be injected.  This can cause Windows XP to fail to boot, as
reported in the fallout from the fix to
https://bugzilla.kernel.org/show_bug.cgi?id=21962.

Reported-and-tested-by: Nicolas Prochazka <prochazka.nicolas@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kvm/i8259.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/arch/x86/kvm/i8259.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kvm/i8259.c	2011-01-13 09:47:51.000000000 -0800
+++ linux-2.6.35.y/arch/x86/kvm/i8259.c	2011-03-29 23:47:12.738423232 -0700
@@ -553,6 +553,8 @@
 	s->irq_request_opaque = kvm;
 	s->pics[0].pics_state = s;
 	s->pics[1].pics_state = s;
+	s->pics[0].isr_ack = 0xff;
+	s->pics[1].isr_ack = 0xff;
 
 	/*
 	 * Initialize PIO device
