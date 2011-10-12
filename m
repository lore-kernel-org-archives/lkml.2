Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab1JLOyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:54:07 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:46926
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752079Ab1JLOyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:54:04 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [alsa-devel] [PATCH 6/9] ASoC: da7210: bugfix for head phone
 volume control
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 20:35:34 +0530
Message-ID: <1318431934.12107.421.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch takes care of reserved bits of headphone volume
register by using correct volume range.

Tested on Samsung SMDK6410 board with DA7210 evaluation board.

Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
Signed-off-by: David Dajun Chen <dchen@diasemi.com>
---
 sound/soc/codecs/da7210.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index 60f403b..eb12c82 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -196,12 +196,15 @@
  * mute		: 0x10
  * reserved	: 0x00 - 0x0F
  *
- * ** FIXME **
- *
  * Reserved area are considered as "mute".
- * -> min = -79.5 dB
  */
-static const DECLARE_TLV_DB_SCALE(hp_out_tlv, -7950, 150, 1);
+static const unsigned int hp_out_tlv[] = {
+	TLV_DB_RANGE_HEAD(2),
+	0x0, 0x10, TLV_DB_SCALE_ITEM(TLV_DB_GAIN_MUTE, 0, 1),
+	/* -54 dB to +15 dB */
+	0x11, 0x3f, TLV_DB_SCALE_ITEM(-5400, 150, 0),
+};
+
 static const DECLARE_TLV_DB_SCALE(dac_gain_tlv, -7725, 75, 0);
 static const DECLARE_TLV_DB_SCALE(mic_vol_tlv, -600, 600, 0);
 static const DECLARE_TLV_DB_SCALE(aux2_vol_tlv, -600, 600, 0);
-- 
1.7.1


