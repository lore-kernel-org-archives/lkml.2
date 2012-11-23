Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2KWMOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:14:20 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61821 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2KWMOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:14:18 -0500
Date: Fri, 23 Nov 2012 12:14:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH] gpio: stmpe: Add DT support for stmpe gpio
Message-ID: <20121123121413.GB22268@gmail.com>
References: <912d88b8906ce87cf5459cf3d5798e03bfce34c7.1353649737.git.viresh.kumar@linaro.org>
 <20121123103400.GO17471@gmail.com>
 <CAKohponW-Wd+Vrnj8mbdFMmJvwQgPq1jFCZRipBFoEhTknStHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohponW-Wd+Vrnj8mbdFMmJvwQgPq1jFCZRipBFoEhTknStHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> -     stmpe_gpio->chip.base = pdata ? pdata->gpio_base : -1;
> >
> > Why have you deleted this?
> >
> >> +
> >> +     if (pdata) {
> >> +             stmpe_gpio->norequest_mask = pdata->norequest_mask;
> >> +             stmpe_gpio->chip.base = pdata->gpio_base;
> >
> > Then added this?
> >
> >> +     } else {
> >> +             stmpe_gpio->chip.base = -1;
> >
> > And this?
> 
> To group all non-DT assignments in a single if block, instead of two.

That assignment has nothing to do with DT.

> > Just leave the top line in and it saves you lots of complecations.
> 
> Sorry, Couldn't get this one.

I'm saying, just leave it where it is.

> >> +             if (np)
> >> +                     of_property_read_u32(np, "st,norequest-mask",
> >> +                                     &pdata->norequest_mask);
> >
> > Can you explain to me what this does?
> 
> You mean pdata->norequest_mask?  It marks few gpios as unusable.
> Because these pads might be used by other blocks of stmpe.

I'm not sure if that should be set with DT or not.

Second opinion anyone?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
