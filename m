Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160996Ab2JYPvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:51:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33302 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933029Ab2JYPvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:51:48 -0400
Date: Thu, 25 Oct 2012 16:51:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 2/6] pinctrl: Update clock handling for the
 pinctrl-nomadik GPIO driver
Message-ID: <20121025155143.GK4008@gmail.com>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
 <1351089926-32161-3-git-send-email-lee.jones@linaro.org>
 <CACRpkda2NQok7kzh0pFmZPYd4nky1kUw=67DZAYAJAXGuc1yzQ@mail.gmail.com>
 <CACRpkdbNWE6hOdVFPxHv7MVHkZUBW3LC035CxJkZVmr8j05Kqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbNWE6hOdVFPxHv7MVHkZUBW3LC035CxJkZVmr8j05Kqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012, Linus Walleij wrote:

> On Thu, Oct 25, 2012 at 2:41 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Wed, Oct 24, 2012 at 4:45 PM, Lee Jones <lee.jones@linaro.org> wrote:
> >
> >> The clock framework has changed somewhat and it's now better to
> >> invoke clock_prepare_enable() and clk_disable_unprepare() rather
> >> than the legacy clk_enable() and clk_disable() calls. This patch
> >> converts the Nomadik Pin Control driver to the new framework.
> >>
> >> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >
> > I was convinced that this is a good change but no regression,
> > so applied to the devel branch for 3.8.
> >
> > I also removed the initial clk_prepare() so the reference count
> > may actually go down to 0 for the GPIO block and the peripheral
> > cluster eventually gets relaxed.
> 
> Famous last words!
> 
> The good news is that this actually works, and the refcount
> *does* go down to zero and gate off entire peripheral
> clusters.
> 
> However that was not good because something vital in
> some peripheral cluster died and killed the system :-D
> 
> Lee, could to to track down the reason and fix it so the patch
> can be applied?
> 
> The only thing you need to do is to remove the superfluous
> clk_prepare() right after the devm_clk_get() that hogs each
> peripheral cluster.
> 
> Probably some driver is needing a clk_get() or a clk_get_sys() is
> needs to be added somewhere to bring up some vital cluster,
> or there may be some out-of-tree driver needed to bring up the
> cluster properly I have no clue... Maybe some cluster just
> cannot be declocked like that.

I leave work in 10 mins and won't be coding again for ~2.5 weeks.
So if this is something you could squeeze in and fix-up, I'd be
very grateful.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
