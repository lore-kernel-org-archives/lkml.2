Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab0H0JnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:43:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42423 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab0H0JnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hI2OHlzoR+5TWIA+UqfS6Nstw7onXufSk5AmJmwc5oyHdI/xSKyiUo/1ZV0Brg7RZ8
         /XnXjAnn3SnTv1yFc5U6LDISGP1feT00TXBqfyaJPPLlLf2vGFYPbsHMVWWH9g+Lvjo+
         V82WEcxKMFAcBAruVPsL+Q1E5ucyRG/NFiBk8=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: [RFC PATCH 07/43] ptrace, arm: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:41:53 +0900
Message-Id: <1282902149-12991-8-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/kernel/ptrace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index f99d489..87ca2c7 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -847,7 +847,8 @@ static int ptrace_setvfpregs(struct task_struct *tsk, void __user *data)
 }
 #endif
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
-- 
1.7.2.2

