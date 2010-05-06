Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab0EFRny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:43:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756668Ab0EFRnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:43:51 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com,
       Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 11/13] drivers/video: removing redundant ifdefs
Date: Thu,  6 May 2010 19:36:15 +0200
Message-Id: <1273167377-14270-12-git-send-email-jolsa@redhat.com>
In-Reply-To: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 drivers/video/atafb.c                   |    2 --
 drivers/video/matrox/matroxfb_DAC1064.c |    5 +----
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
index f3aada2..5b2b5ef 100644
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -1718,11 +1718,9 @@ static int falcon_setcolreg(unsigned int regno, unsigned int red,
 			(((red & 0xe000) >> 13) | ((red & 0x1000) >> 12) << 8) |
 			(((green & 0xe000) >> 13) | ((green & 0x1000) >> 12) << 4) |
 			((blue & 0xe000) >> 13) | ((blue & 0x1000) >> 12);
-#ifdef ATAFB_FALCON
 		((u32 *)info->pseudo_palette)[regno] = ((red & 0xf800) |
 						       ((green & 0xfc00) >> 5) |
 						       ((blue & 0xf800) >> 11));
-#endif
 	}
 	return 0;
 }
diff --git a/drivers/video/matrox/matroxfb_DAC1064.c b/drivers/video/matrox/matroxfb_DAC1064.c
index f9fa0fd..1717623 100644
--- a/drivers/video/matrox/matroxfb_DAC1064.c
+++ b/drivers/video/matrox/matroxfb_DAC1064.c
@@ -869,12 +869,9 @@ static int MGAG100_preinit(struct matrox_fb_info *minfo)
 	minfo->capable.plnwt = minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG100
 			? minfo->devflags.sgram : 1;
 
-#ifdef CONFIG_FB_MATROX_G
 	if (minfo->devflags.g450dac) {
 		minfo->outputs[0].output = &g450out;
-	} else
-#endif
-	{
+	} else {
 		minfo->outputs[0].output = &m1064;
 	}
 	minfo->outputs[0].src = minfo->outputs[0].default_src;
-- 
1.6.6.1

