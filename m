Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1JKRG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:06:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1JKRGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:06:25 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:10 2011
Message-Id: <20111011165710.436735957@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:24 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [14/38] ASoC: Fix setting update bits for WM8753_LADC and WM8753_RADC
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit 21d17dd2a377ba894f26989915eb3c6e427a3656 upstream.

Current code set update bits for WM8753_LDAC and WM8753_RDAC twice,
but missed setting update bits for WM8753_LADC and WM8753_RADC.

I think it is a copy-paste bug in commit 776065
"ASoC: codecs: wm8753: Fix register cache incoherency".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8753.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -1454,8 +1454,8 @@ static int wm8753_probe(struct snd_soc_c
 	/* set the update bits */
 	snd_soc_update_bits(codec, WM8753_LDAC, 0x0100, 0x0100);
 	snd_soc_update_bits(codec, WM8753_RDAC, 0x0100, 0x0100);
-	snd_soc_update_bits(codec, WM8753_LDAC, 0x0100, 0x0100);
-	snd_soc_update_bits(codec, WM8753_RDAC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_LADC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_RADC, 0x0100, 0x0100);
 	snd_soc_update_bits(codec, WM8753_LOUT1V, 0x0100, 0x0100);
 	snd_soc_update_bits(codec, WM8753_ROUT1V, 0x0100, 0x0100);
 	snd_soc_update_bits(codec, WM8753_LOUT2V, 0x0100, 0x0100);


