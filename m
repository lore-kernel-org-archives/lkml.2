Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1GGQgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 12:36:13 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:59302 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab1GGQgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 12:36:09 -0400
Subject: [PATCH 3/3] uml: os-Linux/main.c memory leak fix
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, vitalivanov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 19:37:48 +0300
Message-ID: <1310056668.3528.51.camel@vivanov>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6db3c87f57e3e61d968da79f01fb21ba17fd5bc0 Mon Sep 17 00:00:00 2001
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Thu, 7 Jul 2011 19:29:06 +0300
Subject: [PATCH 3/3] uml: os-Linux/main.c memory leak fix

We should cleanup memory even though 'putenv' fails.

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
---
 arch/um/os-Linux/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/os-Linux/main.c b/arch/um/os-Linux/main.c
index fb2a97a..67fe012 100644
--- a/arch/um/os-Linux/main.c
+++ b/arch/um/os-Linux/main.c
@@ -107,8 +107,8 @@ static void setup_env_path(void)
 	snprintf(new_path, path_len, "PATH=%s" UML_LIB_PATH, old_path);
 	if (putenv(new_path)) {
 		perror("couldn't putenv to set a new PATH");
-		free(new_path);
 	}
+	free(new_path);
 }
 
 extern void scan_elf_aux( char **envp);
-- 
1.7.0.4



