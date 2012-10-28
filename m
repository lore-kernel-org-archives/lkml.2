Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab2J1Xg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:36:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42123 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756532Ab2J1X2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:06 -0400
Message-Id: <20121028231553.368916470@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:29 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 053/105] ALSA: hda - Always check array bounds in alc_get_line_out_pfx
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 71aa5ebe36a4e936eff281b375a4707b6a8320f2 upstream.

Even when CONFIG_SND_DEBUG is not enabled, we don't want to
return an arbitrary memory location when the channel count is
larger than we expected.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8253b4e..48d9d60 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2598,8 +2598,10 @@ static const char *alc_get_line_out_pfx(struct alc_spec *spec, int ch,
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


