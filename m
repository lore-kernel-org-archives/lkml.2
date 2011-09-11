Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab1IKV1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 17:27:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54261 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab1IKV1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 17:27:33 -0400
MIME-Version: 1.0
In-Reply-To: <1315517883.6638.1.camel@vkoul-mobl4>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
	<201109081819.30035.arnd@arndb.de>
	<CAKnu2Mpnjec-hvfbT0zH1P2mGZKNwTQYgDLGHWUXLmGGQB0_ow@mail.gmail.com>
	<2264116.VTHb2BIH5a@wuerfel>
	<1315517883.6638.1.camel@vkoul-mobl4>
Date: Sun, 11 Sep 2011 23:27:33 +0200
Message-ID: <CACRpkdYkuhhR8yNMK1cENan9WX5Fv7o_0qSN3_c3VJQwrvzgjg@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vkoul@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, vinod.koul@intel.com,
        Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>,
        Barry Song <Baohua.Song@csr.com>, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 8, 2011 at 11:38 PM, Vinod Koul <vkoul@infradead.org> wrote:
> On Thu, 2011-09-08 at 22:11 +0200, Arnd Bergmann wrote:
>> On Thursday 08 September 2011 20:48:26 Linus Walleij wrote:
>> > 2011/9/8 Arnd Bergmann <arnd@arndb.de>:
>> > > On Thursday 08 September 2011, Barry Song wrote:
>> > >>
>> > >> this filter is used by all drivers with DMA since every dma channel is
>> > >> fixed to be assigned to one device.
>> > >
>> > > Ok, I see now. I think it would be best to introduce a generic
>> > > 'filter by device tree property' function or alternatively an
>> > > dma_of_request_channel function like this:
>> >
>> > You'd have to discuss that with Vinod, the thing is that x86 Atom
>> > systems are using dmaengine for device slave transfers too, and
>> > IIRC these things don't use devicetrees. I may be wrong...
>>
>> Some of them use device tree, some don't.
>>
>> I'm not saying that we have to convert all drivers to use this, but
>> for platforms that always have device tree available, it seems by far
>> the cleanest solution.
> We don't have a very clean solution for filter function in case of slave
> dmaengine. How should the client specify which channel it wants is not
> really clear.
>
> We can look at device tree but that's something which wont work in case
> of non device tree platforms (atom x86).
> What we need is this information of channel mapping, which IMO is
> platform specific and needs to come from platform data, we can abstract
> it actually from the device tree data/PCI/firmware etc but essentially a
> mechanism to publish channels and slaves uniquely and match them in this
> kind of data
>
> Linus W, any progress on that patches you posted??

I haven't written any, and I felt the whole issue was pretty inflamed
too so I felt bad about it and avoided to think about it even since
I have no real problem with this in my current setups.

Currently there is a strong coupling between platforms and filter
functions and I can live with it in the systems I use since they have
just one DMAC and need only one filter function per device,
that is specified in platform data for the device. This would likely
also work for the SiRFprimaII if it has only a single DMAC.
The people facing an immediate issue with this are IIRC the
Samsung S5Ps.

If you think this is in need of solving soon and want me to propose
patches for channel mapping to devices using the approach used in
clkdev and regulator APIs to create an attributed mapping table
using struct device * or its string representations, I can
try it out of course, but if it gets flamy I will just back off again.

Thanks,
Linus Walleij
