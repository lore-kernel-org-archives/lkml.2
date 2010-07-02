Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab0GCCSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 22:18:14 -0400
Received: from king.tilera.com ([72.1.168.226]:11399 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757205Ab0GCCR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 22:17:59 -0400
Message-Id: <201007030217.o632HwSr004032@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 2 Jul 2010 14:17:52 -0400
Subject: [PATCH] arch/tile: avoid erroneous error return for PTRACE_POKEUSR.
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de
X-OriginalArrivalTime: 03 Jul 2010 02:17:58.0474 (UTC) FILETIME=[F46122A0:01CB1A55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/ptrace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index e5701d1..7161bd0 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -96,6 +96,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		if (addr < 0 || addr >= PTREGS_SIZE)
 			break;
 		putreg(child, addr, data);   /* Write register */
+		ret = 0;
 		break;
 
 	case PTRACE_GETREGS:  /* Get all registers from the child. */
-- 
1.6.5.2

