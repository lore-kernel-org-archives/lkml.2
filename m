Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab2GFHpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:45:43 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37180 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2GFHpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:45:41 -0400
Message-ID: <4FF6979F.2000904@linaro.org>
Date: Fri, 06 Jul 2012 08:45:35 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Mattias WALLIN <mattias.wallin@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [PATCH 3/9] ARM: ux500: Remove AB8500 regulator register initialisation
 information
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org> <1341493572-29735-4-git-send-email-lee.jones@linaro.org> <CACRpkdbRtFX8_++rndCpsH7R1uhwPrkTE_GKgNTM6r1PSuwY0A@mail.gmail.com>
In-Reply-To: <CACRpkdbRtFX8_++rndCpsH7R1uhwPrkTE_GKgNTM6r1PSuwY0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/12 07:55, Linus Walleij wrote:
> On Thu, Jul 5, 2012 at 3:06 PM, Lee Jones <lee.jones@linaro.org> wrote:
>
>> There is no need to initialise the AB8500's regulator registers, as
>> most of this work is already carried out by framework features, so
>> we can safely remove all traces from platform code.
>>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>
> NACK, sorry.
>
> These registers are used to set up sleep states for the regulators,
> e.g that some regulators will turn off when the system go to sleep.
>
> If you delete this code it's no longer possible to make the system
> powerefficient, power consumption increases so it causes a
> regression.
>
> The proper thing to do is to take the AB8500 datasheet, go in and
> read what these registers actually do, and provide the same
> features through the framework, if just poking the registers
> is deemed non-elegant (I see the point in that).
>
> This is the AB8500 datasheet:
> http://www.stericsson.com/developers/CD00291561_UM1031_AB8500_user_manual-rev5_CTDS_public.pdf
>
> So please refactor this, don't just delete, that's destroying a lot
> of useful stuff.

Sounds reasonable. I won't be doing the refactoring, as I'm moving onto 
something else from Monday. Unless of course I find myself with lots of 
spare time *chuckles*.

Mark,

Please take a note of this and also do not apply the regulator driver 
counterpart of the patch-set (it was one of the ones you Reviewed-by in 
the previous batch).

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


