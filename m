Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab0LGRmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 12:42:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab0LGRmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 12:42:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] MN10300: Fix interrupt mask alteration function call name
 in gdbstub
To: torvalds@osdl.org, akpm@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 07 Dec 2010 17:41:40 +0000
Message-ID: <20101207174140.9635.63471.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix name of interrupt mask alteration function (local_change_intr_mask_level())
called in gdbstub to have an arch_ prefix to match the definition in
asm/irqflags.h.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/gdb-io-serial.c |    3 ++-
 arch/mn10300/kernel/gdb-io-ttysm.c  |    3 ++-
 arch/mn10300/kernel/gdb-stub.c      |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)


diff --git a/arch/mn10300/kernel/gdb-io-serial.c b/arch/mn10300/kernel/gdb-io-serial.c
index 0d5d63c..f28dc99 100644
--- a/arch/mn10300/kernel/gdb-io-serial.c
+++ b/arch/mn10300/kernel/gdb-io-serial.c
@@ -73,7 +73,8 @@ void gdbstub_io_init(void)
 	GDBPORT_SERIAL_IER = UART_IER_RDI | UART_IER_RLSI;
 
 	/* permit level 0 IRQs to take place */
-	local_change_intr_mask_level(NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
+	arch_local_change_intr_mask_level(
+		NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
 }
 
 /*
diff --git a/arch/mn10300/kernel/gdb-io-ttysm.c b/arch/mn10300/kernel/gdb-io-ttysm.c
index 97dfda2..abdeea1 100644
--- a/arch/mn10300/kernel/gdb-io-ttysm.c
+++ b/arch/mn10300/kernel/gdb-io-ttysm.c
@@ -87,7 +87,8 @@ void __init gdbstub_io_init(void)
 	tmp = *gdbstub_port->_control;
 
 	/* permit level 0 IRQs only */
-	local_change_intr_mask_level(NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
+	arch_local_change_intr_mask_level(
+		NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
 }
 
 /*
diff --git a/arch/mn10300/kernel/gdb-stub.c b/arch/mn10300/kernel/gdb-stub.c
index e49dd5b..1070e4d 100644
--- a/arch/mn10300/kernel/gdb-stub.c
+++ b/arch/mn10300/kernel/gdb-stub.c
@@ -1229,7 +1229,8 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
 
 	asm volatile("mov mdr,%0" : "=d"(mdr));
 	local_save_flags(epsw);
-	local_change_intr_mask_level(NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
+	arch_local_change_intr_mask_level(
+		NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
 
 	gdbstub_store_fpu();
 

