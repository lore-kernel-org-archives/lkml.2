Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123Ab2JYHbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:31:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52107 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758290Ab2JYHbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:31:32 -0400
Date: Thu, 25 Oct 2012 08:31:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 2/6] pinctrl: Update clock handling for the
 pinctrl-nomadik GPIO driver
Message-ID: <20121025073127.GB971@gmail.com>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
 <1351089926-32161-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdaeBW2ecQZ2fA-hL8o47pYpjZ=5Mn131F87u58rX+dekw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaeBW2ecQZ2fA-hL8o47pYpjZ=5Mn131F87u58rX+dekw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Linus Walleij wrote:

> On Wed, Oct 24, 2012 at 4:45 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > The clock framework has changed somewhat and it's now better to
> > invoke clock_prepare_enable() and clk_disable_unprepare() rather
> > than the legacy clk_enable() and clk_disable() calls. This patch
> > converts the Nomadik Pin Control driver to the new framework.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> (...)
> > -               clk_enable(chip->clk);
> > +               clk_prepare_enable(chip->clk);
> (...)
> > -               clk_disable(chip->clk);
> > +               clk_disable_unprepare(chip->clk);
> 
> (Repeated for each occurence.)
> 
> Is this *really* causing a regression? I mean the driver
> begin like this in nmk_gpio_probe():
> 
>         clk = devm_clk_get(&dev->dev, NULL);
>         if (IS_ERR(clk)) {
>                 ret = PTR_ERR(clk);
>                 goto out;
>         }
>         clk_prepare(clk);
> 
> Then it leaves the clock prepared. So the clock is always
> prepared. You would only need to enable/disable it at times.
> 
> And the semantics of the clk_enable/clk_disable call pair
> is such that it is fastpath and should be real quick, and that
> is exactly why we're using it repeatedly like that. Inserting
> clk_unprepare() effectively could make the whole driver a
> lot slower, so convince me on this one. ...
> 
> I suspect the real bug (if there is one) must be in the clock
> implementation.

This certainly doesn't fix the bug we spoke about. I believe Ulf
is still working on that one.

So do you want me to remove this patch?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
