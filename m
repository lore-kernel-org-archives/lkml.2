Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2IQBV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:21:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33581 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289Ab2IQAuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:04 -0400
Message-Id: <20120917003643.618819414@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matteo Frigo <athena@fftw.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 126/135] ALSA: ice1724: Use linear scale for AK4396 volume control.
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matteo Frigo <athena@fftw.org>

commit 3737e2be505d872bf2b3c1cd4151b2d2b413d7b5 upstream.

The AK4396 DAC has a linear-scale attentuator, but
sound/pci/ice1712/prodigy_hifi.c used a log scale instead, which is
not quite right.  This patch restores the correct scale, borrowing
from the ak4396 code in sound/pci/oxygen/oxygen.c.

Signed-off-by: Matteo Frigo <athena@fftw.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/ice1712/prodigy_hifi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/ice1712/prodigy_hifi.c b/sound/pci/ice1712/prodigy_hifi.c
index 764cc93..075d5aa 100644
--- a/sound/pci/ice1712/prodigy_hifi.c
+++ b/sound/pci/ice1712/prodigy_hifi.c
@@ -297,6 +297,7 @@ static int ak4396_dac_vol_put(struct snd_kcontrol *kcontrol, struct snd_ctl_elem
 }
 
 static const DECLARE_TLV_DB_SCALE(db_scale_wm_dac, -12700, 100, 1);
+static const DECLARE_TLV_DB_LINEAR(ak4396_db_scale, TLV_DB_GAIN_MUTE, 0);
 
 static struct snd_kcontrol_new prodigy_hd2_controls[] __devinitdata = {
     {
@@ -307,7 +308,7 @@ static struct snd_kcontrol_new prodigy_hd2_controls[] __devinitdata = {
 	.info = ak4396_dac_vol_info,
 	.get = ak4396_dac_vol_get,
 	.put = ak4396_dac_vol_put,
-	.tlv = { .p = db_scale_wm_dac },
+	.tlv = { .p = ak4396_db_scale },
     },
 };
 


