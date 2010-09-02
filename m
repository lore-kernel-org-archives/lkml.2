Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab0IBPsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:48:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33315 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab0IBPst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:48:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uO38Imi5ZOULDzZgGzA4oNyMTAquC6b6UGkAZ0fiOJeA6kz5WyrvQu7PgEAsYJMHFr
         uubLkAbrofdw6JtCA3I9QfPwDV/F4E6PrBnGJBXnssD9hZIX2ndsAKw86I7iT2GRT4zm
         U3tvQ3hUZB7QZn83lWvmi8gMZ80UUAB83lBro=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH v2 22/24] ptrace: cleanup arch_ptrace() on tile
Date: Fri,  3 Sep 2010 00:46:29 +0900
Message-Id: <1283442391-23612-23-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove checking @addr less than 0 because @addr is now unsigned.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
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

