Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2AXC57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:57:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932590Ab2AXCrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:47:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:32 2012
Message-Id: <20120124023932.379992335@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [095/129] ALSA: virtuoso: Xonar DS: fix polarity of front output
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1146
Lines: 30

From: Clemens Ladisch <clemens@ladisch.de>

commit f0e48b6bd4e407459715240cd241ddb6b89bdf81 upstream.

The two DACs for the front output and the surround/center/LFE/back
outputs are wired up out of phase, so when channels are duplicated,
their sound can cancel out each other and result in a weaker bass
response.  To fix this, reverse the polarity of the neutron flow to
the front output.

Reported-any-tested-by: Daniel Hill <daniel@enemyplanet.geek.nz>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/oxygen/xonar_wm87x6.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/oxygen/xonar_wm87x6.c
+++ b/sound/pci/oxygen/xonar_wm87x6.c
@@ -177,6 +177,7 @@ static void wm8776_registers_init(struct
 	struct xonar_wm87x6 *data = chip->model_data;
 
 	wm8776_write(chip, WM8776_RESET, 0);
+	wm8776_write(chip, WM8776_PHASESWAP, WM8776_PH_MASK);
 	wm8776_write(chip, WM8776_DACCTRL1, WM8776_DZCEN |
 		     WM8776_PL_LEFT_LEFT | WM8776_PL_RIGHT_RIGHT);
 	wm8776_write(chip, WM8776_DACMUTE, chip->dac_mute ? WM8776_DMUTE : 0);


