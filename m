Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0H0JpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:45:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33242 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab0H0JpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:45:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nYl4VqQ5bwxtPhMlyuDSz3KTk2n0Zfk/M0DU8GA7rtOX0AvZCgWWLrNLNRTZ9xho1T
         bjPaf2KHy4Lgl4u9+GYlRcah4w1FJiejrHlEFwQXPAmMZ8TadBOfjbVvyru7LGsQQcL3
         OahcLUD3UUYEMsU5lJ7T2PqPQLaNiUG/rk9Q0=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Chris Zankel <chris@zankel.net>
Subject: [RFC PATCH 42/43] ptrace, xtensa: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:28 +0900
Message-Id: <1282902149-12991-43-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/kernel/ptrace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index 9d4e1ce..af9ba80 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -256,7 +256,8 @@ int ptrace_pokeusr(struct task_struct *child, long regno, long val)
 	return 0;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret = -EPERM;
 
-- 
1.7.2.2

