Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab2HUMW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:22:57 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:40516 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756396Ab2HUMUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:20:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120821120052.GD10347@arwen.pp.htv.fi>
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
	<1345545940-2232-5-git-send-email-sourav.poddar@ti.com>
	<20120821105333.GW10347@arwen.pp.htv.fi>
	<CAKdam56DiFpnoQwrHe1tjQWLMy5vP9ynstNj_n=OyMxkJJAUOA@mail.gmail.com>
	<20120821120052.GD10347@arwen.pp.htv.fi>
Date: Tue, 21 Aug 2012 17:50:28 +0530
Message-ID: <CAKdam55SqXiCGv766yxoY1GdDjxNCYNaDdNZPaeLTAXc+3+c6g@mail.gmail.com>
Subject: Re: [RFC/PATCH 4/4] gpio: smscece: Add support for gpio IO expander feature
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: balbi@ti.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 21, 2012 at 5:30 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Aug 21, 2012 at 05:17:37PM +0530, Poddar, Sourav wrote:
>> >> +     if (type & IRQ_TYPE_LEVEL_HIGH)
>> >> +             sg->int_lvl[bank] |= bit;
>> >> +     else if (type & IRQ_TYPE_LEVEL_LOW)
>> >> +             sg->int_lvl[bank] &= ~bit;
>> >> +     else
>> >> +             return -EINVAL;
>> >
>> > this looks wrong. You could have a user who wants to trigger on both
>> > HIGH and LOW levels, no ?
>> >
>> Yes, I think there can be a scenario where gpio_keys are attached
>> to this driver and signals a "key press" at low and "key release" at
>> high. ?
>>  Will figure out a way to add support to check for case where
>> both High and low levels are used.
>
> could probably be done on a separate patch, maybe... Just now I saw that
> HIGH and LOW levels use the same bit.
>
If I am understanding correctly, if they both uses the same bit we cannot
use both for a particular user. ?
> --
> balbi
