Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab1BYUqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:46:44 -0500
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:55162 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653Ab1BYUq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:46:29 -0500
From: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
Subject: [PATCH 2/2] Cleanup mn10300 asm-offsets.c(PAGE_SIZE_asm)
Date: Fri, 25 Feb 2011 22:46:14 +0200
Message-Id: <1298666774-17646-3-git-send-email-psomas@cslab.ece.ntua.gr>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298666774-17646-1-git-send-email-psomas@cslab.ece.ntua.gr>
References: <1298472122-4967-1-git-send-email-psomas@cslab.ece.ntua.gr>
 <1298666774-17646-1-git-send-email-psomas@cslab.ece.ntua.gr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Fri, 25 Feb 2011 22:46:28 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
---
 arch/mn10300/kernel/asm-offsets.c      |    2 --
 arch/mn10300/kernel/gdb-io-ttysm-low.S |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/mn10300/kernel/asm-offsets.c b/arch/mn10300/kernel/asm-offsets.c
index 96f24fa..698eb60 100644
--- a/arch/mn10300/kernel/asm-offsets.c
+++ b/arch/mn10300/kernel/asm-offsets.c
@@ -89,8 +89,6 @@ void foo(void)
 	OFFSET(EXEC_DOMAIN_handler,	exec_domain, handler);
 	OFFSET(RT_SIGFRAME_sigcontext,	rt_sigframe, uc.uc_mcontext);
 
-	DEFINE(PAGE_SIZE_asm,		PAGE_SIZE);
-
 	OFFSET(__rx_buffer,		mn10300_serial_port, rx_buffer);
 	OFFSET(__rx_inp,		mn10300_serial_port, rx_inp);
 	OFFSET(__rx_outp,		mn10300_serial_port, rx_outp);
diff --git a/arch/mn10300/kernel/gdb-io-ttysm-low.S b/arch/mn10300/kernel/gdb-io-ttysm-low.S
index 060b7cc..7b2d665 100644
--- a/arch/mn10300/kernel/gdb-io-ttysm-low.S
+++ b/arch/mn10300/kernel/gdb-io-ttysm-low.S
@@ -38,7 +38,7 @@ gdbstub_io_rx_handler:
 gdbstub_io_rx_more:
 	mov	a3,a2
 	add	2,a3
-	and	PAGE_SIZE_asm-1,a3
+	and	PAGE_SIZE-1,a3
 	mov	(gdbstub_rx_outp),d3
 	cmp	a3,d3
 	beq	gdbstub_io_rx_overflow
-- 
1.7.4.1

