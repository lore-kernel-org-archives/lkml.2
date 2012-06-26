Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab2FZJEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:04:39 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36608 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2FZJEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:04:36 -0400
Message-ID: <4FE97B20.6000809@linaro.org>
Date: Tue, 26 Jun 2012 10:04:32 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [PATCH 08/14] mfd: Add IRQ domain support for the AB8500
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-9-git-send-email-lee.jones@linaro.org> <20120614183231.GA30185@sirena.org.uk> <4FDEEEBD.5070108@linaro.org> <20120618102003.GB12029@n2100.arm.linux.org.uk> <20120618185638.GY3974@opensource.wolfsonmicro.com> <4FE1C952.5000306@linaro.org> <CACRpkdYszGAixL_2CiPLRJ2Pasq_GwxnR1np+y83miOXhanNQg@mail.gmail.com>
In-Reply-To: <CACRpkdYszGAixL_2CiPLRJ2Pasq_GwxnR1np+y83miOXhanNQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/12 08:37, Linus Walleij wrote:
> On Wed, Jun 20, 2012 at 3:00 PM, Lee Jones<lee.jones@linaro.org>  wrote:
>> On 18/06/12 19:56, Mark Brown wrote:
>>>
>>> Yes, that's correct.  I'm surprised the code runs without crashing...
>>
>> Oddly the code ran perfectly.
>
> So how did you test it?
>
> The only way to generate an IRQ on the AB8500 with the mainline code is
> to push the power button, that should generate an event from the
> driver in drivers/input/misc/ab8500-ponkey.c that you can listen to
> by doing cat on the proper /dev/input/eventN file.
>
> Please test this scenario before and after the patch and you have some
> indication that the IRQdomain is working.

Yep, works perfectly fall and rise:

>            CPU0       CPU1
>   6:          0          2    ab8500  ab8500-ponkey-dbf
>   7:          0          2    ab8500  ab8500-ponkey-dbr

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
