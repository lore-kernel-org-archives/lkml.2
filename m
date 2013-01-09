Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315Ab3AIUoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:44:37 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:33410 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934178Ab3AIUnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:43:47 -0500
From: Olof Johansson <olof@lixom.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Leo Song <liangs@marvell.com>
Subject: [PATCH] drivers/rtc/rtc-pxa.c: fix fix set time sync time issue
Date: Wed,  9 Jan 2013 12:43:28 -0800
Message-Id: <1357764208-12714-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "fix set time sync time issue" adds calls to udelay(), but
doesn't add the include file. End result is build breakage:

drivers/rtc/rtc-pxa.c: In function 'pxa_rtc_set_time':
drivers/rtc/rtc-pxa.c:267:2: error: implicit declaration of function 'udelay' [-Werror=implicit-function-declaration]

Cc: Leo Song <liangs@marvell.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
---

Andrew, feel free to fold this into the previous patch (it's in mmotm
at the moment).


-Olof

 drivers/rtc/rtc-pxa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index 401b679..b7e46297 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
-- 
1.7.10.1.488.g05fbf7a

