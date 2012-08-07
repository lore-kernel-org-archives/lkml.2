Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab2HGH7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:59:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55941 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2HGH7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 03:59:12 -0400
Date: Tue, 7 Aug 2012 08:58:53 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807075853.GA24257@flint.arm.linux.org.uk>
References: <20120806143016.GK16861@opensource.wolfsonmicro.com> <CAN1soZwCr=L3Xdi7HS9dQMxo4DzzbQv2kXo9R_U6QAf7v=B10Q@mail.gmail.com> <20120806154619.GO16861@opensource.wolfsonmicro.com> <CAN1soZzytOwxnS8oNMhFs1rfwVPwFnZoVsXeaMUc4Kf_TnunkA@mail.gmail.com> <20120806155805.GR16861@opensource.wolfsonmicro.com> <20120806192209.GA14594@flint.arm.linux.org.uk> <20120806195352.GC16199@opensource.wolfsonmicro.com> <20120806213124.GB14594@flint.arm.linux.org.uk> <20120806220032.GD26698@opensource.wolfsonmicro.com> <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 09:47:25AM +0800, Haojian Zhuang wrote:
> On Tue, Aug 7, 2012 at 6:00 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Mon, Aug 06, 2012 at 10:31:24PM +0100, Russell King wrote:
> >
> >> Anyway, given that this thread is broken, there's no way for me to find
> >> out what the _original_ issue is that you're talking about.  So I'm going
> >> to guess that it's come up because we're out of IORESOURCE bits.
> >
> > No, that's not it.  What's happened is that Haojian has posted some
> > patching changing all the _IO resources to _MEM in the Marvell PMIC
> > drivers, I think because you yelled at him for using _IO when he
> > reported that the changes in ioport_resource broke things a few releases
> > ago.  Obviously this doesn't achieve a huge amount, it's a misplaced
> > cleanup.
> >
> It's because IO_SPACE_LIMIT is set as 0 if there's no PCI devices. But
> IORESOURCE_IO is also used in PMIC mfd drivers to distinguish
> different components.
> 
> commit 04e1c83806e30ae339fc45def595960c7fef1697
> Author: Russell King <rmk+kernel@arm.linux.org.uk>
> Date:   Wed Jul 6 12:49:59 2011 +0100
> 
>     ARM: io: add a default IO_SPACE_LIMIT definition
> 
>     Add a default IO_SPACE_LIMIT definition.  Explain the chosen value and
>     suggest why platforms would want to make it larger.
> 
>     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> >> So, if we made this a numeric index, then we have 32 resource types
> >> to deal with, and no need to bugger around with re-using an existing
> >> type for something else.
> >
> > This seems sensible, and I'm sure if that change were made people would
> > be delighed to use new resource types, but like I say nobody who's
> > motivated to do anything here seems to have the time to do anything
> > about it.
> >
> > Whoever looks at this would need to do some detective work, it does seem
> > like there must have been a reason to use a bitmask here...
> 
> Changing bitmask to a value for IORESOURCE type is a risk. I agree on Mark
> that someone will complain on this.

We won't know that unless we try and propose to do it in patch form.
>From what I can see, there is nothing in the kernel which technically
prevents us from doing this.

> Could we consider to expand the usage of IORESOURCE_IO? Maybe we can
> use it for both ISA/PCI and IO related in chip.

If it's not clear, I am *completely* against this.  It's a hack and bodge,
and therefore doesn't belong in the kernel.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
