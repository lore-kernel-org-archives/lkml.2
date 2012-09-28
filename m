Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031405Ab2I1Umr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:42:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55696 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759576Ab2I1UlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:41:08 -0400
X-Sasl-enc: PiNikHeHHHGZhIxCA4I0sHRFl40ZfF8FaublysVFAOy+ 1348864868
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Matteo Frigo <athena@fftw.org>, Takashi Iwai <tiwai@suse.de>
Subject: [ 031/127] ALSA: ice1724: Use linear scale for AK4396 volume control.
Date: Fri, 28 Sep 2012 13:33:24 -0700
Message-Id: <20120928203049.484254156@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matteo Frigo <athena@fftw.org>

commit 3737e2be505d872bf2b3c1cd4151b2d2b413d7b5 upstream.

The AK4396 DAC has a linear-scale attentuator, but
sound/pci/ice1712/prodigy_hifi.c used a log scale instead, which is
not quite right.  This patch restores the correct scale, borrowing
from the ak4396 code in sound/pci/oxygen/oxygen.c.

Signed-off-by: Matteo Frigo <athena@fftw.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/ice1712/prodigy_hifi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/pci/ice1712/prodigy_hifi.c
+++ b/sound/pci/ice1712/prodigy_hifi.c
@@ -297,6 +297,7 @@ static int ak4396_dac_vol_put(struct snd
 }
 
 static const DECLARE_TLV_DB_SCALE(db_scale_wm_dac, -12700, 100, 1);
+static const DECLARE_TLV_DB_LINEAR(ak4396_db_scale, TLV_DB_GAIN_MUTE, 0);
 
 static struct snd_kcontrol_new prodigy_hd2_controls[] __devinitdata = {
     {
@@ -307,7 +308,7 @@ static struct snd_kcontrol_new prodigy_h
 	.info = ak4396_dac_vol_info,
 	.get = ak4396_dac_vol_get,
 	.put = ak4396_dac_vol_put,
-	.tlv = { .p = db_scale_wm_dac },
+	.tlv = { .p = ak4396_db_scale },
     },
 };
 


