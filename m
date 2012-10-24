Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965162Ab2JXL1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:27:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:59220 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964954Ab2JXL1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:27:13 -0400
Subject: Re: [PATCHv3 5/7] dmaengine: dw_dmac: add PCI part of the driver
From: Vinod Koul <vkoul@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: vinod.koul@intel.com, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 16:43:38 +0530
Message-ID: <1351077218.5263.62.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-08 at 18:57 +0530, Viresh Kumar wrote:
> I agree that there are some parts of your approach which might be having
> few advantages. But it is actually adding more complexity without much
> need of it. Logically speaking, we never had two devices for the same
> dma controller. We are adding them just to have pci over platform.. Which
> would mean the system become more and more complex..
> 
> So, during run time...
> - there will be two device-driver binding loops.. Once for pci and then for
>   platform
> - In suspend/resume... two devices will get into suspend, instead of one..
> - There might be other frameworks in kernel.. which react on struct device
>    basis... they will get affected too..
> - You have larger image size for pci case. as you compile platform too..
> 
> Just try to think from this perspective... we dont have two hardware devices
> in the system.... Ideally speaking there must be a struct device associated
> with a hardware device...
> 
> @Arnd/Vinod: Can you guys throw some more light here.. on the adv/disadv
> of both the approaches?
I am worried about those tow. Runtime PM handlers in case PCI devices
make life a lot easier am not sure what support will be there for
platform devices in other systems.
Also next version of this h/w on our systems is bringing subtle changes
so having them separate seemed to me a better idea.


-- 
Vinod Koul
Intel Corp.

