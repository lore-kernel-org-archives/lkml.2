Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966040Ab1KJDsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:48:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966027Ab1KJDsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:48:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:05 2011
Message-Id: <20111109213204.944487103@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [223/264] ASoC: Ensure we always delay for WM8962 FLL when starting from SYSCLK
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 0b7dd6ad92b6cace35dc5d06d6e236c2751c85dc upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8962.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -2233,15 +2233,14 @@ static int sysclk_event(struct snd_soc_d
 
 			snd_soc_update_bits(codec, WM8962_FLL_CONTROL_1,
 					    WM8962_FLL_ENA, WM8962_FLL_ENA);
-			if (wm8962->irq) {
-				timeout = msecs_to_jiffies(5);
-				timeout = wait_for_completion_timeout(&wm8962->fll_lock,
-								      timeout);
 
-				if (timeout == 0)
-					dev_err(codec->dev,
-						"Timed out starting FLL\n");
-			}
+			timeout = msecs_to_jiffies(5);
+			timeout = wait_for_completion_timeout(&wm8962->fll_lock,
+							      timeout);
+
+			if (wm8962->irq && timeout == 0)
+				dev_err(codec->dev,
+					"Timed out starting FLL\n");
 		}
 		break;
 


