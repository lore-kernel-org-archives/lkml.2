Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab1ABHpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:45:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:36243 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab1ABHYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Erik J. Staab" <ejs@insightbb.com>,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 161/260] ALSA: oxygen: fix analog capture on Claro halo cards
Date: Sun,  2 Jan 2011 02:17:37 -0500
Message-Id: <1293952756-15010-162-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:07.0009 (UTC) FILETIME=[E6B61F10:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik J. Staab <ejs@insightbb.com>

commit 0873a5ae747847ee55a63db409dff3476e45bcd9 upstream.

On the HT-Omega Claro halo card, the ADC data must be captured from the
second I2S input.  Using the default first input, which isn't connected
to anything, would result in silence.

Signed-off-by: Erik J. Staab <ejs@insightbb.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/oxygen/oxygen.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/sound/pci/oxygen/oxygen.c b/sound/pci/oxygen/oxygen.c
index 289cb4d..6c0a11a 100644
--- a/sound/pci/oxygen/oxygen.c
+++ b/sound/pci/oxygen/oxygen.c
@@ -543,6 +543,10 @@ static int __devinit get_oxygen_model(struct oxygen *chip,
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
-- 
1.7.3.3

