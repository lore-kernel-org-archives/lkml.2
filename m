Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031364Ab2HGWte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:49:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41483 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031321Ab2HGWrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:47:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 43/49] ASoC: wm8962: Allow VMID time to fully ramp
Date: Tue,  7 Aug 2012 15:45:01 -0700
Message-Id: <20120807222030.713657279@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 9d40e5582c9c4cfb6977ba2a0ca9c2ed82c56f21 upstream.

Required for reliable power up from cold.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8962.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -2890,6 +2890,9 @@ static int wm8962_set_bias_level(struct
 		/* VMID 2*250k */
 		snd_soc_update_bits(codec, WM8962_PWR_MGMT_1,
 				    WM8962_VMID_SEL_MASK, 0x100);
+
+		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF)
+			msleep(100);
 		break;
 
 	case SND_SOC_BIAS_OFF:


