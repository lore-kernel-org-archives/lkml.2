Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965358Ab2JWXS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:18:29 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:36788 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933995Ab2JWXS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:18:27 -0400
Message-ID: <508725C1.5090401@synaptics.com>
Date: Tue, 23 Oct 2012 16:18:25 -0700
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
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
Subject: Re: [RFC PATCH 01/06] input/rmi4: Public header and documentation
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com> <1349496603-20775-2-git-send-email-cheiny@synaptics.com> <CACRpkdZb+LOk8v0aNZuPhATjS5jv-h1JJCejoh_9eFZ_fdiZQA@mail.gmail.com> <BFABBC009FBA1C43B207B15FD485ABD922C22BC4@USW-MAIL1.synaptics-inc.local> <CACRpkdY3jctXSBB+SMJ=6k=CcLEsHz4jY8T3db8htcE+zWnJWw@mail.gmail.com>
In-Reply-To: <CACRpkdY3jctXSBB+SMJ=6k=CcLEsHz4jY8T3db8htcE+zWnJWw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 08:32 AM, Linus Walleij wrote:
> On Thu, Oct 11, 2012 at 5:41 AM, Christopher Heiny <Cheiny@synaptics.com> wrote:
>> Linus Walleij wrote:
>
>>> But please use arithmetic operators (I think I said this on the last
>>> review):
>>>
>>> dest[0] = src & 0xFF;
>>> dest[1] = src >> 8;
>>>
>>> Doing it the above way makes artithmetic look like maths, and it isn't.
>>> Besides it's done this way in most parts of the kernel and we're
>>> familiar with it.
>>
>> Yes, you mentioned it previously.  I'm somewhat paranoid, though, and
>> don't trust the shift/mask method to work correctly on big-endian
>> machines.  If the shifts can be relied on to behave (I'm guessing the
>> answer is "yes", since you say this idiom is used widely in the
>> kernel), then I'll change it.
>
> If the behaviour was not consistent across different endianness
> it would not be part of the C language specification...
>
> << means shift left in the accumulator or whatever you have.
> It will work the same no matter how bits are laid out in
> memory.

OK, after reviewing the spec I'll accept that.  We'll make the change.

>>>> +static inline ssize_t rmi_store_error(struct device *dev,
>>>> +                       struct device_attribute *attr,
>>>> +                       const char *buf, size_t count)
>>>> +{
>>>> +       dev_warn(dev,
>>>> +                "WARNING: Attempt to write %d characters to read-only
>>>> attribute %s.", +               count, attr->attr.name);
>>>> +       return -EPERM;
>>>> +}
>>>
>>> Here it looks like you're hiding a lot of stuff that should be dev_warn()?
>>> Consider my earlier point about dynamic debug.
>>
>> In previous patch submissions, we always used these warning functions.
>> But in the feedback on those patches, we were asked to just make
>> sysfs show/store NULL if the attribute is write/read only.  However,
>> during their development process, our customers want to see the
>> warnings if the attributes are accessed incorrectly.  So we made
>> these warnings a debug option.
>
> See Dmitry's comment ...
>
> Basically my stance is that you should not lower yourself to the
> level of others not getting the point of your technical solution
> by making unelegant compromises, what
> you should do is to bring them up to your level so they
> understand that your solution is elegant.
>
> Maybe a bit utopist I know...

What's the old saying?  "I want to live in Theory.  Everything is always 
so nice there..."  :-)

Anyway, see my reply to Dmitry a bit ago.  These are no longer needed, 
so we'll drop them.
