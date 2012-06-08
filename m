Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab2FHFXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:23:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43232 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761222Ab2FHFHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:19 -0400
Message-Id: <20120608041846.614544095@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:23 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 43/82] ALSA: usb-audio: fix rate_list memory leak
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 5cd5d7c44990658df6ab49f6253c39617c53b03d upstream.

The array of sample rates is reallocated every time when opening
the PCM device, but was freed only once when unplugging the device.

Reported-by: "Alexander E. Patrakov" <patrakov@gmail.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/pcm.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 24839d9..cdf8b76 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -788,6 +788,9 @@ static int snd_usb_pcm_check_knot(struct snd_pcm_runtime *runtime,
 	int count = 0, needs_knot = 0;
 	int err;
 
+	kfree(subs->rate_list.list);
+	subs->rate_list.list = NULL;
+
 	list_for_each_entry(fp, &subs->fmt_list, list) {
 		if (fp->rates & SNDRV_PCM_RATE_CONTINUOUS)
 			return 0;


