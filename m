Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab1C0KRZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 06:17:25 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36663 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab1C0KRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 06:17:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=dIYRyuTk3BMZ6eE4jXqCKZIsbhSY+Ua8b/RhHZhni9x3kXQmHq5j52+3QSyrOtsvwH
         B+T4vfx6J+Nd3mVkef8X6m4dzN07fE9rB0iI36r210h53GClczFtKanBDa9Im/sFPouZ
         1ZgaE5ngf9uMW+fOJS+9zkgybSbXTyP0qo+Ig=
MIME-Version: 1.0
Date: Sun, 27 Mar 2011 13:17:23 +0300
Message-ID: <AANLkTiksQLHDhHSBJG9Xj8n7Lykg9Jpxb3BS739LFEQP@mail.gmail.com>
Subject: [PATCH] cris/arch-v32: cryptocop: Use kzalloc
From: Maxin John <maxin.john@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jesper Nilsson <jesper.nilsson@axis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids unnecessary explicit initialization by allocating zeroed memory.

Signed-off-by: Maxin B. John<maxin.john@gmail.com>
---
diff --git a/arch/cris/arch-v32/drivers/cryptocop.c
b/arch/cris/arch-v32/drivers/cryptocop.c
index c03bc3b..f51b524 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -1394,11 +1394,10 @@ static int create_md5_pad(int alloc_flag,
unsigned long long hashed_length, char

        if (padlen < MD5_MIN_PAD_LENGTH) padlen += MD5_BLOCK_LENGTH;

-       p = kmalloc(padlen, alloc_flag);
+       p = kzalloc(padlen, alloc_flag);
        if (!p) return -ENOMEM;

        *p = 0x80;
-       memset(p+1, 0, padlen - 1);

        DEBUG(printk("create_md5_pad: hashed_length=%lld bits == %lld
bytes\n", bit_length, hashed_length));

@@ -1426,11 +1425,10 @@ static int create_sha1_pad(int alloc_flag,
unsigned long long hashed_length, cha

        if (padlen < SHA1_MIN_PAD_LENGTH) padlen += SHA1_BLOCK_LENGTH;

-       p = kmalloc(padlen, alloc_flag);
+       p = kzalloc(padlen, alloc_flag);
        if (!p) return -ENOMEM;

        *p = 0x80;
-       memset(p+1, 0, padlen - 1);

        DEBUG(printk("create_sha1_pad: hashed_length=%lld bits == %lld
bytes\n", bit_length, hashed_length));

---
