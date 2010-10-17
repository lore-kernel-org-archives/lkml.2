Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab0JQOlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:41:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61194 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214Ab0JQOl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ACCBKyxjctDwNJa9uO70dk+4faWhsVGd0kiAm3FjR9835vMulaiUGLI9fDEZwmiTJs
         RZpWMzlA9nqMNJrptiv9QLEvb5DFfkwAp5XaOEjMXOSH+F+yxNjxf4R8LTZIDuKIBkVq
         xWOOdmFcLAqAJuauD7F5fi5Ez8rlCgjbUGXLk=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] char: mwave: fix information leak to userland
Date: Sun, 17 Oct 2010 18:41:20 +0400
Message-Id: <1287326481-7985-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure rAbilities is copied to userland with uart_enable, mwave_os_name
and bios_task_name array end elements and some padding fields unitialized.
It leads to leaking of stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/char/mwave/mwavedd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mwave/mwavedd.c b/drivers/char/mwave/mwavedd.c
index 1d82d58..73b6880 100644
--- a/drivers/char/mwave/mwavedd.c
+++ b/drivers/char/mwave/mwavedd.c
@@ -165,6 +165,7 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 				"mwavedd::mwave_ioctl,"
 				" IOCTL_MW_DSP_ABILITIES calling"
 				" tp3780I_QueryAbilities\n");
+			memset(&rAbilities, 0, sizeof(MW_ABILITIES));
 			mutex_lock(&mwave_mutex);
 			retval = tp3780I_QueryAbilities(&pDrvData->rBDData,
 					&rAbilities);
-- 
1.7.0.4

