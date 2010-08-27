Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab0H0Jnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:43:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52511 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0H0Jnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=R/YkCBOk0JDccooEPekQTD8iLgMmDsF7MCUHoU+j6+APihV4akcQVzz1tU2Nz/cutO
         ea2uZ6dZ9bsggOqrG4o43PVwj54YOj0y5CUDnTZjNS333MXoLcbGtLzi1mRlKcZevjKg
         74/XB41mZD5zErNM5K/x41SjZqzivVlTUv9rw=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Hirokazu Takata <takata@linux-m32r.org>
Subject: [RFC PATCH 19/43] ptrace, m32r: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:05 +0900
Message-Id: <1282902149-12991-20-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/kernel/ptrace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/m32r/kernel/ptrace.c b/arch/m32r/kernel/ptrace.c
index e555091..69bbf7a 100644
--- a/arch/m32r/kernel/ptrace.c
+++ b/arch/m32r/kernel/ptrace.c
@@ -621,7 +621,8 @@ void ptrace_disable(struct task_struct *child)
 }
 
 long
-arch_ptrace(struct task_struct *child, long request, long addr, long data)
+arch_ptrace(struct task_struct *child, long request,
+	    unsigned long addr, unsigned long data)
 {
 	int ret;
 
-- 
1.7.2.2

