Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0FZCbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 22:31:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48951 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab0FZCbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 22:31:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:references:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=ZMnYikaT7weMgemNiD5/lVLU/q0Z8ourRImPy/6zessNELD5PKFs6jmKDk1A1j0su3
         Xwzs0ljlH92luQGQtOsgBLhoF20F5L5gsc0NNVhZlfYbzfx2WNjnY2ElXrex0ebHy4yK
         wVNPdjSRWqAD+V2d+JCqhoJ5Xo15FTNBxvZGc=
Date: Sat, 26 Jun 2010 10:31:09 +0800
From: "coffbeta" <coffbeta@gmail.com>
To: "Henrik Kretzschmar" <henne@nachtwindheim.de>,
       "Andy Shevchenko" <ext-andriy.shevchenko@nokia.com>,
       "Andy Shevchenko" <andy.shevchenko@gmail.com>,
       "Jason Wessel" <jason.wessel@windriver.com>,
       "kgdb-bugreport" <kgdb-bugreport@lists.sourceforge.net>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Martin Hicks" <mort@sgi.com>
References: <1276768884-19958-1-git-send-email-henne@nachtwindheim.de>
Subject: Re: [PATCH] fbdev: section cleanup in viafb driver
Message-ID: <201006261031082655190@gmail.com>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o5Q2VXim009329


             -static void __devexit via_teardown_subdevs(void)
------------------				 
coffbeta
2010-06-26

-------------------------------------------------------------
·¢¼şÈË£ºHenrik Kretzschmar
·¢ËÍÈÕÆÚ£º2010-06-17 18:09:34
ÊÕ¼şÈË£ºJosephChan; ScottFang
³­ËÍ£ºcorbet; FlorianSchandinat; linux-fbdev; linux-kernel; Henrik Kretzschmar
Ö÷Ìâ£º[PATCH] fbdev: section cleanup in viafb driver

This patch moves two functions from .devexit to .text,
which are called on the probe error path.
Also a function which is called by probe is moved
from .text to .devinit.

WARNING: vmlinux.o(.devinit.text+0x2ca5): Section mismatch in reference
from the function via_pci_probe() to the function
.devexit.text:via_teardown_subdevs()
The function __devinit via_pci_probe() references
a function __devexit via_teardown_subdevs().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
via_teardown_subdevs() so it may be used outside an exit section.

WARNING: vmlinux.o(.devinit.text+0x2cb1): Section mismatch in reference
from the function via_pci_probe() to the function
.devexit.text:via_pci_teardown_mmio()
The function __devinit via_pci_probe() references
a function __devexit via_pci_teardown_mmio().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
via_pci_teardown_mmio() so it may be used outside an exit section.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
This patch is compile tested against Linus lastest git kernel.

 drivers/video/via/via-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index e8cfe83..ec2e5aa 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -64,7 +64,7 @@ static inline int viafb_mmio_read(int reg)
  */
 static u32 viafb_enabled_ints;
 
-static void viafb_int_init(void)
+static void __devinit viafb_int_init(void)
 {
 	viafb_enabled_ints = 0;
 
@@ -489,7 +489,7 @@ out_unmap:
 	return ret;
 }
 
-static void __devexit via_pci_teardown_mmio(struct viafb_dev *vdev)
+static void via_pci_teardown_mmio(struct viafb_dev *vdev)
 {
 	iounmap(vdev->fbmem);
 	iounmap(vdev->engine_mmio);
@@ -548,7 +548,7 @@ static int __devinit via_setup_subdevs(struct viafb_dev *vdev)
 	return 0;
 }
 
-static void __devexit via_teardown_subdevs(void)
+static void via_teardown_subdevs(void)
 {
 	int i;
 
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
