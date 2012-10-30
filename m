Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab2J3PTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:19:06 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55421 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2J3PTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:19:04 -0400
MIME-Version: 1.0
In-Reply-To: <1351609530.11158.87.camel@smile>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348735450.1648.5.camel@vkoul-udesk3>
	<1348739022.13371.157.camel@smile>
	<1348740071.1648.25.camel@vkoul-udesk3>
	<CAOh2x=ntwp22Z3sHf9QehVwab--ZayF-kmTpZsjbkyQYVxrzpw@mail.gmail.com>
	<1349691428.10584.95.camel@smile>
	<CAKohpokGsAv2cPjj2EMvmTmN1Q+LOU7mN0H9YZcGzs95mm6c-w@mail.gmail.com>
	<1349700409.10584.118.camel@smile>
	<CAKohpo=t_uV-S+cbeDFvSDLe0SxXVx6tvA8yGMF45-YvU_FRvw@mail.gmail.com>
	<1351609530.11158.87.camel@smile>
Date: Tue, 30 Oct 2012 20:49:03 +0530
Message-ID: <CAKohpon7KP5V3xjMG_HaNoP3x1aPT2FtivTz=41PT7neGTpTUw@mail.gmail.com>
Subject: Re: [PATCHv3 5/7] dmaengine: dw_dmac: add PCI part of the driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 October 2012 20:35, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Mon, 2012-10-08 at 18:57 +0530, Viresh Kumar wrote:

>> I do agree, we must have as less routines in kernel namespace as possible.
>> But not at the price of over complexity of stuff which isn't required.
>
> I didn't see the complexity you are talking about.

Complexity not in the way that we need a genius to understand the code :)
But creating devices layer which doesn't exist.

>> Logically speaking, we never had two devices for the same
>> dma controller.
>
> What do you mean by this? Do we ever have the same IP block on different
> buses at the same time? I think it's potentially possible.

One device is one instance of an IP. With your approach we will have two
device structures for a single physical IP present.

>> We are adding them just to have pci over platform.. Which
>> would mean the system become more and more complex..
>
>> So, during run time...
>> - there will be two device-driver binding loops.. Once for pci and then for
>>   platform
>
> Is this a real problem? We have dozens of the drivers on modern hw, part
> of them by the way use proposed approach.

I am repeating this (probably said this earlier, if not sorry). If
something already
exists in kernel, it doesn't meant that it is perfect and others
should blindly follow
it.

The loops isn't a problem, but an unnecessary activity done.

>> - In suspend/resume... two devices will get into suspend, instead of one..
>
> True. But it allows to keep a potential to have the same devices to be
> attached to the different buses simultaneously.

I don't see why a single physical block would be connected to AMBA and PCI
at the same time. And obviously that's not the case right now, so better leave
that in current argument :)

>> - There might be other frameworks in kernel.. which react on struct device
>>    basis... they will get affected too..
>
> I'm wondering if there any that affects us. I think you might know if
> there was any example of it (in history?).

There are many frameworks which work per device. regulator, clk, RTPM, etc.
They will see a hardware hierarchy which doesn't exist.

>> - You have larger image size for pci case. as you compile platform too..
>
> How much? I didn't check this, but I believe it will consume one page at
> most.

Whatever amount it is. We can't waste it.

> Actually sdhci seems for me as a not good example. In the mmc code they
> have already robust architecture (there is host controller, there is
> core part, there is card part and so on...) and enough of ->ops
> structures. We have a simpler driver.

I am not talking about SD/MMC as a whole. SDHCI targets a specific hardware
configuration (manufactured by multiple vendors). It is very similar to our case
here.

For me i don't agree with your approach. So, its a NACK.
However if Arnd/Vinod or You can give me some strong points about
your approach, i can consider it again :)

--
viresh
