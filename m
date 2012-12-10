Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab2LJMGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 07:06:31 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65401 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2LJMGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 07:06:30 -0500
MIME-Version: 1.0
In-Reply-To: <20121210103050.GE9362@gmail.com>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
	<1355129761-8088-12-git-send-email-lee.jones@linaro.org>
	<CAPDyKFo8NjiYdcyx3pk8byc1N2f7r+erQj74A1zhOaNK_WbkZA@mail.gmail.com>
	<20121210103050.GE9362@gmail.com>
Date: Mon, 10 Dec 2012 13:06:29 +0100
Message-ID: <CAPDyKFo22kNjiqc+pnR51g3KH-ExM=eOKRBRkWm0r6XmgOH9uw@mail.gmail.com>
Subject: Re: [PATCH 11/12] ARM: ux500: Use the GPIO regulator framework for
 SDI0's 'en' and 'vsel'
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2012 11:30, Lee Jones <lee.jones@linaro.org> wrote:
>> > +        .constraints = {
>> > +                .min_uV         = 1800000,
>>
>> 2.9V, not 3.3V
>
>> > +static struct gpio_regulator_state sdi0_reg_states[] = {
>> > +        { .value = 3300000, .gpios = (0 << 0) },
>>
>> 2.9V, not 3.3V
>
> I'm still a little unsure about this. I know the actual
> voltage is v2.9, but the supported/requested MMC voltage
> from the driver is v3.3.
>
> Will it still work if I set it all up as v2.9?
>

So that is if course important to consider. Although the regulator
must nu lie about what it actually supports.

In this case mmci driver will have to decide what to do when 3.3V is
requested, but only 2.9 is supported.

> --
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

Kind regards
Ulf Hansson
