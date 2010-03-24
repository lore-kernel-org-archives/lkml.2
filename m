Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab0CXL6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:58:47 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:50227 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab0CXL6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:58:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=ZmlO4AAjrOejQfWZ2LkIa3ysWR6FIr/b9TnszOByDWGF3BIRhfWPW5beZGtNKGhG8+
         xyxO7nMvspHr7eNnJ1R80WbBoBrGb0jWGxYfYh5THVNwAUaag6aK50J7O3+oqilQcI08
         d5piQBRHLEGNew8SxA6rwcSvIJULUosYDXbJo=
Date: Wed, 24 Mar 2010 14:58:34 +0300
From: Dan Carpenter <error27@gmail.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Joonyoung Shim <jy0922.shim@samsung.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] wm8994: playback => capture
Message-ID: <20100324115834.GG21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Liam Girdwood <lrg@slimlogic.co.uk>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse caught that initialize "playback" two times instead of
initializing "capture".

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 29f3771..d10d651 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3401,7 +3401,7 @@ struct snd_soc_dai wm8994_dai[] = {
 			.rates = WM8994_RATES,
 			.formats = WM8994_FORMATS,
 		},
-		.playback = {
+		.capture = {
 			.stream_name = "AIF3 Capture",
 			.channels_min = 2,
 			.channels_max = 2,
