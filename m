Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab1BPCGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:06:30 -0500
Received: from kroah.org ([198.145.64.141]:48937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259Ab1BPBuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:05 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:58 2011
Message-Id: <20110216014658.905517434@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [046/115] ASoC: WM8990: msleep() takes milliseconds not jiffies
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

commit 7ebcf5d6021a696680ee77d9162a2edec2d671dd upstream.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8990.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -1185,7 +1185,7 @@ static int wm8990_set_bias_level(struct
 				     WM8990_VMIDTOG);
 
 			/* Delay to allow output caps to discharge */
-			msleep(msecs_to_jiffies(300));
+			msleep(300);
 
 			/* Disable VMIDTOG */
 			snd_soc_write(codec, WM8990_ANTIPOP2, WM8990_SOFTST |
@@ -1197,17 +1197,17 @@ static int wm8990_set_bias_level(struct
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
@@ -1252,7 +1252,7 @@ static int wm8990_set_bias_level(struct
 		/* Disable VMID */
 		snd_soc_write(codec, WM8990_POWER_MANAGEMENT_1, 0x1f01);
 
-		msleep(msecs_to_jiffies(300));
+		msleep(300);
 
 		/* Enable all output discharge bits */
 		snd_soc_write(codec, WM8990_ANTIPOP1, WM8990_DIS_LLINE |


