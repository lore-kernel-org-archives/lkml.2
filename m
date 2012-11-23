Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab2KWMZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:25:31 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34953 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab2KWMZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:25:29 -0500
MIME-Version: 1.0
In-Reply-To: <20121123121413.GB22268@gmail.com>
References: <912d88b8906ce87cf5459cf3d5798e03bfce34c7.1353649737.git.viresh.kumar@linaro.org>
	<20121123103400.GO17471@gmail.com>
	<CAKohponW-Wd+Vrnj8mbdFMmJvwQgPq1jFCZRipBFoEhTknStHQ@mail.gmail.com>
	<20121123121413.GB22268@gmail.com>
Date: Fri, 23 Nov 2012 17:55:28 +0530
Message-ID: <CAKohpom1RMUzSk2+GRFS-yh8bWt7J-jkF_LJP1iSdL=gLCYPsw@mail.gmail.com>
Subject: Re: [PATCH] gpio: stmpe: Add DT support for stmpe gpio
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 November 2012 17:44, Lee Jones <lee.jones@linaro.org> wrote:
> I'm saying, just leave it where it is.

So you are suggesting this code:

        stmpe_gpio->chip.base = pdata ? pdata->gpio_base : -1;

       if (pdata)
               stmpe_gpio->norequest_mask = pdata->norequest_mask;
       else if (np)
               of_property_read_u32(np, "st,norequest-mask",
&pdata->norequest_mask);

Right? Then yes i can do it.

>> >> +             if (np)
>> >> +                     of_property_read_u32(np, "st,norequest-mask",
>> >> +                                     &pdata->norequest_mask);
>> >
>> > Can you explain to me what this does?
>>
>> You mean pdata->norequest_mask?  It marks few gpios as unusable.
>> Because these pads might be used by other blocks of stmpe.
>
> I'm not sure if that should be set with DT or not.
>
> Second opinion anyone?

Why i kept it in DT is because it is board dependent and there is no better
way of communicating this from board to driver.

--
viresh
