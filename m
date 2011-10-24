Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1JXH0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 03:26:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47588 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab1JXH0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 03:26:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAMjpGUe9abPsdWbum2MRzOV2b5_2FDqXZC-K0KThRA6MNTr4FA@mail.gmail.com>
References: <1317211419-18472-1-git-send-email-linus.walleij@stericsson.com>
	<20110930020754.GK12606@ponder.secretlab.ca>
	<CACRpkdYyyqB6=5M8reqgwpMxXJz5ttXWyOav6K58dQ0CrxwCNA@mail.gmail.com>
	<CACxGe6v19pZ0i-+ksYZbG2ZvGT30UkXEHTzpZMBTB4RNUV5bnA@mail.gmail.com>
	<CAKnu2MpQ8Wvd4TF8Ge=o8ACyEoaEY8TcvOSdT1w6zfYiSKFUiw@mail.gmail.com>
	<20111004203520.GK2870@ponder.secretlab.ca>
	<CAMjpGUe9abPsdWbum2MRzOV2b5_2FDqXZC-K0KThRA6MNTr4FA@mail.gmail.com>
Date: Mon, 24 Oct 2011 09:26:38 +0200
Message-ID: <CACRpkdatiBathcoo2VjKs9jHJiKC5trDCJ0bePX1q6KbrYRN-g@mail.gmail.com>
Subject: Re: [PATCH] drivers: create a pin control subsystem v8
From: Linus Walleij <linus.walleij@linaro.org>
To: Mike Frysinger <vapier.adi@gmail.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 7:44 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Tue, Oct 4, 2011 at 16:35, Grant Likely wrote:
>> On Sat, Oct 01, 2011 at 12:39:21PM +0200, Linus Walleij wrote:
>>> 2011/9/30 Grant Likely:
>>> > I'm not convinced that the sysfs approach is
>>> > actually the right interface here (I'm certainly not a fan of the gpio
>>> > sysfs i/f), and I'd rather not be putting in unneeded stuff until the
>>> > userspace i/f is hammered out.
>>>
>>> Actually, thinking about it I cannot see what would be wrong
>>> with /dev/gpio0 & friends in the first place.
>>>
>>> Using sysfs as swiss army knife for custom I/O does not
>>> seem like it would be long-term viable so thanks for this
>>> observation, and I think we need /dev/gpio* put on some
>>> mental roadmap somewhere.
>>
>> Agreed.  I don't want to be in the situation we are now with GPIO,
>> where every time I look at the sysfs interface I shudder.
>
> the problem with that is it doesn't scale.  if i have a device with
> over 150 GPIOs on the SoC itself (obviously GPIO expanders can make
> that much bigger), i don't want to see 150+ device nodes in /dev/.
> that's a pretty big waste.  sysfs only allocates/frees resources when
> userspace actually wants to utilize a GPIO.

I was more thinking along the lines of one device per GPIO controller,
then you ioctl() to ask /dev/gpio0 how many pins it has or so.

Yours,
Linus Walleij
