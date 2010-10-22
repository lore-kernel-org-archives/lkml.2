Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab0JVT0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:26:17 -0400
Received: from kroah.org ([198.145.64.141]:33854 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759128Ab0JVSzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:55:48 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:27 2010
Message-Id: <20101022185227.562240896@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Erik J. Staab" <ejs@insightbb.com>,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [003/103] ALSA: oxygen: fix analog capture on Claro halo cards
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Erik J. Staab <ejs@insightbb.com>

commit 0873a5ae747847ee55a63db409dff3476e45bcd9 upstream.

On the HT-Omega Claro halo card, the ADC data must be captured from the
second I2S input.  Using the default first input, which isn't connected
to anything, would result in silence.

Signed-off-by: Erik J. Staab <ejs@insightbb.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/oxygen/oxygen.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/pci/oxygen/oxygen.c
+++ b/sound/pci/oxygen/oxygen.c
@@ -543,6 +543,10 @@ static int __devinit get_oxygen_model(st
 		chip->model.suspend = claro_suspend;
 		chip->model.resume = claro_resume;
 		chip->model.set_adc_params = set_ak5385_params;
+		chip->model.device_config = PLAYBACK_0_TO_I2S |
+					    PLAYBACK_1_TO_SPDIF |
+					    CAPTURE_0_FROM_I2S_2 |
+					    CAPTURE_1_FROM_SPDIF;
 		break;
 	}
 	if (id->driver_data == MODEL_MERIDIAN ||


