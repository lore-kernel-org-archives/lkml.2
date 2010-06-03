Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab0FCR5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:57:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50410 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751380Ab0FCR5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:57:16 -0400
Date: Thu, 3 Jun 2010 18:57:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       alsa-devel@alsa-project.org
Subject: Re: [RFC][PATCH 26/26] alsa: ASoC: JZ4740: Add qi_lb60 board driver
Message-ID: <20100603175714.GJ2762@rakim.wolfsonmicro.main>
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>
 <1275506132-17519-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275506132-17519-2-git-send-email-lars@metafoo.de>
X-Cookie: In the next world, you're on your own.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 09:15:32PM +0200, Lars-Peter Clausen wrote:

> +	ret = gpio_request(QI_LB60_SND_GPIO, "SND");
> +	if (ret) {
> +		pr_err("qi_lb60 snd: Failed to request SND GPIO(%d): %d\n",
> +				QI_LB60_SND_GPIO, ret);
> +		goto err_device_put;
> +	}
> +
> +	ret = gpio_request(QI_LB60_AMP_GPIO, "AMP");
> +	if (ret) {
> +		pr_err("qi_lb60 snd: Failed to request AMP GPIO(%d): %d\n",
> +				QI_LB60_AMP_GPIO, ret);
> +		goto err_gpio_free_snd;
> +	}
> +
> +	gpio_direction_output(JZ_GPIO_PORTB(29), 0);
> +	gpio_direction_output(JZ_GPIO_PORTD(4), 0);

You're referring to the GPIOs by multiple different names - it'd be more
robust to pick one way of naming them and use it consistently (probably
the #define).
