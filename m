Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0H0JoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:44:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42423 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab0H0JoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iuTA0SpT3iTH+Xqku1NeacgX3W7ob/Tjq8gXzK999CksekpHafFhfyIP5aTysxAj47
         A1AePpCCbomQU+NhAsWD7z8SHNvnphc1Xng1TL2E/3hz2UwLbshaAbSvtraesaMv+1O4
         B+V1W1REkYyhDaW1QBOLfDJTeDHbo5JE5D4qk=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [RFC PATCH 26/43] ptrace, mips: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:12 +0900
Message-Id: <1282902149-12991-27-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/kernel/ptrace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index c51b95f..26c29dd 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -255,7 +255,8 @@ int ptrace_set_watch_regs(struct task_struct *child,
 	return 0;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
-- 
1.7.2.2

