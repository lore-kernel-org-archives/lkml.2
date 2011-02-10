Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab1BJXi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:58 -0500
Received: from www.tglx.de ([62.245.132.106]:44624 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468Ab1BJXi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:56 -0500
Message-Id: <20110210223301.533385139@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 75/75] x86: Disable deprecated GENIRQ features
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=x86-mark-squeaky-clean.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 builds and works without the deprecated stuff when XEN, and MFD
are disabled. Once those are fixed, we can remove the conditionals.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-tip/arch/x86/Kconfig
===================================================================
--- linux-2.6-tip.orig/arch/x86/Kconfig
+++ linux-2.6-tip/arch/x86/Kconfig
@@ -67,6 +67,8 @@ config X86
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
+	select GENERIC_HARDIRQS_NO_DEPRECATED if !XEN && !MFD
+	select GENERIC_HARDIRQS_NO_COMPAT if !XEN && !MFD
 	select USE_GENERIC_SMP_HELPERS if SMP
 
 config INSTRUCTION_DECODER


