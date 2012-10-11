Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab2JKPdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 11:33:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56292 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758771Ab2JKPdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 11:33:00 -0400
MIME-Version: 1.0
In-Reply-To: <BFABBC009FBA1C43B207B15FD485ABD922C22BC4@USW-MAIL1.synaptics-inc.local>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	<1349496603-20775-2-git-send-email-cheiny@synaptics.com>
	<CACRpkdZb+LOk8v0aNZuPhATjS5jv-h1JJCejoh_9eFZ_fdiZQA@mail.gmail.com>
	<BFABBC009FBA1C43B207B15FD485ABD922C22BC4@USW-MAIL1.synaptics-inc.local>
Date: Thu, 11 Oct 2012 17:32:59 +0200
Message-ID: <CACRpkdY3jctXSBB+SMJ=6k=CcLEsHz4jY8T3db8htcE+zWnJWw@mail.gmail.com>
Subject: Re: [RFC PATCH 01/06] input/rmi4: Public header and documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <Cheiny@synaptics.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 5:41 AM, Christopher Heiny <Cheiny@synaptics.com> wrote:
> Linus Walleij wrote:

>> But please use arithmetic operators (I think I said this on the last
>> review):
>>
>> dest[0] = src & 0xFF;
>> dest[1] = src >> 8;
>>
>> Doing it the above way makes artithmetic look like maths, and it isn't.
>> Besides it's done this way in most parts of the kernel and we're
>> familiar with it.
>
> Yes, you mentioned it previously.  I'm somewhat paranoid, though, and
> don't trust the shift/mask method to work correctly on big-endian
> machines.  If the shifts can be relied on to behave (I'm guessing the
> answer is "yes", since you say this idiom is used widely in the
> kernel), then I'll change it.

If the behaviour was not consistent across different endianness
it would not be part of the C language specification...

<< means shift left in the accumulator or whatever you have.
It will work the same no matter how bits are laid out in
memory.

>> > +static inline ssize_t rmi_store_error(struct device *dev,
>> > +                       struct device_attribute *attr,
>> > +                       const char *buf, size_t count)
>> > +{
>> > +       dev_warn(dev,
>> > +                "WARNING: Attempt to write %d characters to read-only
>> > attribute %s.", +               count, attr->attr.name);
>> > +       return -EPERM;
>> > +}
>>
>> Here it looks like you're hiding a lot of stuff that should be dev_warn()?
>> Consider my earlier point about dynamic debug.
>
> In previous patch submissions, we always used these warning functions.
> But in the feedback on those patches, we were asked to just make
> sysfs show/store NULL if the attribute is write/read only.  However,
> during their development process, our customers want to see the
> warnings if the attributes are accessed incorrectly.  So we made
> these warnings a debug option.

See Dmitry's comment ...

Basically my stance is that you should not lower yourself to the
level of others not getting the point of your technical solution
by making unelegant compromises, what
you should do is to bring them up to your level so they
understand that your solution is elegant.

Maybe a bit utopist I know...

Yours,
Linus Walleij
