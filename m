Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab0LVAD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:03:56 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:52810 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab0LVADy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=PD3CkGSJu/jow5B6Zm2MwBdHPpjehspqEk4SO8635WXXk4NVKM5bUno0wDA88iqZyQ
         h4VAXQ6CkgQ7NM1d6ce3dphdXGKgg7OK4zJMaP/9aASOSX2WgxKv4W8wdxXMnGqCftvo
         VFNO+gCmMgF1jyHF31Kjtxhdxd+RWf9/xP4FQ=
Date: Wed, 22 Dec 2010 03:03:51 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] jz4740-battery: Should include linux/io.h
Message-ID: <20101222000351.GA23248@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During test-build (with disabled 'depends on') I found that
jz4740-battery driver lacks linux/io.h, which makes build break
like this (on x86):

  CC [M]  drivers/power/isp1704_charger.o
jz4740-battery.c: In function 'jz_battery_read_voltage':
jz4740-battery.c:84: error: implicit declaration of function 'readw’
jz4740-battery.c: In function 'jz_battery_probe':
jz4740-battery.c:284: error: implicit declaration of function 'ioremap_nocache’
jz4740-battery.c:285: warning: assignment makes pointer from integer without a cast
jz4740-battery.c:372: error: implicit declaration of function 'iounmap'
make[2]: *** [drivers/power/jz4740-battery.o] Error 1

This patch fixes the issues, and thus makes it easier to build-test
the driver for me.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---

I applied this to battery-2.6.git.

 drivers/power/jz4740-battery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index 5b48215..02414db 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/io.h>
 
 #include <linux/delay.h>
 #include <linux/gpio.h>
-- 
1.7.0.5
