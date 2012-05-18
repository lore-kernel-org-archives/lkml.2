Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946930Ab2ERXS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:18:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58844 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946599Ab2ERXFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:05:51 -0400
Message-Id: <20120518212649.314002280@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:26:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mark Hills <mark@pogo.org.uk>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 01/47] ALSA: echoaudio: Remove incorrect part of assertion
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Hills <mark@pogo.org.uk>

commit c914f55f7cdfafe9d7d5b248751902c7ab57691e upstream.

This assertion seems to imply that chip->dsp_code_to_load is a pointer.
It's actually an integer handle on the actual firmware, and 0 has no
special meaning.

The assertion prevents initialisation of a Darla20 card, but would also
affect other models. It seems it was introduced in commit dd7b254d.

ALSA sound/pci/echoaudio/echoaudio.c:2061 Echoaudio driver starting...
ALSA sound/pci/echoaudio/echoaudio.c:1969 chip=ebe4e000
ALSA sound/pci/echoaudio/echoaudio.c:2007 pci=ed568000 irq=19 subdev=0010 Init hardware...
ALSA sound/pci/echoaudio/darla20_dsp.c:36 init_hw() - Darla20
------------[ cut here ]------------
WARNING: at sound/pci/echoaudio/echoaudio_dsp.c:478 init_hw+0x1d1/0x86c [snd_darla20]()
Hardware name: Dell DM051
BUG? (!chip->dsp_code_to_load || !chip->comm_page)

Signed-off-by: Mark Hills <mark@pogo.org.uk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/echoaudio/echoaudio_dsp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/echoaudio/echoaudio_dsp.c
+++ b/sound/pci/echoaudio/echoaudio_dsp.c
@@ -475,7 +475,7 @@ static int load_firmware(struct echoaudi
 	const struct firmware *fw;
 	int box_type, err;
 
-	if (snd_BUG_ON(!chip->dsp_code_to_load || !chip->comm_page))
+	if (snd_BUG_ON(!chip->comm_page))
 		return -EPERM;
 
 	/* See if the ASIC is present and working - only if the DSP is already loaded */


