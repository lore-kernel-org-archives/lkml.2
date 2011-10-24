Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab1JXJU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:20:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61101 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab1JXJU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZ6DCeELLhiXF=oOMKB-DxeMuvbd_c6n4H1UDMhpHKZbA@mail.gmail.com>
References: <1317211419-18472-1-git-send-email-linus.walleij@stericsson.com>
 <20110930020754.GK12606@ponder.secretlab.ca> <CACRpkdYyyqB6=5M8reqgwpMxXJz5ttXWyOav6K58dQ0CrxwCNA@mail.gmail.com>
 <CACxGe6v19pZ0i-+ksYZbG2ZvGT30UkXEHTzpZMBTB4RNUV5bnA@mail.gmail.com>
 <CAKnu2MpQ8Wvd4TF8Ge=o8ACyEoaEY8TcvOSdT1w6zfYiSKFUiw@mail.gmail.com>
 <20111004203520.GK2870@ponder.secretlab.ca> <CAMjpGUe9abPsdWbum2MRzOV2b5_2FDqXZC-K0KThRA6MNTr4FA@mail.gmail.com>
 <CACRpkdatiBathcoo2VjKs9jHJiKC5trDCJ0bePX1q6KbrYRN-g@mail.gmail.com>
 <20111024073604.GA8708@ponder.secretlab.ca> <CACRpkdZ6DCeELLhiXF=oOMKB-DxeMuvbd_c6n4H1UDMhpHKZbA@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 24 Oct 2011 05:20:07 -0400
Message-ID: <CAMjpGUcWUp05SkBi1JWL+NFBCcZV5=EaidtYkEbONPheVwhjgw@mail.gmail.com>
Subject: Re: [PATCH] drivers: create a pin control subsystem v8
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>, David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Stijn Devriendt <highguy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 03:48, Linus Walleij wrote:
> On Mon, Oct 24, 2011 at 9:36 AM, Grant Likely wrote:
>> On Mon, Oct 24, 2011 at 09:26:38AM +0200, Linus Walleij wrote:
> (...)
>>> I was more thinking along the lines of one device per GPIO controller,
>>> then you ioctl() to ask /dev/gpio0 how many pins it has or so.
>>
>> And there is also the question of whether it is even a good idea to
>> export pinctrl manipulation to userspace.
>
> The application I've seen is in automatic control.
>
> I think people do things like connect they GPIO pins to electrical
> relays, plus on top of that they use all the stuff in drivers/staging/iio.
>
> All that from userspace. Controlling entire factories and industrial
> robots, weapon systems too, I'm afraid.
>
> The control of these dangerous things runs on a realtime-patched
> kernel, in a single userspace app with a few threads and they have
> done some realtime-tetris scheduling the beast more or less
> manually with SCHED_FIFO. Basically that app is all that runs on
> the board, and its threads take precedence over everything else
> on the system.
>
> That is the typical beast that is poking around on the GPIO sysfs
> interfaces...

we all agree that GPIO from userspace makes sense.  the only complaint
i've seen so far against the GPIO sysfs interface that should be
addressed is the performance overhead.

but the question here is about pinctrl.  does userspace really need to
manipulate the pinmapping ?  if we agree on that, then the question is
on the userspace interface.

assuming we want this, i can't see the performance argument being made
here for pinctrl.  which means doing a sysfs interface here like we
already have with GPIO makes the most sense.  GPIO deals in "binary"
data for the most part (reading/writing 0/1 ints) so the string-based
sysfs parsing is a bit weird, but pinctrl deals with strings
everywhere for selecting mapping groups, so sysfs is the natural
answer.
-mike
