Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab1CBW24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:28:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47129 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757497Ab1CBW2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:28:54 -0500
Date: Wed, 2 Mar 2011 22:28:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: adharmap@codeaurora.org
Cc: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD 1/6] mfd: pm8921: Add PMIC 8921 core
 driver
Message-ID: <20110302222850.GA32325@opensource.wolfsonmicro.com>
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org>
 <1299104001-5240-2-git-send-email-adharmap@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299104001-5240-2-git-send-email-adharmap@codeaurora.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 02:13:16PM -0800, adharmap@codeaurora.org wrote:

> +config MFD_PM8XXX
> +	tristate "Support for Qualcomm PM8xxx subdevices"
> +	help
> +	  This option enables the usage of various Qualcomm PMIC 8xxx subdevice
> +	  drivers. This is required in order to use generic PM8xxx subdevice
> +	  drivers. Selecting with option will result in PM8xxx subdevice
> +	  drivers being compiled by default.

As this is selected by the driver it shouldn't have any help text -
there's no point in users seeing the option since it's useless by
itself.  If we get enough to make an option useful either a menu or
dependencies from the individual MFDs would be a better option.

> +static int __devinit pm8921_add_subdevices(const struct pm8921_platform_data
> +					   *pdata,
> +					   struct pm8921 *pmic)
> +{
> +	return 0;
> +}

This looks suspicious.

> +static int __init pm8921_init(void)
> +{
> +	return platform_driver_register(&pm8921_driver);
> +}
> +postcore_initcall(pm8921_init);

Typically subsys_initcall() has been used.
