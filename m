Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab1EQR3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:29:10 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:55605 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab1EQR3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:29:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer;
        b=jhtWaImdpok8fwVb6hvA7WZ769ohyDb9gWv+mwcULSn34KmPIehorSYGOgmrolgdRN
         S/Ea8KQF/yCPkbkmrv2wM9nxvTaCCQUiY9oM9WdSNGESxAHar1wOxxcgq1scMrXnzQKq
         yuBiXI3FgCLOO/01nbD5Jn+wp+KEg9deu3TOw=
Subject: [PATCH 2/2] trivial: Changed the printk loglevel when not able to
 allocate memory
From: anish <anish198519851985@gmail.com>
To: linux@arm.linux.org.uk, lethal@linux-sh.org
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-Pcngg4g4Wi+OELAs/4bI"
Date: Tue, 17 May 2011 22:59:02 +0530
Message-ID: <1305653342.2182.15.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Pcngg4g4Wi+OELAs/4bI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

When not able to allocate memory we were using KERN_INFO as 
log level in printk so changed to KERN_ERR
 Signed-off-by: anish kumar<anish198519851985@gmail.com>

---
 drivers/video/amba-clcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
index cb7ec86..e87d98b 100644
--- a/drivers/video/amba-clcd.c
+++ b/drivers/video/amba-clcd.c
@@ -551,7 +551,7 @@ static int clcdfb_probe(struct amba_device *dev, const struct amba_id *id)
 
 	fb = kzalloc(sizeof(*fb), GFP_KERNEL);
 	if (!fb) {
-		printk(KERN_INFO "CLCD: could not allocate new clcd_fb struct\n");
+		printk(KERN_ERR "CLCD: could not allocate new clcd_fb struct\n");
 		ret = -ENOMEM;
 		goto free_region;
 	}
-- 
1.7.0.4



--=-Pcngg4g4Wi+OELAs/4bI
Content-Disposition: attachment; filename*0=0002-Changed-the-printk-loglevel-when-not-able-to-allocat.pat; filename*1=ch
Content-Type: text/x-patch; name="0002-Changed-the-printk-loglevel-when-not-able-to-allocat.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 19bbb666a6067a6ba280e2cb984c924bcaf06f52 Mon Sep 17 00:00:00 2001
From: anish kumar <anish198519851985@gmail.com>
Date: Tue, 17 May 2011 22:50:59 +0530
Subject: [PATCH 2/2] Changed the printk loglevel when not able to allocate memory
 When not able to allocate memory we were using KERN_INFO so just
 changed to KERN_ERR
 Signed-off-by: anish kumar<anish198519851985@gmail.com>

---
 drivers/video/amba-clcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
index cb7ec86..e87d98b 100644
--- a/drivers/video/amba-clcd.c
+++ b/drivers/video/amba-clcd.c
@@ -551,7 +551,7 @@ static int clcdfb_probe(struct amba_device *dev, const struct amba_id *id)
 
 	fb = kzalloc(sizeof(*fb), GFP_KERNEL);
 	if (!fb) {
-		printk(KERN_INFO "CLCD: could not allocate new clcd_fb struct\n");
+		printk(KERN_ERR "CLCD: could not allocate new clcd_fb struct\n");
 		ret = -ENOMEM;
 		goto free_region;
 	}
-- 
1.7.0.4


--=-Pcngg4g4Wi+OELAs/4bI--

