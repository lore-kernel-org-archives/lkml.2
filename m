Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab0HOPdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:33:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59275 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab0HOPdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=plCglyhxy0ffWI3N4COKLAutXRtYT+aRhm5oG3C5QZGdVSqJVfI0TLQjbJQDNsq1JH
         kkjHhUgOnnX24agpEe/RoovNsjCLaDJB4Sx7822/C/nn3lrzLt9XxnGI+Dj5fm8VVVAT
         1dHHkp6ufKn6iNgnhWbxFW64ue5+SnaC1gSoQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] init/main.c: remove __releases(kernel_lock) notations
Date: Sun, 15 Aug 2010 19:25:59 +0900
Message-Id: <1281867959-9843-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 5e3d20a68f63fc5a310687d81956c3b96e488b84 removed BKL from the startup
path so these notations should be removed also.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 5a0be5c..96ed802 100644
--- a/init/main.c
+++ b/init/main.c
@@ -428,7 +428,6 @@ static void __init setup_command_line(char *command_line)
 static __initdata DECLARE_COMPLETION(kthreadd_done);
 
 static noinline void __init_refok rest_init(void)
-	__releases(kernel_lock)
 {
 	int pid;
 
@@ -823,7 +822,6 @@ static void run_init_process(char *init_filename)
  * makes it inline to init() and it becomes part of init.text section
  */
 static noinline int init_post(void)
-	__releases(kernel_lock)
 {
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
-- 
1.7.0.4

