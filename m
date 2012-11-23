Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2KWPpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:45:34 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55613 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab2KWPpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:45:33 -0500
Date: Fri, 23 Nov 2012 15:45:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH] gpio: stmpe: Add DT support for stmpe gpio
Message-ID: <20121123154527.GB28552@gmail.com>
References: <912d88b8906ce87cf5459cf3d5798e03bfce34c7.1353649737.git.viresh.kumar@linaro.org>
 <20121123103400.GO17471@gmail.com>
 <CAKohponW-Wd+Vrnj8mbdFMmJvwQgPq1jFCZRipBFoEhTknStHQ@mail.gmail.com>
 <20121123121413.GB22268@gmail.com>
 <CAKohpom1RMUzSk2+GRFS-yh8bWt7J-jkF_LJP1iSdL=gLCYPsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpom1RMUzSk2+GRFS-yh8bWt7J-jkF_LJP1iSdL=gLCYPsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012, Viresh Kumar wrote:

> On 23 November 2012 17:44, Lee Jones <lee.jones@linaro.org> wrote:
> > I'm saying, just leave it where it is.
> 
> So you are suggesting this code:
> 
>         stmpe_gpio->chip.base = pdata ? pdata->gpio_base : -1;
> 
>        if (pdata)
>                stmpe_gpio->norequest_mask = pdata->norequest_mask;
>        else if (np)
>                of_property_read_u32(np, "st,norequest-mask",
> &pdata->norequest_mask);
> 
> Right? Then yes i can do it.

It would be better if you'd sent it as a diff, but yes, leave the
top line as it is and just add the norequest-mask stuff (if it's
required).

> >> >> +             if (np)
> >> >> +                     of_property_read_u32(np, "st,norequest-mask",
> >> >> +                                     &pdata->norequest_mask);
> >> >
> >> > Can you explain to me what this does?
> >>
> >> You mean pdata->norequest_mask?  It marks few gpios as unusable.
> >> Because these pads might be used by other blocks of stmpe.
> >
> > I'm not sure if that should be set with DT or not.
> >
> > Second opinion anyone?
> 
> Why i kept it in DT is because it is board dependent and there is no better
> way of communicating this from board to driver.

I can't comment, as I really don't know.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
