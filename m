Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab1GDXPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 19:15:46 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:43241 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab1GDXPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 19:15:45 -0400
Subject: [PATCH 1/4] uml: cow_user.c warning corrections
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Reply-To: vitalivanov@gmail.com
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: user-mode-linux-devel@lists.sourceforge.net,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 02:15:41 +0300
Message-ID: <1309821341.4527.5.camel@vitaliy-Vostro-1400>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6201d3e862fca8670b206338dc90303ea0acc77d Mon Sep 17 00:00:00 2001
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Tue, 5 Jul 2011 01:57:51 +0300
Subject: [PATCH 1/4] uml: cow_user.c warning corrections
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

arch/um/drivers/cow_user.c: In function ‘absolutize’:
arch/um/drivers/cow_user.c:189:7: warning: ignoring return value of ‘chdir’, declared with attribute warn_unused_result

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
---
 arch/um/drivers/cow_user.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/cow_user.c b/arch/um/drivers/cow_user.c
index 93f227a..9cbb426 100644
--- a/arch/um/drivers/cow_user.c
+++ b/arch/um/drivers/cow_user.c
@@ -186,7 +186,11 @@ static int absolutize(char *to, int size, char *from)
 		strcat(to, "/");
 		strcat(to, from);
 	}
-	chdir(save_cwd);
+	if (chdir(save_cwd)) {
+		cow_printf("absolutize : Can't cd to '%s' - "
+			   "errno = %d\n", save_cwd, errno);
+		return -1;
+	}
 	return 0;
 }
 
-- 
1.7.4.1



