Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759794Ab2J3PF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:05:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:21741 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab2J3PF5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:05:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,679,1344236400"; 
   d="scan'208";a="241957897"
Message-ID: <1351609530.11158.87.camel@smile>
Subject: Re: [PATCHv3 5/7] dmaengine: dw_dmac: add PCI part of the driver
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Tue, 30 Oct 2012 17:05:30 +0200
In-Reply-To: <CAKohpo=t_uV-S+cbeDFvSDLe0SxXVx6tvA8yGMF45-YvU_FRvw@mail.gmail.com>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348735450.1648.5.camel@vkoul-udesk3> <1348739022.13371.157.camel@smile>
	 <1348740071.1648.25.camel@vkoul-udesk3>
	 <CAOh2x=ntwp22Z3sHf9QehVwab--ZayF-kmTpZsjbkyQYVxrzpw@mail.gmail.com>
	 <1349691428.10584.95.camel@smile>
	 <CAKohpokGsAv2cPjj2EMvmTmN1Q+LOU7mN0H9YZcGzs95mm6c-w@mail.gmail.com>
	 <1349700409.10584.118.camel@smile>
	 <CAKohpo=t_uV-S+cbeDFvSDLe0SxXVx6tvA8yGMF45-YvU_FRvw@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-08 at 18:57 +0530, Viresh Kumar wrote: 
> On 8 October 2012 18:16, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > On Mon, 2012-10-08 at 16:19 +0530, Viresh Kumar wrote:
> >> > First of all it will export IP-block relevant functions to the kernel
> >> > namespace. I think it is not a good idea to pollute kernel more.
> >>
> >> So, few routines which are required to be called from probe,
> >> suspend/resume and exit would be made non-static... This is what you
> >> wanted to say? Hopefully most of the routines would still be declared
> >> static in the core file. So IMHO, the simplicity or clarity that new approach
> >> gives has more advantages than this aspect.
> > The probe (core part), remove, shutdown, suspend, and resume will be
> > exported. Practically each generic function which will be used in
> > drivers outside of core. Why do we need them in the kernel namespace?
> 
> And these are generic kernel framework supporting routines, instead of
> routines that expose the hardware. Even then exposing them isn't that bad.
> 
> I do agree, we must have as less routines in kernel namespace as possible.
> But not at the price of over complexity of stuff which isn't required.

I didn't see the complexity you are talking about. 

> >> That's why depends-on should not
> >> allow you to make core part as module alone...
> >> I couldn't get the issue completely. What's the problem in this approach?
> >
> > Why we need to do this if we could avoid it? I see nothing to prevent us
> > to build parts as modules, or otherwise, or mixed style.
> > In other words one approach provides weak dependency and the other -
> > hard dependency between pieces of code.
> 
> I agree that there are some parts of your approach which might be having
> few advantages. But it is actually adding more complexity without much
> need of it.

Sorry, still didn't get where it is (complexity) and in what part.

> Logically speaking, we never had two devices for the same
> dma controller.

What do you mean by this? Do we ever have the same IP block on different
buses at the same time? I think it's potentially possible.

> We are adding them just to have pci over platform.. Which
> would mean the system become more and more complex..


> So, during run time...
> - there will be two device-driver binding loops.. Once for pci and then for
>   platform

Is this a real problem? We have dozens of the drivers on modern hw, part
of them by the way use proposed approach.

> - In suspend/resume... two devices will get into suspend, instead of one..

True. But it allows to keep a potential to have the same devices to be
attached to the different buses simultaneously.

> - There might be other frameworks in kernel.. which react on struct device
>    basis... they will get affected too..

I'm wondering if there any that affects us. I think you might know if
there was any example of it (in history?).

> - You have larger image size for pci case. as you compile platform too..

How much? I didn't check this, but I believe it will consume one page at
most.

> Just try to think from this perspective... we dont have two hardware devices
> in the system.... Ideally speaking there must be a struct device associated
> with a hardware device...

I'm sorry, but I'm still not fully convinced by those arguments. For me
it looks like both approaches have good and bad aspects on the similar
level.

Actually sdhci seems for me as a not good example. In the mmc code they
have already robust architecture (there is host controller, there is
core part, there is card part and so on...) and enough of ->ops
structures. We have a simpler driver.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
