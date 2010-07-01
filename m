Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab0GAVnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:43:52 -0400
Received: from kroah.org ([198.145.64.141]:32884 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759106Ab0GAVOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:21 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:56 2010
Message-Id: <20100701174256.144971780@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [115/200] ASoC: Fix dB scales for WM835x
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit e6a08c5a8990102bcd1f4bae84b668da6c23caa9 upstream.

These should be regular rather than linear scales.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
index e5a48da..c342c2c 100644
--- a/sound/soc/codecs/wm8350.c
+++ b/sound/soc/codecs/wm8350.c
@@ -425,8 +425,8 @@ static const struct soc_enum wm8350_enum[] = {
 	SOC_ENUM_SINGLE(WM8350_INPUT_MIXER_VOLUME, 15, 2, wm8350_lr),
 };
 
-static DECLARE_TLV_DB_LINEAR(pre_amp_tlv, -1200, 3525);
-static DECLARE_TLV_DB_LINEAR(out_pga_tlv, -5700, 600);
+static DECLARE_TLV_DB_SCALE(pre_amp_tlv, -1200, 3525, 0);
+static DECLARE_TLV_DB_SCALE(out_pga_tlv, -5700, 600, 0);
 static DECLARE_TLV_DB_SCALE(dac_pcm_tlv, -7163, 36, 1);
 static DECLARE_TLV_DB_SCALE(adc_pcm_tlv, -12700, 50, 1);
 static DECLARE_TLV_DB_SCALE(out_mix_tlv, -1500, 300, 1);


