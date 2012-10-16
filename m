Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2JPKAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:00:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34145 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2JPKAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:00:15 -0400
MIME-Version: 1.0
In-Reply-To: <201210160851.33324.poeschel@lemonage.de>
References: <20120925085559.GL28670@sortiz-mobl>
	<1350052469-27802-2-git-send-email-larsi@wh2.tu-dresden.de>
	<CACRpkdadDJDU_UUmdFoKBUm49_1CPjBnibq_RsiSeu+y4zRTsw@mail.gmail.com>
	<201210160851.33324.poeschel@lemonage.de>
Date: Tue, 16 Oct 2012 12:00:13 +0200
Message-ID: <CACRpkda+UufHGEekzRxG7U3CG-_nvx1d0ophqwUUWmjkvaBTmg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] gpio: add viperboard gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 8:51 AM, Lars Poeschel <poeschel@lemonage.de> wrote:
> On Monday 15 October 2012 at 15:00:12, Linus Walleij wrote:
>> > +       /* if io is set to output, just return the saved value */
>> > +       if (gpio->gpioa_out & (1 << offset))
>> > +               return gpio->gpioa_val & (1 << offset);
>>
>> That's not going to work if the hardware changes state
>> behind the back of the driver right? Oh well, maybe
>> it doesn't matter.
>
> I thought about that and then did this "cache" only in case the gpio is a
> output to save to usb ping-pong that is needed otherwise. I thought that
> nothing can change to state of the output but the driver itself.

On a second note there is already a standard mechanism for caching
registers in the kernel, and that is regmap. Sadly it's a bit
undocumented but there are several examples and the code
lives in drivers/base/regmap and include/linux/regmap.h

Yours,
Linus Walleij
