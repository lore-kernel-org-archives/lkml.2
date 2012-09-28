Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925Ab2I1S5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:57:17 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964910Ab2I1S5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:57:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stephen Warren <swarren@nvidia.com>, Andrey Danin <danindrey@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 068/262] sound: tegra_alc5632: remove HP detect GPIO inversion
Date: Fri, 28 Sep 2012 11:49:57 -0700
Message-Id: <20120928183006.129009150@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -92,7 +92,6 @@ static struct snd_soc_jack_gpio tegra_al
 	.name = "Headset detection",
 	.report = SND_JACK_HEADSET,
 	.debounce_time = 150,
-	.invert = 1,
 };
 
 static const struct snd_soc_dapm_widget tegra_alc5632_dapm_widgets[] = {


