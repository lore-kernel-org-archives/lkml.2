Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab1EPVfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:35:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35666 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab1EPVfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:35:54 -0400
Date: Mon, 16 May 2011 22:35:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        Harald Welte <laforge@gnumonks.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH v2 2/3] ASoC: add iPAQ hx4700 machine
	driver
Message-ID: <20110516213551.GB2570@sirena.org.uk>
References: <1305579805-15617-1-git-send-email-mad_soft@inbox.ru> <1305579805-15617-3-git-send-email-mad_soft@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305579805-15617-3-git-send-email-mad_soft@inbox.ru>
X-Cookie: An idle mind is worth two in the bush.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 01:03:24AM +0400, Dmitry Artamonow wrote:
> AK4641 connected via I2S and I2C, jack detection via GPIO.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

Same thing here - pretty good but a bit out of date.

> +	/* Add hx4700 specific widgets */
> +	snd_soc_dapm_new_controls(dapm, ak4641_dapm_widgets,
> +				  ARRAY_SIZE(ak4641_dapm_widgets));
> +
> +	/* Set up hx4700 specific audio path interconnects */
> +	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
> +
> +	snd_soc_dapm_sync(dapm);

Data based init for these too please.

> +static int __init hx4700_init(void)
> +{
> +	int ret;
> +
> +	if (!machine_is_h4700())
> +		return -ENODEV;
> +
> +	ret = gpio_request(GPIO107_HX4700_SPK_nSD, "SPK_POWER");
> +	if (ret)
> +		goto err_request_spk;
> +	ret = gpio_request(GPIO92_HX4700_HP_DRIVER, "EP_POWER");
> +	if (ret)
> +		goto err_request_ep;
> +
> +	gpio_direction_output(GPIO107_HX4700_SPK_nSD, 1);
> +	gpio_direction_output(GPIO92_HX4700_HP_DRIVER, 0);
> +
> +	hx4700_snd_device = platform_device_alloc("soc-audio", -1);
> +	if (!hx4700_snd_device) {

Use a regular platform device to register the machine and call
snd_soc_register_card() to instantiate please.
