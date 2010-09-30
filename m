Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab0I3J36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:29:58 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55969 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab0I3J3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Fz0IyL8up25VJgXARyBFrep1hhVu3ikR86Ty+MCa0PgeTpwaSjooWPJPKWRCU+uTsd
         rYQxxOMw5OgnT1QQzKOC1bsk/HVqZURCWrZe9lPa/kawphACMZTG7ke8EaobghKeYodG
         ubdtH+b6Smthv7nvY81zqTE+3WttxsVoGS37w=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v3 22/24] ptrace: cleanup arch_ptrace() on tile
Date: Thu, 30 Sep 2010 18:27:57 +0900
Message-Id: <1285838880-4977-23-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove checking @addr less than 0 because @addr is now unsigned.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/ptrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index aed9256..704bf11 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -85,7 +85,7 @@ long arch_ptrace(struct task_struct *child, long request,
 	case PTRACE_PEEKUSR:  /* Read register from pt_regs. */
 		if (addr & (sizeof(data)-1))
 			break;
-		if (addr < 0 || addr >= PTREGS_SIZE)
+		if (addr >= PTREGS_SIZE)
 			break;
 		tmp = getreg(child, addr);   /* Read register */
 		ret = put_user(tmp, datap);
@@ -94,7 +94,7 @@ long arch_ptrace(struct task_struct *child, long request,
 	case PTRACE_POKEUSR:  /* Write register in pt_regs. */
 		if (addr & (sizeof(data)-1))
 			break;
-		if (addr < 0 || addr >= PTREGS_SIZE)
+		if (addr >= PTREGS_SIZE)
 			break;
 		putreg(child, addr, data);   /* Write register */
 		ret = 0;
-- 
1.7.2.2

