Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2AaMJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:09:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55720 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2AaMJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:09:40 -0500
MIME-Version: 1.0
In-Reply-To: <20120131113358.GM2471@pengutronix.de>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
 <1328004002-24646-2-git-send-email-Barry.Song@csr.com> <20120131101734.GE2471@pengutronix.de>
 <CAGsJ_4wyJ6Wymy4AWoW1eHubZX=W7GT_Fbow9ofXoY1RrcHzgA@mail.gmail.com> <20120131113358.GM2471@pengutronix.de>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 31 Jan 2012 20:09:19 +0800
Message-ID: <CAGsJ_4zM=6ivn0uCtP4wsS67U77uHd5nVZQ-LP1vS07AE3dMxQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] platform: add common resource requesting and mapping helper
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Barry Song <Barry.Song@csr.com>, Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Erik Gilling <konkers@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-mtd@lists.infradead.org, Barry Song <Baohua.Song@csr.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Wolfram,

2012/1/31 Wolfram Sang <w.sang@pengutronix.de>:
> Barry,
>
>> > You don't need to do the error checking for 'res'. You can simply do
>> >
>> > res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> > base = devm_request_and_ioremap(&dev->dev, res);
>>
>> i do know  devm_request_and_ioremap() does res checking. but that is
>> implicit, confused and not a smart way actually.
>
> I agree about the implicit thing (keep in mind the function is new). But
> calling a function "not smart" because it checks its arguments? I do
> like the NULL check of kfree() for example.

i didn't mean it is not smart for devm_request_and_ioremap() to check
its param. that is definitely ok.
i mean it is not smart for people to depend on another function to do
implicit check on what they should check by themselves.
>
>> actually, no people by now really use the implicit checking. that
>> shows people don't really think that is a good programming way.
>
> I'd think most people just copy&paste and don't have an opinion either
> way, so the quantity doesn't show much.
>
>> > devm_request_and_ioremap() will check res. Given that, I don't think
>> > we can save a lot with another wrapper.
>>
>> i think we can save some.
>> The story begins from Grant's feedback in:
>> http://www.spinics.net/lists/arm-kernel/msg157644.html
>
> I am not sure using 'platform_devm_request_and_ioremap' and later using
> plain 'devm_*' functions (without platform_-prefix) is less confusing.
> The alternative would be to check which helper functions also use
> 'struct resource' and if they do checks on that. If all do that, you
> would have the simple rule, that you only need to check yourself if you
> access it yourself.

it is just a helper, just like clk_disable_unprepare() which do
clk_disable() + clk_unprepare().

>
> Regards,
>
>   Wolfram
>
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
-barry
