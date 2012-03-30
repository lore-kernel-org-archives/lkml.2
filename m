Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936351Ab2C3Vsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:48:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965925Ab2C3VU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:20:26 -0400
Message-Id: <20120330194838.747395828@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anssi Hannula <anssi.hannula@iki.fi>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 073/175] ALSA: hda - fix printing of high HDMI sample rates
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anssi Hannula <anssi.hannula@iki.fi>

commit 25dc16f69892182192b1234594fd3cf342ad4195 upstream.

A previous commit af65cbf296 (ALSA: hdmi: fix printout of SAD sampling
rates) fixed the sample rates shown in /proc/asound/cardX/eldY and
kernel log to not be entirely wrong. However, a missing rate from the
array added in the patch causes HDMI rates 88.2 kHz, 96 kHz, 176.4 kHz,
and 192 kHz to be shown as 96 kHz, 176.4 kHz, 192 kHz, and 384 kHz,
respectively.

Fix the reporting by adding the ALSA rate 64 kHz into the conversion
array between 48 kHz and 88.2 kHz.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_eld.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -385,8 +385,8 @@ error:
 static void hdmi_print_pcm_rates(int pcm, char *buf, int buflen)
 {
 	static unsigned int alsa_rates[] = {
-		5512, 8000, 11025, 16000, 22050, 32000, 44100, 48000, 88200,
-		96000, 176400, 192000, 384000
+		5512, 8000, 11025, 16000, 22050, 32000, 44100, 48000, 64000,
+		88200, 96000, 176400, 192000, 384000
 	};
 	int i, j;
 


