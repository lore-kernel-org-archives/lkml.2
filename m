Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab2GIVzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:55:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57820 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab2GIVzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:55:04 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZ=6yP58DvY287h9tL1pL_oQk8JfjvYJhc80==yvzz=TA@mail.gmail.com>
References: <1341832976-8025-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACRpkdZ=6yP58DvY287h9tL1pL_oQk8JfjvYJhc80==yvzz=TA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 9 Jul 2012 22:54:41 +0100
X-Google-Sender-Auth: ksJdV5kjBX5IgYwjm3qbm25MDpk
Message-ID: <CACxGe6uJUTtcmq2voo0yGQZ-OxiOK-0OEJ343qZZMDTMQc6veg@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Defer failed gpio requests by default
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 9:31 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Jul 9, 2012 at 1:22 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
>
>> Since users must be explicitly provided with a GPIO number in order to
>> request one the overwhelmingly common case for failing to request will
>> be that the required GPIO driver has not yet registered and we should
>> therefore defer until it has registered.
>>
>> In order to avoid having to code this logic in individual drivers have
>> gpio_request() return -EPROBE_DEFER when failing to look up the GPIO.
>> Drivers which don't want this behaviour can override it if they desire.
>>
>> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> While this makes perfect sense to me I would *really* like to
> wait for Grants opinion on this one patch, him having devised
> the deferral and being GPIO maintainer.
>
> Is any deferral of this deferral mechanism causing you to
> defer important work right now?

I'm fine with this patch, but the patch that adds the twizzling of the
dpm_list when probing needs some tweaking, and this patch must be
applied after that one.  I'll go and reply to that patch now (and cc
you if you're not already).

g.
