Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab2FGEYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:24:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54880 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537Ab2FGEYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:24:43 -0400
Message-Id: <20120607041401.623007937@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:22 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Alexander E. Patrakov" <patrakov@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 24/47] ALSA: usb-audio: fix rate_list memory leak
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 5cd5d7c44990658df6ab49f6253c39617c53b03d upstream.

The array of sample rates is reallocated every time when opening
the PCM device, but was freed only once when unplugging the device.

Reported-by: "Alexander E. Patrakov" <patrakov@gmail.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -670,6 +670,9 @@ static int snd_usb_pcm_check_knot(struct
 	int count = 0, needs_knot = 0;
 	int err;
 
+	kfree(subs->rate_list.list);
+	subs->rate_list.list = NULL;
+
 	list_for_each_entry(fp, &subs->fmt_list, list) {
 		if (fp->rates & SNDRV_PCM_RATE_CONTINUOUS)
 			return 0;


