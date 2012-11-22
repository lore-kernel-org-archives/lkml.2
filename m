Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab2KVWCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:02:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:49632 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab2KVSkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 27/83] ASoC: cs42l52: fix the return value of cs42l52_set_fmt()
Date: Wed, 21 Nov 2012 16:41:49 -0800
Message-Id: <20121122004215.576739920@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 5c855c8e2be67f2d5a989ef1190098f924f9f820 upstream.

Fix the return value of cs42l52_set_fmt() when clock inversion is
not allowed and also remove the useless variable ret.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

[We had been assigning to ret but then ignoring the value we assgined
-- broonie]

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/cs42l52.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -774,7 +774,6 @@ static int cs42l52_set_fmt(struct snd_so
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct cs42l52_private *cs42l52 = snd_soc_codec_get_drvdata(codec);
-	int ret = 0;
 	u8 iface = 0;
 
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
@@ -823,7 +822,7 @@ static int cs42l52_set_fmt(struct snd_so
 	case SND_SOC_DAIFMT_NB_IF:
 		break;
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 	cs42l52->config.format = iface;
 	snd_soc_write(codec, CS42L52_IFACE_CTL1, cs42l52->config.format);


