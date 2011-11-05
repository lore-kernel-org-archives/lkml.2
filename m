Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab1KEGrb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 02:47:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54394 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1KEGra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 02:47:30 -0400
Message-ID: <1320475639.8360.1.camel@phoenix>
Subject: [PATCH 1/2] ASoC: wm9081: Fix reading wrong register for setting
 VMID 2*240k
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Sat, 05 Nov 2011 14:47:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMID Divider Enable and Select is controlled by BIT[2:1] of WM9081_VMID_CONTROL
register (04h).
Current code reads wrong register (WM9081_BIAS_CONTROL_1) for setting
VMID 2*240k.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm9081.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index 3cd35a0..fe65618 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -818,7 +818,7 @@ static int wm9081_set_bias_level(struct snd_soc_codec *codec,
 		}
 
 		/* VMID 2*240k */
-		reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
+		reg = snd_soc_read(codec, WM9081_VMID_CONTROL);
 		reg &= ~WM9081_VMID_SEL_MASK;
 		reg |= 0x04;
 		snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
-- 
1.7.5.4



