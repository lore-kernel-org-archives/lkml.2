Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2ILXcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:32:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab2ILXcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:32:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: [ 027/108] ALSA: hda - Fix leftover codec->power_transition
Date: Wed, 12 Sep 2012 16:28:25 -0700
Message-Id: <20120912232453.390527105@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 535b6c51fe8293c88ce919cdfc4390c67a1cb6d1 upstream.

When the codec turn-on operation is canceled by the immediate
power-on, the driver left the power_transition flag as is.
This caused the persistent avoidance of power-save behavior.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -4422,6 +4422,8 @@ static void __snd_hda_power_up(struct hd
 	 * then there is no need to go through power up here.
 	 */
 	if (codec->power_on) {
+		if (codec->power_transition < 0)
+			codec->power_transition = 0;
 		spin_unlock(&codec->power_lock);
 		return;
 	}


