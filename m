Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab2GPGao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:30:44 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:40170 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab2GPGam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:30:42 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH] wss_lib: Fix resume on Yamaha OPL3-SAx
Date: Mon, 16 Jul 2012 08:30:18 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201207160830.18826.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yamaha OPL3-SAx chips don't resume properly when playback is running -
garbage is played after resume. Restoring the CS4231_PLAYBK_FORMAT register
last fixes the problem.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/sound/isa/wss/wss_lib.c
+++ b/sound/isa/wss/wss_lib.c
@@ -1656,6 +1656,10 @@ static void snd_wss_resume(struct snd_wss *chip)
 			break;
 		}
 	}
+	/* Yamaha needs this to resume properly */
+	if (chip->hardware == WSS_HW_OPL3SA2)
+		snd_wss_out(chip, CS4231_PLAYBK_FORMAT,
+			    chip->image[CS4231_PLAYBK_FORMAT]);
 	spin_unlock_irqrestore(&chip->reg_lock, flags);
 #if 1
 	snd_wss_mce_down(chip);

-- 
Ondrej Zary
