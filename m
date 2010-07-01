Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab0GASjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:39:55 -0400
Received: from kroah.org ([198.145.64.141]:40562 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757932Ab0GASXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:38 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:13 2010
Message-Id: <20100701173213.386333846@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [patch 078/149] ASoC: Fix dB scales for WM8990
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit f68596c6d8711650722b2a54328a088a2c21bc5b upstream.

These should be regular, not linear.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8990.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -110,21 +110,21 @@ static const u16 wm8990_reg[] = {
 
 #define wm8990_reset(c) snd_soc_write(c, WM8990_RESET, 0)
 
-static const DECLARE_TLV_DB_LINEAR(rec_mix_tlv, -1500, 600);
+static const DECLARE_TLV_DB_SCALE(rec_mix_tlv, -1500, 600, 0);
 
-static const DECLARE_TLV_DB_LINEAR(in_pga_tlv, -1650, 3000);
+static const DECLARE_TLV_DB_SCALE(in_pga_tlv, -1650, 3000, 0);
 
-static const DECLARE_TLV_DB_LINEAR(out_mix_tlv, 0, -2100);
+static const DECLARE_TLV_DB_SCALE(out_mix_tlv, 0, -2100, 0);
 
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
 
 static int wm899x_outpga_put_volsw_vu(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol)
@@ -450,7 +450,7 @@ static int outmixer_event(struct snd_soc
 /* INMIX dB values */
 static const unsigned int in_mix_tlv[] = {
 	TLV_DB_RANGE_HEAD(1),
-	0, 7, TLV_DB_LINEAR_ITEM(-1200, 600),
+	0, 7, TLV_DB_SCALE_ITEM(-1200, 600, 0),
 };
 
 /* Left In PGA Connections */


