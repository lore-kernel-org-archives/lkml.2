Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab0HGNyI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 09:54:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55784 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0HGNyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 09:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dlf+iVxrYYZM09PBETGcf7GhgjwMgFXWlvVvhzuMgwSgZ2LSFZXOqI7kraDxP8dsJF
         fdVk9wyNv9qU3aqra3nG1ZVE4PKwLbEgejZp/yqGseAJ3rpMUfztLXvnB9SAwbxk+mWG
         vpjJbqDfwYpNtvWJd8b/ZaInbZ/Ul7bcYSPyc=
From: Namhyung Kim <namhyung@gmail.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: add missing __percpu markup in kernel/workqueue.c
Date: Sat,  7 Aug 2010 22:53:59 +0900
Message-Id: <1281189239-14600-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <4C5D512A.2070103@kernel.org>
References: <4C5D512A.2070103@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

works is a percpu pointer but was missing __percpu markup.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e2eb351..334a9e0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2553,7 +2553,7 @@ EXPORT_SYMBOL(schedule_delayed_work_on);
 int schedule_on_each_cpu(work_func_t func)
 {
 	int cpu;
-	struct work_struct *works;
+	struct work_struct __percpu *works;
 
 	works = alloc_percpu(struct work_struct);
 	if (!works)
-- 
1.7.0.4

