Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab1ATDuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 22:50:55 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44976 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab1ATDux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 22:50:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=WNCilkodV69ep5RJIy32dvOxGLsGgD4ikH51Rq8AuQrE9g3whyZv/doNqz8JIc6NS4
         bJhrPUpMn1u89qwKzqyzcjffcrd9QKSnA6w714Vr6Nt/BSnskOxVAhxQJtH5BYTzwPYV
         +a30KhEEzNsdAMnAUBLOCKuO6wvXlR+4DceDY=
Subject: [PATCH] video: da8xx-fb: fix fb_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Content-Type: text/plain
Date: Thu, 20 Jan 2011 11:50:51 +0800
Message-Id: <1295495451.20884.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation puts CONFIG_CPU_FREQ at wrong place, CONFIG_CPU_FREQ
is for lcd_da8xx_cpufreq_deregister not for unregister_framebuffer.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/da8xx-fb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index c265aed..520047a 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -1092,9 +1092,10 @@ static int __init fb_probe(struct platform_device *device)
 
 irq_freq:
 #ifdef CONFIG_CPU_FREQ
+	lcd_da8xx_cpufreq_deregister(par);
+#endif
 err_cpu_freq:
 	unregister_framebuffer(da8xx_fb_info);
-#endif
 
 err_dealloc_cmap:
 	fb_dealloc_cmap(&da8xx_fb_info->cmap);
-- 
1.7.2



