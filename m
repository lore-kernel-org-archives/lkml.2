Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab1A3Ulw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 15:41:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50806 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1A3Ulv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 15:41:51 -0500
From: Stefan Weil <weil@mail.berlios.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Stefan Weil <weil@mail.berlios.de>, Ralf Baechle <ralf@linux-mips.org>,
        Wu Zhangjin <wuzhangjin@gmail.com>,
        Arnaud Patard <apatard@mandriva.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS: Loongson: Fix potentially wrong string handling
Date: Sun, 30 Jan 2011 21:41:44 +0100
Message-Id: <1296420104-5679-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:nG43jotu6AUcUO34iS9wi7Ehk4HnpJ3hzy75Q5gd4sj
 jEy5Ja7ZDIVLYnc5lIN/TLb/cNZzHT0l3rFM2Z3FtO1HCkq71B
 mtcvMLjPSQfPbH87WXjCybtr6MOJB+neMqCP2FtWVegte6Ez4T
 oYB+psAv01LhrVN8AFrWvj7MMsbDa9HfEUEY0yzd9bWpKHDHZn
 Y6gVx3LDD0PUKMzGmkdkB9QgbUOc+0FXU9X67ulf5u+we3mIAh
 PDgJFI4CtmHP1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This error was reported by cppcheck:
arch/mips/loongson/common/machtype.c:56: error: Dangerous usage of 'str' (strncpy doesn't always 0-terminate it)

If strncpy copied MACHTYPE_LEN bytes, the destination string str
was not terminated.

The patch adds one more byte to str and makes sure that this byte is
always 0.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Arnaud Patard <apatard@mandriva.com>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 arch/mips/loongson/common/machtype.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/mips/loongson/common/machtype.c b/arch/mips/loongson/common/machtype.c
index 81fbe6b..2efd5d9 100644
--- a/arch/mips/loongson/common/machtype.c
+++ b/arch/mips/loongson/common/machtype.c
@@ -41,7 +41,7 @@ void __weak __init mach_prom_init_machtype(void)
 
 void __init prom_init_machtype(void)
 {
-	char *p, str[MACHTYPE_LEN];
+	char *p, str[MACHTYPE_LEN + 1];
 	int machtype = MACH_LEMOTE_FL2E;
 
 	mips_machtype = LOONGSON_MACHTYPE;
@@ -53,6 +53,7 @@ void __init prom_init_machtype(void)
 	}
 	p += strlen("machtype=");
 	strncpy(str, p, MACHTYPE_LEN);
+	str[MACHTYPE_LEN] = '\0';
 	p = strstr(str, " ");
 	if (p)
 		*p = '\0';
-- 
1.7.2.3

