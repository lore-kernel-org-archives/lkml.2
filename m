Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab0HXW6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:58:15 -0400
Received: from kroah.org ([198.145.64.141]:52431 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800Ab0HXW6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:09 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:12 2010
Message-Id: <20100824224212.844885163@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
        Takashi Iwai <tiwai@suse.de>
Subject: [09/91] ALSA: hda - Fix missing stream for second ADC on Realtek ALC260 HDA codec
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

commit 53bacfbbb2ddd981287b58a511c8b8f5df179886 upstream.

I discovered tonight that ALSA no longer sets up a stream for the second ADC
provided by the Realtek ALC260 HDA codec.  At some point alc_build_pcms()
started using stream_analog_alt_capture when constructing the second ADC
stream, but patch_alc260() was never updated accordingly.  I have no idea
when this regression occurred.  The trivial patch to patch_alc260() given
below fixes the problem as far as I can tell.  The patch is against 2.6.35.

Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6757,6 +6757,7 @@ static int patch_alc260(struct hda_codec
 
 	spec->stream_analog_playback = &alc260_pcm_analog_playback;
 	spec->stream_analog_capture = &alc260_pcm_analog_capture;
+	spec->stream_analog_alt_capture = &alc260_pcm_analog_capture;
 
 	spec->stream_digital_playback = &alc260_pcm_digital_playback;
 	spec->stream_digital_capture = &alc260_pcm_digital_capture;


