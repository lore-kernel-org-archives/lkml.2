Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab0I0HHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 03:07:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36378 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab0I0HHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 03:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Z36t5sOz43wRMTu0i6Wyd+NIKfFCWCx/tH3ruD5Vt439TDM59x4w7Nx2Gzk5XiP/Tt
         JqN1GVuYND7EktEQxhFek+EonbEXm4i1FcY5lI0MDfxeD8tDnYFT9wLj2qGpgR+o1gxd
         LlG+0G9nDqG7WN/rfp2vNkK5QhGq/dxRI26EY=
From: Namhyung Kim <namhyung@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] init/main.c: remove BLK notations
Date: Mon, 27 Sep 2010 16:06:54 +0900
Message-Id: <1285571214-6965-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to commit 5e3d20a68f63fc5a310687d81956c3b96e488b84
(init: Remove the BKL from startup code) these sparse notations
should be removed also.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 init/main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 94ab488..cb0b927 100644
--- a/init/main.c
+++ b/init/main.c
@@ -424,7 +424,6 @@ static void __init setup_command_line(char *command_line)
 static __initdata DECLARE_COMPLETION(kthreadd_done);
 
 static noinline void __init_refok rest_init(void)
-	__releases(kernel_lock)
 {
 	int pid;
 
@@ -819,7 +818,6 @@ static void run_init_process(const char *init_filename)
  * makes it inline to init() and it becomes part of init.text section
  */
 static noinline int init_post(void)
-	__releases(kernel_lock)
 {
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
-- 
1.7.2.2

