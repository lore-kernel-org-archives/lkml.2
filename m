Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab0GWWQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 18:16:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53702 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab0GWWQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 18:16:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=q4/jfRgQ+/nEo5DoOJpj95CXkn4X2BIZEbl83eLjjCuu+mj70WeeHhmHrnpDeiPzOB
         FX1U7wUepJ+tAw2/1TgWmmDkRQQJr07Q+1ZFmOXSIjzyTDab4fkYHfA+i8ORyBeRK+7d
         K309mJczK6Ixp/2tRBg8bsmUTJ8ie4eytgJrI=
MIME-Version: 1.0
Date: Fri, 23 Jul 2010 23:16:52 +0100
Message-ID: <AANLkTin5f_mfe+Jjo7Uv0mLyoQzM3KR3FK5=ejjTg=7D@mail.gmail.com>
Subject: [2.6.35-rc6] quiesce EDAC initialisation on desktop/mobile i7
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A small fixlet for 2.6.35-rc7/final.

---

Don't print failure to detect Core i7 EDAC facilities to the console at boot
time, most often occurring on Core i7 desktops and laptops.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index cc9357d..e0187d1 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1300,7 +1300,7 @@ int i7core_get_onedevice(struct pci_dev **prev, int devno,
 		if (devno == 0)
 			return -ENODEV;

-		i7core_printk(KERN_ERR,
+		i7core_printk(KERN_INFO,
 			"Device not found: dev %02x.%d PCI ID %04x:%04x\n",
 			dev_descr->dev, dev_descr->func,
 			PCI_VENDOR_ID_INTEL, dev_descr->dev_id);

-- 
Daniel J Blueman
