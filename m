Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934342Ab1ESS1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:27:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35969 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934302Ab1ESS1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:27:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CYRXlKSRpjSN2BjW87VPFHZjtblxKYVLdlsK5dVKaD0FKMxG723e1vhCopdYUKUIaj
         F3SMKh5UNf2vvxXEKu3qrxtydt75TFc3NB4tzz/ocGpxSuRdAnLnx4hqJgCM7wlvSKok
         byir54ZKRourFh4i/O6iTEmF30SitI2C4JMjk=
Date: Thu, 19 May 2011 21:27:03 +0300
From: Maxin B John <maxin.john@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tim.gardner@canonical.com, airlied@redhat.com,
        lethal@linux-sh.org, james@albanarts.com, error27@gmail.com,
        randy.dunlap@oracle.com
Subject: [PATCH] drivers: video: Remove useless checks
Message-ID: <20110519182702.GA3337@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing unsigned less than zero will never be true.
Removing similar checks from 'fbmem.c' and 'fbcmap.c'.

Please let me know your comments.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
index 5c3960d..15cf8fc 100644
--- a/drivers/video/fbcmap.c
+++ b/drivers/video/fbcmap.c
@@ -285,8 +285,7 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
 		rc = -ENODEV;
 		goto out;
 	}
-	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
-				!info->fbops->fb_setcmap)) {
+	if (!info->fbops->fb_setcolreg && !info->fbops->fb_setcmap) {
 		rc = -EINVAL;
 		goto out1;
 	}
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 5aac00e..9edca4d 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1143,7 +1143,7 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			return -EFAULT;
 		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
 			return -EINVAL;
-		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX)
+		if (con2fb.framebuffer >= FB_MAX)
 			return -EINVAL;
 		if (!registered_fb[con2fb.framebuffer])
 			request_module("fb%d", con2fb.framebuffer);
