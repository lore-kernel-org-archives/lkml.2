Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab1AYScV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:32:21 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:38016 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772Ab1AYScU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 13:32:20 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
 <1295834493-5019-5-git-send-email-ccross@android.com> <1295968464.10109.264.camel@e102109-lin.cambridge.arm.com>
 <20110125154133.GB17280@n2100.arm.linux.org.uk> <1295979242.10109.308.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acu8u7KCwhXmEL/iQBe2UXqbx+W52wAAbzZw
In-Reply-To: <1295979242.10109.308.camel@e102109-lin.cambridge.arm.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Date: Wed, 26 Jan 2011 00:02:15 +0530
Message-ID: <2f97ec8a084e590220e1548fc927b60e@mail.gmail.com>
Subject: RE: [PATCH v2 04/28] ARM: mm: cache-l2x0: Add support for re-enabling l2x0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Colin Cross <ccross@android.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net,
        konkers@android.com, Linus Walleij <linus.walleij@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Catalin Marinas [mailto:catalin.marinas@arm.com]
> Sent: Tuesday, January 25, 2011 11:44 PM
> To: Russell King - ARM Linux
> Cc: Colin Cross; linux-tegra@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; olof@lixom.net; konkers@android.com;
> Santosh Shilimkar; Linus Walleij; Tony Lindgren; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v2 04/28] ARM: mm: cache-l2x0: Add support for
> re-enabling l2x0
>
> On Tue, 2011-01-25 at 15:41 +0000, Russell King - ARM Linux wrote:
> > I think we need to come up with some proper way to deal with
> cpuidle
> > which doesn't involve adding lots of globally visible functions to
> all
> > sorts of bits of code and having platforms call them individually,
> > otherwise this is going to get _really_ messy in the future.
> >
> > Maybe we need a notifier list which can be told when cpuidle
> events
> > happen, so that parts of the system such as VFP and L2 cache
> support
> > can do the right thing without having platforms add lots of stuff
> like
> >
> >         gic_secondary_init();
> >         gic_restore_interrupt_types();
> >         vfp_enable();
> >         l2x0_enable();
> >         twd_enable();
> >         ... etc ...
> >
> > in their SoC specific code.
>
> But do we need a strict order between such operations? The notifier
> call
> chain isn't too flexible.
>
I guess it does depends on how the archs have integrated a9. Example
on OMAP there are different power modes possible.
	1. CPU context ,TWD lost
	2. CPU context ,TWD + L1 is lost
	3. CPU context + L1 is lost + GIC lost
	4. CPU context + L1 is lost + GIC lost + L2 lost
So there is need to have flexibility of calling these function
based on power modes. I don't know how notifiers can give
this flexibility

Regards,
Santosh
