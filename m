Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422674Ab2I1T5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:57:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964809Ab2I1S4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:56:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Matteo Frigo <athena@fftw.org>, Takashi Iwai <tiwai@suse.de>
Subject: [ 057/262] ALSA: ice1724: Use linear scale for AK4396 volume control.
Date: Fri, 28 Sep 2012 11:49:46 -0700
Message-Id: <20120928183004.622755751@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
 


