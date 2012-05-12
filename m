Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761472Ab2ELA3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:29:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43679 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761408Ab2ELA3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:29:15 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio/exynos: Fix compiler warnings when non-exynos machines are selected
To: Linus Walleij <linus.walleij@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        patches@linaro.org
In-Reply-To: <CACRpkdYHKR+oOD36RCUMobEwJj_Y9WDHTUY+UaHAx0YegMhXyg@mail.gmail.com>
References: <1335768768-10231-1-git-send-email-sachin.kamat@linaro.org> <CACRpkdYHKR+oOD36RCUMobEwJj_Y9WDHTUY+UaHAx0YegMhXyg@mail.gmail.com>
Date: Fri, 11 May 2012 18:29:12 -0600
Message-Id: <20120512002912.8A0A23E0791@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2012 01:26:12 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Apr 30, 2012 at 8:52 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> 
> > +#if defined(CONFIG_ARCH_EXYNOS4) || defined(CONFIG_ARCH_EXYNOS5)
> > +#endif
> > -static struct samsung_gpio_chip exynos4_gpios_1[] = {
> >  #ifdef CONFIG_ARCH_EXYNOS4
> > +static struct samsung_gpio_chip exynos4_gpios_1[] = {
> > -#endif
> > +#endif
> > -static struct samsung_gpio_chip exynos4_gpios_2[] = {
> >  #ifdef CONFIG_ARCH_EXYNOS4
> > +static struct samsung_gpio_chip exynos4_gpios_2[] = {
> > -#endif
> > +#endif
> > -static struct samsung_gpio_chip exynos4_gpios_3[] = {
> >  #ifdef CONFIG_ARCH_EXYNOS4
> > +static struct samsung_gpio_chip exynos4_gpios_3[] = {
> > -#endif
> > +#endif
> >  #ifdef CONFIG_ARCH_EXYNOS5
> > +#if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS5250)
> > +#endif
> > +#if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS5250)
> > +#endif
> 
> We really want to get rid of this kind of stuff from all drivers, #ifdefs are
> declared ugly already in Documentation/CodingStyle.
> 
> Any chance you could solve this problem by reworking the driver to
> pass some flag in platform data tell which exynos it's for
> and jist adapt at runtime instead of the compile-time quirkiness?
> 
> Besides looking better, it helps us to get to a single zImage for the
> exynoses too..

I don't see any single-zImage issues here.  There are no #else clauses
in the #ifdef blocks so all it does it compile out unused code when
exynos4 & 5 is not enabled. I'm going to apply it.

g.

