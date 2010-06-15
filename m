Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab0FOO0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:26:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42129 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab0FOO0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oMbOfR9C0yqyvRHcn0gPMCvdX7VZnYW7eeUu9bp4YBTZuCiXbqPc7KlCCkAXWt+A+f
         01cY+Bn1lHM5bU6I34U1i2Lymlfb48ehb+aY/cFGgJ7LJfcMfU9dZqLrBYWeSzM9UJIU
         o5Vth7avLAjJRsZ0SybAmBqZ7L7/zpJKmNQsM=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
Subject: [PATCH] alsa: riptide: don't use own hex_to_bin() method
Date: Tue, 15 Jun 2010 17:26:28 +0300
Message-Id: <1276611988-28658-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
---
 sound/pci/riptide/riptide.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index ad44626..59d7996 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -97,6 +97,7 @@
 #include <linux/gameport.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
+#include <linux/kernel.h>
 #include <asm/io.h>
 #include <sound/core.h>
 #include <sound/info.h>
@@ -667,13 +668,12 @@ static u32 atoh(const unsigned char *in, unsigned int len)
 	unsigned char c;
 
 	while (len) {
+		int value;
+
 		c = in[len - 1];
-		if ((c >= '0') && (c <= '9'))
-			sum += mult * (c - '0');
-		else if ((c >= 'A') && (c <= 'F'))
-			sum += mult * (c - ('A' - 10));
-		else if ((c >= 'a') && (c <= 'f'))
-			sum += mult * (c - ('a' - 10));
+		value = hex_to_bin(c);
+		if (value >= 0)
+			sum += mult * value;
 		mult *= 16;
 		--len;
 	}
-- 
1.6.6.1

