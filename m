Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab2FTUKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:10:04 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:52960 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058Ab2FTUKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:10:00 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/6] mn10300: Remove duplicate definition of PTRACE_O_TRACESYSGOOD
Date: Wed, 20 Jun 2012 22:09:46 +0200
Message-Id: <1340222990-20796-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340222990-20796-1-git-send-email-geert@linux-m68k.org>
References: <1340222990-20796-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/ptrace.h:66:0: warning: "PTRACE_O_TRACESYSGOOD" redefined [enabled by default]
arch/mn10300/include/asm/ptrace.h:85:0: note: this is the location of the previous definition

We already have it in <linux/ptrace.h>, so remove it from <asm/ptrace.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/mn10300/include/asm/ptrace.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/mn10300/include/asm/ptrace.h b/arch/mn10300/include/asm/ptrace.h
index 55b79ef..44251b9 100644
--- a/arch/mn10300/include/asm/ptrace.h
+++ b/arch/mn10300/include/asm/ptrace.h
@@ -81,9 +81,6 @@ struct pt_regs {
 #define PTRACE_GETFPREGS          14
 #define PTRACE_SETFPREGS          15
 
-/* options set using PTRACE_SETOPTIONS */
-#define PTRACE_O_TRACESYSGOOD     0x00000001
-
 #ifdef __KERNEL__
 
 #define user_mode(regs)			(((regs)->epsw & EPSW_nSL) == EPSW_nSL)
-- 
1.7.0.4

