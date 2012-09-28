Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032230Ab2I1UYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:24:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032215Ab2I1UYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:24:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stephen Warren <swarren@nvidia.com>, Andrey Danin <danindrey@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 058/218] sound: tegra_alc5632: remove HP detect GPIO inversion
Date: Fri, 28 Sep 2012 13:14:35 -0700
Message-Id: <20120928201508.183193529@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit c921928661eda599d73a6a86e58bdd5aecfa18cb upstream.

Both the schematics and practical testing show that the HP detect GPIO
is high when the headphones are plugged in. Hence, the snd_soc_jack_gpio
should not specify to invert the signal.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Andrey Danin <danindrey@mail.ru>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/tegra/tegra_alc5632.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/soc/tegra/tegra_alc5632.c
+++ b/sound/soc/tegra/tegra_alc5632.c
@@ -95,7 +95,6 @@ static struct snd_soc_jack_gpio tegra_al
 	.name = "Headset detection",
 	.report = SND_JACK_HEADSET,
 	.debounce_time = 150,
-	.invert = 1,
 };
 
 static const struct snd_soc_dapm_widget tegra_alc5632_dapm_widgets[] = {


