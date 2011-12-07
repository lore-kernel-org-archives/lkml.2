Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab1LGQqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:46:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933138Ab1LGQVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:21:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:17 2011
Message-Id: <20111207161216.998068052@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:29 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [027/104] ASoC: wm8753: Skip noop reconfiguration of DAI mode
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timo Juhani Lindfors <timo.lindfors@iki.fi>

commit 2391a0e06789a3f1718dee30b282562f7ed28c87 upstream.

This patch makes it possible to set DAI mode to its currently applied
value even if codec is active. This is necessary to allow

aplay -t raw -r 44100 -f S16_LE -c 2 < /dev/urandom &
alsactl store -f backup.state
alsactl restore -f backup.state

to work without returning errors. This patch is based on a patch sent
by Klaus Kurzmann <mok@fluxnetz.de>.

Signed-off-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8753.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -189,6 +189,9 @@ static int wm8753_set_dai(struct snd_kco
 	struct wm8753_priv *wm8753 = snd_soc_codec_get_drvdata(codec);
 	u16 ioctl;
 
+	if (wm8753->dai_func == ucontrol->value.integer.value[0])
+		return 0;
+
 	if (codec->active)
 		return -EBUSY;
 


