Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053Ab2FGEm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:42:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab2FGESb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:18:31 -0400
Message-Id: <20120607040341.601087511@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:12 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Alexander E. Patrakov" <patrakov@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 36/82] ALSA: usb-audio: fix rate_list memory leak
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -699,6 +699,9 @@ static int snd_usb_pcm_check_knot(struct
 	int count = 0, needs_knot = 0;
 	int err;
 
+	kfree(subs->rate_list.list);
+	subs->rate_list.list = NULL;
+
 	list_for_each_entry(fp, &subs->fmt_list, list) {
 		if (fp->rates & SNDRV_PCM_RATE_CONTINUOUS)
 			return 0;


