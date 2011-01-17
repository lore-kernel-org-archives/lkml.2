Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1AQIdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:33:14 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62820 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab1AQIdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:33:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=he2/XElxxw4L+CqlUpVAnzKrnSNcUTMkWgzXKe5jDqvT5angDJgdZZND1AfPIHp+wy
         mYY3c+HeEc+JUpmVa3CT1f7Xnwv5mALp+9Kv5ZrfgxYYNMiPHP5tKgXWW1f+55v0TN3C
         a13teZ/KjsdRIFonR/S5mJU/pcnvRgAnHaJ0U=
Subject: [PATCH 2/2] video: nuc900fb: properly free resources in
	nuc900fb_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Wang Qiang <rurality.linux@gmail.com>
In-Reply-To: <1295253143.12890.3.camel@mola>
References: <1295253143.12890.3.camel@mola>
Content-Type: text/plain
Date: Mon, 17 Jan 2011 16:33:42 +0800
Message-Id: <1295253222.12890.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f0064467b1f9696ebcade98ec75ef3fbc6cfe38f Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 17 Jan 2011 16:25:57 +0800
Subject: [PATCH 2/2] video: nuc900fb: properly free resources in nuc900fb_remove

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/nuc900fb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
index 29ef92f..f838d9e 100644
--- a/drivers/video/nuc900fb.c
+++ b/drivers/video/nuc900fb.c
@@ -696,6 +696,8 @@ static int nuc900fb_remove(struct platform_device *pdev)
 	nuc900fb_stop_lcd(fbinfo);
 	msleep(1);
 
+	unregister_framebuffer(fbinfo);
+	nuc900fb_cpufreq_deregister(fbi);
 	nuc900fb_unmap_video_memory(fbinfo);
 
 	iounmap(fbi->io);
-- 
1.7.2



