Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444Ab1C3WEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:04:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:52250 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933250Ab1C3VG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621236209"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: dp@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [49/275] ASoC: WM8990: msleep() takes milliseconds not jiffies
Message-Id: <20110330210445.46FD33E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

commit 7ebcf5d6021a696680ee77d9162a2edec2d671dd upstream.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/soc/codecs/wm8990.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/sound/soc/codecs/wm8990.c
===================================================================
--- linux-2.6.35.y.orig/sound/soc/codecs/wm8990.c	2011-03-29 22:51:49.895446469 -0700
+++ linux-2.6.35.y/sound/soc/codecs/wm8990.c	2011-03-29 23:02:59.194320786 -0700
@@ -1185,7 +1185,7 @@
 				     WM8990_VMIDTOG);
 
 			/* Delay to allow output caps to discharge */
-			msleep(msecs_to_jiffies(300));
+			msleep(300);
 
 			/* Disable VMIDTOG */
 			snd_soc_write(codec, WM8990_ANTIPOP2, WM8990_SOFTST |
@@ -1197,17 +1197,17 @@
 			/* Enable outputs */
 			snd_soc_write(codec, WM8990_POWER_MANAGEMENT_1, 0x1b00);
 
-			msleep(msecs_to_jiffies(50));
+			msleep(50);
 
 			/* Enable VMID at 2x50k */
 			snd_soc_write(codec, WM8990_POWER_MANAGEMENT_1, 0x1f02);
 
-			msleep(msecs_to_jiffies(100));
+			msleep(100);
 
 			/* Enable VREF */
 			snd_soc_write(codec, WM8990_POWER_MANAGEMENT_1, 0x1f03);
 
-			msleep(msecs_to_jiffies(600));
+			msleep(600);
 
 			/* Enable BUFIOEN */
 			snd_soc_write(codec, WM8990_ANTIPOP2, WM8990_SOFTST |
@@ -1252,7 +1252,7 @@
 		/* Disable VMID */
 		snd_soc_write(codec, WM8990_POWER_MANAGEMENT_1, 0x1f01);
 
-		msleep(msecs_to_jiffies(300));
+		msleep(300);
 
 		/* Enable all output discharge bits */
 		snd_soc_write(codec, WM8990_ANTIPOP1, WM8990_DIS_LLINE |
