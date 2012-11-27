Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab2K0NDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:03:17 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48857 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab2K0NDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:03:16 -0500
Date: Tue, 27 Nov 2012 13:03:11 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 1/1] ARM: ux500: Fix u9540 booting issues
Message-ID: <20121127130311.GE2013@gmail.com>
References: <1354008890-10476-1-git-send-email-lee.jones@linaro.org>
 <201211271236.01493.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201211271236.01493.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2012, Arnd Bergmann wrote:

> On Tuesday 27 November 2012, Lee Jones wrote:
> 
> > The u9540 stopped booting after the v3.7 merge window due to
> > a lack of common clk support and early PRCMU initialisation.
> > In this patch we rectify these issues, placing the u9540
> > development board back into a successfully booting state.
> 
> > -       if (cpu_is_u8500_family())
> > +       if (cpu_is_u8500_family() || cpu_is_u9540())
> >                 u8500_clk_init();
> > -       else if (cpu_is_u9540())
> > -               u9540_clk_init();
> >         else if (cpu_is_u8540())
> >                 u8540_clk_init();
> 
> It certainly doesn't /look/ right, even if it works.  Can you explain why
> u8540_clk_init works and u9540_clk_init doesn't?

Because it's empty. :)

Common clk doesn't support the u9540 yet, and even when it does,
most (all?) of the clocks will be identical to the u9540 in any
case.

I believe Linus wants to apply this with a TODO, to ensure the
board is at least bootable. This whole section is in the wrong
place anyway IMHO, and needs moving out to somewhere less hacky,
rather than initialising clocks and the PRCMU from .init_irq.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
