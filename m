Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030265Ab2JSCt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:49:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:52757 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030200Ab2JSCtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 70/76] ALSA: hda - Always check array bounds in alc_get_line_out_pfx
Date: Thu, 18 Oct 2012 19:47:34 -0700
Message-Id: <20121019024401.371745449@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 71aa5ebe36a4e936eff281b375a4707b6a8320f2 upstream.

Even when CONFIG_SND_DEBUG is not enabled, we don't want to
return an arbitrary memory location when the channel count is
larger than we expected.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2629,8 +2629,10 @@ static const char *alc_get_line_out_pfx(
 			return "PCM";
 		break;
 	}
-	if (snd_BUG_ON(ch >= ARRAY_SIZE(channel_name)))
+	if (ch >= ARRAY_SIZE(channel_name)) {
+		snd_BUG();
 		return "PCM";
+	}
 
 	return channel_name[ch];
 }


