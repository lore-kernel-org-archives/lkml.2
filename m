Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912Ab2BNJSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:18:49 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8648 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759877Ab2BNJSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:18:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 14 Feb 2012 01:18:45 -0800
Message-ID: <4F3A267D.5020407@nvidia.com>
Date: Tue, 14 Feb 2012 14:46:45 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "dunlap@xenotime.net" <dunlap@xenotime.net>, "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1 2/3] Documentation: gpio: Add details of open-drain
 configuration
References: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com> <1329114588-15430-3-git-send-email-ldewangan@nvidia.com> <20120213211809.GI11077@ponder.secretlab.ca>
In-Reply-To: <20120213211809.GI11077@ponder.secretlab.ca>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 February 2012 02:48 AM, Grant Likely wrote:
> On Mon, Feb 13, 2012 at 11:59:47AM +0530, Laxman Dewangan wrote:
>> Adding details of open drain configuration of the gpio so that
>> client can set the pin as open drain at the time of gpio request.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>
> Linus mentioned that this should be part of pinctrl instead of the gpio API,
> but I think there is an argument for making it part of the gpio API,
> particularly since open-drain is pretty much a universal concept that all
> gpio controllers can support (unlike driver strength) and as I said above, it
> is already implicitly supported by gpiolib.

I am not sure about other soc but taking Tegra as example, the gpio 
controller is almost same for same series of soc. It does not very much 
about different version of the socs. The pins, number of pins. pin 
controls, pin is OD or not etc vary from variant of socs and so it is 
much more depends on the particular soc rather than  the major family.
Bringing pincontrol information in gpio driver will make the gpio driver 
complex which need to take care of every variant of chips.

>    The difference with this
> method is it would allow drivers like the gpio-i2c.c driver to set the
> flag at gpio request time and then be able to always use gpio_set_value()
> regardless of the pin mode.
>
> However, I'm not thrilled about adding things to the already-horrible sysfs
> abi.  Please drop that hunk entirely or put it into a separate patch so it
> doesn't block the core functionality.
>

I will split the change in two parts one for core driver and other for 
the sysfs interface if all changes are fine here.

> Have you though about support for lines that are pulled low instead of
> high?  Those aren't as common, but it is conceivable that some
> hardware would need it.
I think open drain pin should not be pulled low otherwise it will not be 
possible to make the pin as HIGH with the assumption that the OD pin 
should never be driven to HIGH

But if it is there in any case then it should be handle differently at  
client level without letting the gpio driver that it is open-drain.

