Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab2DMTFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:05:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34177 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab2DMTE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:04:59 -0400
Date: Fri, 13 Apr 2012 20:04:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: x86@kernel.org, Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH v6 3/3] gpio: TS-5500 GPIO support
Message-ID: <20120413190442.GA8275@sirena.org.uk>
References: <1334276935-11258-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1334276935-11258-4-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334276935-11258-4-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Cookie: try again
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 08:28:55PM -0400, Vivien Didelot wrote:

Guess I won't wait for a more thorough off list review :)

> +static void ts5500_gpio_release(struct device *dev)
> +{
> +	/* noop */
> +}

So, this really shouldn't be here...

> +static int __devinit ts5500_gpio_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	unsigned long flags;
> +
> +	if (pdev == NULL)
> +		return -ENODEV;

Don't bother, the kernel got seriously confused if this happens.

> +	ret = platform_device_register(&ts5500_gpio_pdev);
> +	if (ret) {
> +		platform_driver_unregister(&ts5500_gpio_driver);
> +		return ret;
> +	}

...probably what your release function should do is free the device
which should be dynamically allocated here, platform_device_alloc() will
do the right thing for you.  This isn't usually an issue for static
platform devices as they are registered from board files which can't be
unloaded.
