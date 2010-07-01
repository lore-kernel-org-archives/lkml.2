Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab0GAVnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:43:37 -0400
Received: from kroah.org ([198.145.64.141]:32889 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759110Ab0GAVOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:22 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:56 2010
Message-Id: <20100701174256.228552829@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [116/200] ASoC: Fix dB scales for WM8400
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 3351e9fbb0fda6498ee149ee88c67f5849813c57 upstream.

These scales should be regular, not linear.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8400.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/sound/soc/codecs/wm8400.c
+++ b/sound/soc/codecs/wm8400.c
@@ -107,21 +107,21 @@ static void wm8400_codec_reset(struct sn
 	wm8400_reset_codec_reg_cache(wm8400->wm8400);
 }
 
-static const DECLARE_TLV_DB_LINEAR(rec_mix_tlv, -1500, 600);
+static const DECLARE_TLV_DB_SCALE(rec_mix_tlv, -1500, 600, 0);
 
-static const DECLARE_TLV_DB_LINEAR(in_pga_tlv, -1650, 3000);
+static const DECLARE_TLV_DB_SCALE(in_pga_tlv, -1650, 3000, 0);
 
-static const DECLARE_TLV_DB_LINEAR(out_mix_tlv, -2100, 0);
+static const DECLARE_TLV_DB_SCALE(out_mix_tlv, -2100, 0, 0);
 
-static const DECLARE_TLV_DB_LINEAR(out_pga_tlv, -7300, 600);
+static const DECLARE_TLV_DB_SCALE(out_pga_tlv, -7300, 600, 0);
 
-static const DECLARE_TLV_DB_LINEAR(out_omix_tlv, -600, 0);
+static const DECLARE_TLV_DB_SCALE(out_omix_tlv, -600, 0, 0);
 
-static const DECLARE_TLV_DB_LINEAR(out_dac_tlv, -7163, 0);
+static const DECLARE_TLV_DB_SCALE(out_dac_tlv, -7163, 0, 0);
 
-static const DECLARE_TLV_DB_LINEAR(in_adc_tlv, -7163, 1763);
+static const DECLARE_TLV_DB_SCALE(in_adc_tlv, -7163, 1763, 0);
 
-static const DECLARE_TLV_DB_LINEAR(out_sidetone_tlv, -3600, 0);
+static const DECLARE_TLV_DB_SCALE(out_sidetone_tlv, -3600, 0, 0);
 
 static int wm8400_outpga_put_volsw_vu(struct snd_kcontrol *kcontrol,
         struct snd_ctl_elem_value *ucontrol)
@@ -440,7 +440,7 @@ static int outmixer_event (struct snd_so
 /* INMIX dB values */
 static const unsigned int in_mix_tlv[] = {
 	TLV_DB_RANGE_HEAD(1),
-	0,7, TLV_DB_LINEAR_ITEM(-1200, 600),
+	0,7, TLV_DB_SCALE_ITEM(-1200, 600, 0),
 };
 
 /* Left In PGA Connections */


