Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab1GGQeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 12:34:24 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:53040 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab1GGQeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 12:34:23 -0400
Subject: [PATCH 1/3] uml: drivers/net_user.c memory leak fix
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, vitalivanov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 19:36:02 +0300
Message-ID: <1310056562.3528.49.camel@vivanov>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9b9f36f46aa708c3245f5ded83f96421966b2edf Mon Sep 17 00:00:00 2001
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Thu, 7 Jul 2011 19:23:13 +0300
Subject: [PATCH 1/3] uml: drivers/net_user.c memory leak fix

Perform memory cleanup on exit.
On receiving invalid 'pid' we still should clean 'output' variable.

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
---
 arch/um/drivers/net_user.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/net_user.c b/arch/um/drivers/net_user.c
index 9415dd9..989b653 100644
--- a/arch/um/drivers/net_user.c
+++ b/arch/um/drivers/net_user.c
@@ -228,10 +228,11 @@ static void change(char *dev, char *what, unsigned char *addr,
 		       "buffer\n");
 
 	pid = change_tramp(argv, output, output_len);
-	if (pid < 0) return;
 
 	if (output != NULL) {
-		printk("%s", output);
+		if (pid >= 0) {
+			printk("%s", output);
+		}
 		kfree(output);
 	}
 }
-- 
1.7.0.4



