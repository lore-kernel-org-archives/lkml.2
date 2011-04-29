Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab1D2NeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 09:34:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55552 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab1D2NeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 09:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CnRpHAZ6pRGCj4eI7h0gLBqBq9WIcDil6hZJrNf3oaVPHvbGlJdIV6f1r//8hMGalr
         Lgs/Wqtzro41Y9SwJOH0z/PMUNojVWDVNrA2025ilW06wSLBHDGtuf9VX95THPr2Lbhn
         gKyd4/zBqQL+7X6zwoWuTayvnr26MKLo3FVN4=
MIME-Version: 1.0
In-Reply-To: <4DBAA9B4.3070306@vmware.com>
References: <201104212129.17013.arnd@arndb.de>
	<20110428093039.GU17290@n2100.arm.linux.org.uk>
	<1304024836.2513.198.camel@pasglop>
	<201104291326.25634.arnd@arndb.de>
	<4DBAA9B4.3070306@vmware.com>
Date: Fri, 29 Apr 2011 09:34:05 -0400
Message-ID: <BANLkTinNMxpAcjpBR7r1f1RA31kww=v6Fw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
From: Jerome Glisse <j.glisse@gmail.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 8:06 AM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
> On 04/29/2011 01:26 PM, Arnd Bergmann wrote:
>>
>> On Thursday 28 April 2011, Benjamin Herrenschmidt wrote:
>>
>>>>>
>>>>> For PCI you can have the flag propagate from the PHB down, for busses
>>>>> without a bus type (platform) then whoever instanciate them (the
>>>>> platform code) can set that appropriately.
>>>>>
>>>>
>>>> How can you do that when it changes mid-bus heirarchy?  I'm thinking
>>>> of the situation where the DRM stuff is on a child bus below the
>>>> root bus, and the root bus has DMA coherent devices on it but the DRM
>>>> stuff doesn't.
>>>>
>>>
>>> But that's not PCI right ? IE. with PCI, coherency is a property of the
>>> PHB...
>>>
>>
>> That is my understanding at least, but I'd like to have a confirmation
>> from the DRM folks.
>>
>> I believe that the PC graphics cards that have noncoherent DMA mappings
>> are all of the unified memory (integrated into the northbridge) kind,
>> so they are not on the same host bridge as all regular PCI devices,
>> even if they appear as a PCI device.
>>
>
> I think Jerome has mentioned at one point that the Radeon graphics cards
> support
> non-coherent mappings.
>
> Fwiw, the PowerVR SGX MMU also supports this mode of operation, although it
> being functional I guess depends on the system implementation.
>
> /Thomas
>

Radeon memory controller can do non snooped pci transaction, as far as
i have tested most of the x86 pci bridge don't try to be coherent then
ie they don't analyze pci dma and ask for cpu flush they just perform
the request (and i guess it's what all bridge will do), so it endup
being noncoherent. I haven't done any benchmark of how faster it's for
the GPU when it's not snooping but i guess it can give 50% boost as it
likely drastictly reduce pci transaction overhead.

I am talking here about device that you plug into any pci or pcie
slot, so it's not igp integrated into northbridge or into the cpu.

Cheers,
Jerome
