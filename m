Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018Ab2JAXW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:22:26 -0400
Received: from 1wt.eu ([62.212.114.60]:35357 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932919Ab2JAXBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:24 -0400
Message-Id: <20121001225201.161019309@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mark Hills <mark@pogo.org.uk>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 084/180] ALSA: echoaudio: Remove incorrect part of assertion
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 sound/pci/echoaudio/echoaudio_dsp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/echoaudio/echoaudio_dsp.c b/sound/pci/echoaudio/echoaudio_dsp.c
index 4df51ef..5d14b7a 100644
--- a/sound/pci/echoaudio/echoaudio_dsp.c
+++ b/sound/pci/echoaudio/echoaudio_dsp.c
@@ -474,7 +474,7 @@ static int load_firmware(struct echoaudio *chip)
 	const struct firmware *fw;
 	int box_type, err;
 
-	if (snd_BUG_ON(!chip->dsp_code_to_load || !chip->comm_page))
+	if (snd_BUG_ON(!chip->comm_page))
 		return -EPERM;
 
 	/* See if the ASIC is present and working - only if the DSP is already loaded */
-- 
1.7.2.1.45.g54fbc



