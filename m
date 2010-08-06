Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761774Ab0HFS0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:26:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64187 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964826Ab0HFS0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JfZ2wTMTiCvtNb3wYyrb7z5Whqz5kLE+4+8a2XG0fnTpODFuPoILr1yPfGaz/4LzTh
         lyjUIXhtwOf4jM+IyGm6qPpIsyxuhG9WI1ZbsdFMeWaCYRlMMhQAwjQZwA23z0MdN8vJ
         zsHA6l0q0HPlG0dSMEWJiYx4/40Sqk1N87hfY=
From: Namhyung Kim <namhyung@gmail.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] percpu: add missing markups in kernel/workqueue.c
Date: Sat,  7 Aug 2010 03:26:25 +0900
Message-Id: <1281119187-12640-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/workqueue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 327d2de..bb030e3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -57,7 +57,7 @@ struct cpu_workqueue_struct {
  * per-CPU workqueues:
  */
 struct workqueue_struct {
-	struct cpu_workqueue_struct *cpu_wq;
+	struct cpu_workqueue_struct __percpu *cpu_wq;
 	struct list_head list;
 	const char *name;
 	int singlethread;
@@ -821,7 +821,7 @@ int schedule_on_each_cpu(work_func_t func)
 {
 	int cpu;
 	int orig = -1;
-	struct work_struct *works;
+	struct work_struct __percpu *works;
 
 	works = alloc_percpu(struct work_struct);
 	if (!works)
-- 
1.7.0.4

