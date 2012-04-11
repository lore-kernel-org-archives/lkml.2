Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965795Ab2DKX3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:29:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45547 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965748Ab2DKX3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:29:33 -0400
Message-Id: <20120411231314.063843391@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:13:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 38/42] ASoC: ak4642: fixup: mute needs +1 step
In-Reply-To: <20120411231443.GA808@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit 1f99e44cf059d2ed43c5a0724fa738b83800f725 upstream.

ak4642 out_tlv is +12.0dB to -115.0 dB, and it supports mute.
But current settings didn't care +1 step for mute.
This patch adds it

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/ak4642.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -143,7 +143,7 @@
  * min : 0xFE : -115.0 dB
  * mute: 0xFF
  */
-static const DECLARE_TLV_DB_SCALE(out_tlv, -11500, 50, 1);
+static const DECLARE_TLV_DB_SCALE(out_tlv, -11550, 50, 1);
 
 static const struct snd_kcontrol_new ak4642_snd_controls[] = {
 


