Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab0F3Naa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:30:30 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:50927 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab0F3Na3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 30 Jun 2010 09:30:29 -0400
Message-Id: <4C2B63310200007800008D5D@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 14:30:57 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: adjust frame type at paranoid_exit:
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

--- linux-2.6.35-rc3/arch/x86/kernel/entry_64.S
+++ 2.6.35-rc3-x86_64-unwind-annotations/arch/x86/kernel/entry_64.S
@@ -1365,7 +1364,7 @@ paranoidzeroentry machine_check *machine
 
 	/* ebx:	no swapgs flag */
 ENTRY(paranoid_exit)
-	INTR_FRAME
+	DEFAULT_FRAME
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl %ebx,%ebx				/* swapgs needed? */



