Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1GDXP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 19:15:56 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:43241 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab1GDXPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 19:15:50 -0400
Subject: [PATCH 2/4] uml: helper.c warning corrections
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Reply-To: vitalivanov@gmail.com
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 02:15:47 +0300
Message-ID: <1309821347.4527.6.camel@vitaliy-Vostro-1400>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7296c5b9770e95cd6ad4e9e71d2d14c972abdfe1 Mon Sep 17 00:00:00 2001
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Tue, 5 Jul 2011 02:03:06 +0300
Subject: [PATCH 2/4] uml: helper.c warning corrections
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

arch/um/os-Linux/helper.c: In function ‘helper_child’:
arch/um/os-Linux/helper.c:38:7: warning: ignoring return value of ‘write’, declared with attribute warn_unused_result

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
---
 arch/um/os-Linux/helper.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
index b6b1096..feff22d 100644
--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -28,14 +28,14 @@ static int helper_child(void *arg)
 {
 	struct helper_data *data = arg;
 	char **argv = data->argv;
-	int err;
+	int err, ret;
 
 	if (data->pre_exec != NULL)
 		(*data->pre_exec)(data->pre_data);
 	err = execvp_noalloc(data->buf, argv[0], argv);
 
 	/* If the exec succeeds, we don't get here */
-	write(data->fd, &err, sizeof(err));
+	CATCH_EINTR(ret = write(data->fd, &err, sizeof(err)));
 
 	return 0;
 }
-- 
1.7.4.1



