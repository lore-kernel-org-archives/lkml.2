Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab2BQBAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:00:35 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40289 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756964Ab2BQBAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:32 -0500
X-Sasl-enc: Njlf7WT5Ad2QvUR68GB1KcMOUsQIBczBv0niJDgASZRk 1329440431
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:37 2012
Message-Id: <20120217005537.127774422@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel T Chen <crimsun@ubuntu.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [23/28] ALSA: intel8x0: Fix default inaudible sound on Gateway M520
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 27c3afe6e1cf129faac90405121203962da08ff4 upstream.

BugLink: https://bugs.launchpad.net/bugs/930842

The reporter states that audio is inaudible by default without muting
'External Amplifier'. Add a quirk to handle his SSID so that changing
the control is not necessary.

Reported-and-tested-by: Benjamin Carlson <elderbubba0810@gmail.com>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/intel8x0.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2102,6 +2102,12 @@ static struct ac97_quirk ac97_quirks[] _
 	},
 	{
 		.subvendor = 0x161f,
+		.subdevice = 0x202f,
+		.name = "Gateway M520",
+		.type = AC97_TUNE_INV_EAPD
+	},
+	{
+		.subvendor = 0x161f,
 		.subdevice = 0x203a,
 		.name = "Gateway 4525GZ",		/* AD1981B */
 		.type = AC97_TUNE_INV_EAPD


