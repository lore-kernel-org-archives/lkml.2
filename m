Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760983Ab2BJXRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:17:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50022 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab2BJWlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:41:36 -0500
MIME-Version: 1.0
Message-Id: <20120210222945.747911285@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 08/86] ALSA: hda - Disable dynamic-power control for VIA as default
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b5bcc189401c815988b7dd37611fc56f40c9139d upstream.

Since the dynamic pin power-control and the analog low-current mode
may lead to pop-noise, it's safer to set it off as default.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=741128

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_via.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1460,6 +1460,7 @@ static int via_build_controls(struct hda
 	struct snd_kcontrol *kctl;
 	int err, i;
 
+	spec->no_pin_power_ctl = 1;
 	if (spec->set_widgets_power_state)
 		if (!via_clone_control(spec, &via_pin_power_ctl_enum))
 			return -ENOMEM;


