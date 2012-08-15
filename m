Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2HOPBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:01:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47922 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2HOPBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:01:19 -0400
MIME-Version: 1.0
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51032C651B@NB-EX-MBX02.diasemi.com>
References: <201208060738.q767ci5c005713@ubuntu>
	<CACRpkdYLMRCuZoKPhEwyyoPonUY-mgLOxDvmnoCmCbCxiGHwcA@mail.gmail.com>
	<24DF37198A1E704D9811D8F72B87EB51032C651B@NB-EX-MBX02.diasemi.com>
Date: Wed, 15 Aug 2012 17:01:17 +0200
Message-ID: <CACRpkdZ9Jw_yMG6FxF=kQ0zm+8+p3uBp5gGAXVVXWT=W=ET5og@mail.gmail.com>
Subject: Re: [NEW DRIVER V2 5/7] DA9058 GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 12:08 PM, Opensource [Anthony Olech]
<anthony.olech.opensource@diasemi.com> wrote:
> [Me]

>> > +       if (offset > 1)
>> > +               return -EINVAL;
>> So there are two GPIO pins, 0 and 1? That seems odd, but OK.
>
> That is a feature of the hardware. I believe that calling them "0" and
> "1" is the correct thing to do. Correct me if they should have been
> called "1" and "2", or something else.

It's correct, what I thought was odd was the fact that there were only
two GPIO pins on this device. But some have only one even, just wanted
to verify...

> HANDLING NIBBLES
> ================
>
> The handling of nibbles within a byte follows the rule that constants
> for the nibble NOT being operated on have those bits set to zero,
> and thus only bits being operated on may be non-zero. Thus to set,
> for example, the value 0xB into the MSH the operation is:
>         byte &= ~0xF0
>         byte |= 0xB0
> it being obvious that it is the upper nibble being operated on.
> It seems that you are following a different rule for handling nibbles,
> and I can't find any standard for doing so in the kernel, so could
> you send me your reference documents?

In this case as stated elsewhere, I'm happy that you do things
this way, if  you #define the magic values you're using
in your bytes and nibbles, because else it's just hard to read.

#define FOO_MASK 0xF0
#define BAR_FEATURE 0xB0

byte &= ~FOO_MASK;
byte |= BAR_FEATURE;

It's more readble.

Yours,
Linus Walleij
