Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab0IBPs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:48:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33315 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0IBPsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:48:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XeLgMXRwvEhucoXQGExxW3xfoMhx8qa3do46jnAR0CqX3A3DbqRp/bOFIH/Xq+v0Vn
         V7nsCMzGOA2jjl2sGE4VSXWyuycPezmbWGI+zzJJPvMBlp8fycqDtBzYP5Xr0E2ydYgN
         94vFCFoKJadz8bIV0aaMivmF66A21PfzIBaaI=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [PATCH v2 17/24] ptrace: cleanup arch_ptrace() on parisc
Date: Fri,  3 Sep 2010 00:46:24 +0900
Message-Id: <1283442391-23612-18-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing __user markup on the argument of put_user().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
---
 arch/parisc/kernel/ptrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index 03920db..2905b1f 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -125,7 +125,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		     addr >= sizeof(struct pt_regs))
 			break;
 		tmp = *(unsigned long *) ((char *) task_regs(child) + addr);
-		ret = put_user(tmp, (unsigned long *) data);
+		ret = put_user(tmp, (unsigned long __user *) data);
 		break;
 
 	/* Write the word at location addr in the USER area.  This will need
-- 
1.7.2.2

