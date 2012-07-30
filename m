Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab2G3N5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:57:18 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62709 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab2G3N5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 09:57:16 -0400
Message-ID: <501692B8.6050102@linaro.org>
Date: Mon, 30 Jul 2012 14:57:12 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 05/18] ASoC: Ux500: Enable ux500 MSP driver for Device
 Tree
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org> <1343393162-11938-6-git-send-email-lee.jones@linaro.org> <20120729204218.GI4384@opensource.wolfsonmicro.com> <50162F70.2050900@linaro.org> <20120730133930.GB4468@opensource.wolfsonmicro.com>
In-Reply-To: <20120730133930.GB4468@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/07/12 14:39, Mark Brown wrote:
> On Mon, Jul 30, 2012 at 07:53:36AM +0100, Lee Jones wrote:
>> On 29/07/12 21:42, Mark Brown wrote:
>
>>>> +	if (of_get_property(np, "stericsson,use-pinctrl", NULL))
>
>>> This doesn't seem particularly sane...  why is this conditional?
>
>> It's conditional because only MSP1 and MSP3 have pinctrl support.
>
> Why does the driver care - doesn't the pinctrl abstraction and/or
> bindings handle this sensibly?

Not when I tested it. pinctrl_get() came back !IS_ERR() for MSP0, MSP2 & 
MSP3, then when it went on to pinctrl_lookup_state(), only then did it 
fail. Would it be more sane to retract the error messages and just let 
it fail silently? It's either that or have lots of "could not get MSP 
defstate" clogging up the log.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
