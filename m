Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0IBMyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 08:54:37 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39280 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab0IBMyg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 2 Sep 2010 08:54:36 -0400
Message-Id: <4C7FBAA80200007800013F67@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 02 Sep 2010 13:54:32 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Resend: [PATCH] x86-64: adjust frame type at paranoid_exit:
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As this isn't an exception or interrupt entry point, it doesn't have
any of the hardware provide frame layouts active.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/entry_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.36-rc3/arch/x86/kernel/entry_64.S
+++ 2.6.36-rc3-x86_64-paranoid_exit-unwind/arch/x86/kernel/entry_64.S
@@ -1368,7 +1368,7 @@ paranoidzeroentry machine_check *machine
 
 	/* ebx:	no swapgs flag */
 ENTRY(paranoid_exit)
-	INTR_FRAME
+	DEFAULT_FRAME
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl %ebx,%ebx				/* swapgs needed? */



