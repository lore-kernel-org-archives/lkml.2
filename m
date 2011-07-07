Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab1GGQfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 12:35:14 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:51650 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1GGQfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 12:35:12 -0400
Subject: [PATCH 2/3] uml: drivers/slip_user.c memory leak fix
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, vitalivanov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 19:36:51 +0300
Message-ID: <1310056611.3528.50.camel@vivanov>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d4f92205b89eedb5054091b9fc0e0186e9acd88b Mon Sep 17 00:00:00 2001
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Thu, 7 Jul 2011 19:27:32 +0300
Subject: [PATCH 2/3] uml: drivers/slip_user.c memory leak fix

Do not free memory when you failed to allocate it.

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
---
 arch/um/drivers/slip_user.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/slip_user.c b/arch/um/drivers/slip_user.c
index a1c2d2c..cbacfc4 100644
--- a/arch/um/drivers/slip_user.c
+++ b/arch/um/drivers/slip_user.c
@@ -102,7 +102,7 @@ static int slip_tramp(char **argv, int fd)
 		       "buffer\n");
 		os_kill_process(pid, 1);
 		err = -ENOMEM;
-		goto out_free;
+		goto out_close;
 	}
 
 	close(fds[1]);
@@ -112,7 +112,6 @@ static int slip_tramp(char **argv, int fd)
 	err = helper_wait(pid);
 	close(fds[0]);
 
-out_free:
 	kfree(output);
 	return err;
 
-- 
1.7.0.4



