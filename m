Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab1I1WwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:52:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032Ab1I1WvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:51:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:49 2011
Message-Id: <20110928220149.195666163@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [226/244] ASoC: ssm2602: Re-enable oscillator after suspend
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 9058020cd9ae3423d6fe7de591698dc96b6701aa upstream.

Currently the the internal oscillator is powered down when entering BIAS_OFF
state, but not re-enabled when going back to BIAS_STANDBY. As a result the
CODEC will stop working after suspend if the internal oscillator is used to
generate the sysclock signal. This patch fixes it by clearing the appropriate
bit in the power down register when the CODEC is re-enabled.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/ssm2602.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/ssm2602.c
+++ b/sound/soc/codecs/ssm2602.c
@@ -431,7 +431,8 @@ static int ssm2602_set_dai_fmt(struct sn
 static int ssm2602_set_bias_level(struct snd_soc_codec *codec,
 				 enum snd_soc_bias_level level)
 {
-	u16 reg = snd_soc_read(codec, SSM2602_PWR) & 0xff7f;
+	u16 reg = snd_soc_read(codec, SSM2602_PWR);
+	reg &= ~(PWR_POWER_OFF | PWR_OSC_PDN);
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:


