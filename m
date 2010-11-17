Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935492Ab0KQU0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:26:45 -0500
Received: from antispam01.maxim-ic.com ([205.153.101.182]:38918 "EHLO
	antispam01.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935282Ab0KQU0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:26:43 -0500
X-ASG-Debug-ID: 1290025602-1a8be26e0001-xx1T2L
X-Barracuda-Envelope-From: Jesse.Marroquin@maxim-ic.com
X-Barracuda-Apparent-Source-IP: 180.0.34.46
Message-ID: <4CE43A80.4050209@maxim-ic.com>
Date: Wed, 17 Nov 2010 14:26:40 -0600
From: Jesse Marroquin <jesse.marroquin@maxim-ic.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Hsiang <Peter.Hsiang@maxim-ic.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ASoC: Add support for MAX98089 CODEC
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [PATCH] ASoC: Add support for MAX98089 CODEC
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2010 20:27:06.0571 (UTC) FILETIME=[CD7929B0:01CB8695]
X-Barracuda-Connect: terlingua.dalsemi.com[180.0.34.46]
X-Barracuda-Start-Time: 1290025602
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.46915
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds initial support for the MAX98089 CODEC.

Signed-off-by: Jesse Marroquin <jesse.marroquin@maxim-ic.com>
---
 sound/soc/codecs/max98088.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index ef06007..9c32237 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -28,6 +28,11 @@
 #include <sound/max98088.h>
 #include "max98088.h"
 
+enum max98088_type {
+       MAX98088,
+       MAX98089,
+};
+
 struct max98088_cdata {
        unsigned int rate;
        unsigned int fmt;
@@ -36,6 +41,7 @@ struct max98088_cdata {
 
 struct max98088_priv {
        u8 reg_cache[M98088_REG_CNT];
+       enum max98088_type devtype;
        void *control_data;
        struct max98088_pdata *pdata;
        unsigned int sysclk;
@@ -2042,6 +2048,8 @@ static int max98088_i2c_probe(struct i2c_client *i2c,
        if (max98088 == NULL)
                return -ENOMEM;
 
+       max98088->devtype = id->driver_data;
+
        i2c_set_clientdata(i2c, max98088);
        max98088->control_data = i2c;
        max98088->pdata = i2c->dev.platform_data;
@@ -2061,7 +2069,8 @@ static int __devexit max98088_i2c_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id max98088_i2c_id[] = {
-       { "max98088", 0 },
+       { "max98088", MAX98088 },
+       { "max98089", MAX98089 },
        { }
 };
 MODULE_DEVICE_TABLE(i2c, max98088_i2c_id);
-- 
1.5.6.5

