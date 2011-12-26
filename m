Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab1LZLDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 06:03:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57962 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752723Ab1LZLDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 06:03:52 -0500
Date: Mon, 26 Dec 2011 11:03:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lrg@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 4/4] ASoC: OMAP: ams-delta: drop .set_bias_level callback
Message-ID: <20111226110348.GB8722@opensource.wolfsonmicro.com>
References: <1324681944-19067-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <1324681944-19067-5-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324681944-19067-5-git-send-email-jkrzyszt@tis.icnet.pl>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 24, 2011 at 12:12:24AM +0100, Janusz Krzysztofik wrote:

> +struct regulator_consumer_data {
> +	struct mutex lock;
> +	struct regulator *regulator;
> +	bool enabled;
> +};
> +
> +static int regulator_toggle(struct regulator_consumer_data *consumer,
> +		bool enable)
> +{
> +	int err = 0;
> +
> +	if (!consumer->regulator)
> +		return -ENODEV;
> +
> +	mutex_lock(&consumer->lock);
> +	if (IS_ERR(consumer->regulator)) {
> +		err = PTR_ERR(consumer->regulator);
> +	} else if (enable) {
> +		if (!consumer->enabled) {
> +			err = regulator_enable(consumer->regulator);
> +			consumer->enabled = true;
> +		}
> +	} else {
> +		if (consumer->enabled) {
> +			err = regulator_disable(consumer->regulator);
> +			consumer->enabled = false;
> +		}
> +	}
> +	mutex_unlock(&consumer->lock);
> +
> +	return err;
> +}
> +

Why's this code not been dropped and what is it for?
