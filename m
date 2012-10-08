Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2JHN1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:27:20 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42304 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab2JHN1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:27:16 -0400
MIME-Version: 1.0
In-Reply-To: <1349700409.10584.118.camel@smile>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348735450.1648.5.camel@vkoul-udesk3>
	<1348739022.13371.157.camel@smile>
	<1348740071.1648.25.camel@vkoul-udesk3>
	<CAOh2x=ntwp22Z3sHf9QehVwab--ZayF-kmTpZsjbkyQYVxrzpw@mail.gmail.com>
	<1349691428.10584.95.camel@smile>
	<CAKohpokGsAv2cPjj2EMvmTmN1Q+LOU7mN0H9YZcGzs95mm6c-w@mail.gmail.com>
	<1349700409.10584.118.camel@smile>
Date: Mon, 8 Oct 2012 18:57:15 +0530
Message-ID: <CAKohpo=t_uV-S+cbeDFvSDLe0SxXVx6tvA8yGMF45-YvU_FRvw@mail.gmail.com>
Subject: Re: [PATCHv3 5/7] dmaengine: dw_dmac: add PCI part of the driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 October 2012 18:16, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Mon, 2012-10-08 at 16:19 +0530, Viresh Kumar wrote:
>> > First of all it will export IP-block relevant functions to the kernel
>> > namespace. I think it is not a good idea to pollute kernel more.
>>
>> So, few routines which are required to be called from probe,
>> suspend/resume and exit would be made non-static... This is what you
>> wanted to say? Hopefully most of the routines would still be declared
>> static in the core file. So IMHO, the simplicity or clarity that new approach
>> gives has more advantages than this aspect.
> The probe (core part), remove, shutdown, suspend, and resume will be
> exported. Practically each generic function which will be used in
> drivers outside of core. Why do we need them in the kernel namespace?

And these are generic kernel framework supporting routines, instead of
routines that expose the hardware. Even then exposing them isn't that bad.

I do agree, we must have as less routines in kernel namespace as possible.
But not at the price of over complexity of stuff which isn't required.

>> What if core driver isn't inserted
>> and platform's probe is already called.
> Nothing will happen in my case until user loads all necessary bits.
>
>> That's why depends-on should not
>> allow you to make core part as module alone...
>> I couldn't get the issue completely. What's the problem in this approach?
>
> Why we need to do this if we could avoid it? I see nothing to prevent us
> to build parts as modules, or otherwise, or mixed style.
> In other words one approach provides weak dependency and the other -
> hard dependency between pieces of code.

I agree that there are some parts of your approach which might be having
few advantages. But it is actually adding more complexity without much
need of it. Logically speaking, we never had two devices for the same
dma controller. We are adding them just to have pci over platform.. Which
would mean the system become more and more complex..

So, during run time...
- there will be two device-driver binding loops.. Once for pci and then for
  platform
- In suspend/resume... two devices will get into suspend, instead of one..
- There might be other frameworks in kernel.. which react on struct device
   basis... they will get affected too..
- You have larger image size for pci case. as you compile platform too..

Just try to think from this perspective... we dont have two hardware devices
in the system.... Ideally speaking there must be a struct device associated
with a hardware device...

@Arnd/Vinod: Can you guys throw some more light here.. on the adv/disadv
of both the approaches?

--
viresh
