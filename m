Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab2DDLIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 07:08:09 -0400
Received: from antcom.de ([188.40.178.216]:32801 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab2DDLIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 07:08:07 -0400
Message-ID: <4F7C2B94.8090601@antcom.de>
Date: Wed, 04 Apr 2012 13:08:04 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Grant Likely <grant.likely@secretlab.ca>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH v2] gpio: Device tree support for LPC32xx
References: <1333497518-25838-1-git-send-email-stigge@antcom.de> <201204040848.39376.arnd@arndb.de>
In-Reply-To: <201204040848.39376.arnd@arndb.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2012 10:48 AM, Arnd Bergmann wrote:
>> +#ifdef CONFIG_OF
>> +static struct of_device_id lpc32xx_gpio_of_match[] __devinitdata = {
>> +	{ .compatible = "nxp,lpc32xx-gpio", },
>> +	{ },
>> +};
>> +#endif
>> +
>> +static struct platform_driver lpc32xx_gpio_driver = {
>> +	.driver		= {
>> +		.name	= "lpc32xx-gpio",
>> +		.owner	= THIS_MODULE,
>> +		.of_match_table = lpc32xx_gpio_of_match,
>> +	},
>> +	.probe		= lpc32xx_gpio_probe,
>> +};
> 
> The #ifdef above is not helpful, it will cause a build error in the
> of_match_table= assignment. Since the plan for this driver is to
> be devicetree-only, it would be appropriate to just remove the
> #ifdef, but adding of_match_ptr() is ok too.

I think I just forgot the of_match_ptr(). Will post an update with a
repo for gpio to pull from.

Thanks for the note!

Roland
