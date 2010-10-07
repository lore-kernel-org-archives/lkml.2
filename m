Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776Ab0JGBdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 21:33:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48155 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635Ab0JGBc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 21:32:59 -0400
Message-ID: <4CAD2340.9040305@ti.com>
Date: Wed, 6 Oct 2010 20:32:48 -0500
From: Omar Ramirez Luna <omar.ramirez@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: Greg KH <greg@kroah.com>, linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Hiroshi Doyu <hiroshi.doyu@nokia.com>
Subject: Re: [PATCH 0/2] omap: dsp: make the driver actually work
References: <1286208555-8829-1-git-send-email-felipe.contreras@gmail.com>	<20101005190741.GC20825@kroah.com>	<AANLkTikOBWxXh7uVrDxfW3OnwOM58JTXU76KUUoQWBWM@mail.gmail.com>	<27F9C60D11D683428E133F85D2BB4A5304681D4889@dlee03.ent.ti.com>	<AANLkTin=k07hUq+cLAOsf0aYw5Ey23UOpbpo=+Eb49w9@mail.gmail.com>	<27F9C60D11D683428E133F85D2BB4A5304681D48D3@dlee03.ent.ti.com> <AANLkTi=ENjWQRYitr_kYzmRKgve=CoBf=7Y5KHLJNLfb@mail.gmail.com>
In-Reply-To: <AANLkTi=ENjWQRYitr_kYzmRKgve=CoBf=7Y5KHLJNLfb@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/2010 4:05 PM, Felipe Contreras wrote:
> On Tue, Oct 5, 2010 at 11:09 PM, Ramirez Luna,
> Omar<omar.ramirez@ti.com>  wrote:
>> Felipe Contreras wrote:
...
>>
>> Hmmm, because my other option was to move the reserved memory
>> outside the kernel, but that involves specifying bootargs again and
>> using dma_alloc_coherent with their restrictions.
>
> Huh, if there's no contiguous memory region reserved, then the
> driver is doing dma_alloc_coherent already, but that fails
> (apparently 5M is too much). Plus I've read that dma_alloc_coherent
> is "precious"; shouldn't be used for that.

Initially bridge was using the memory on the upper part of the RAM, 
specifying in bootargs mem=MAX-6MB, so reintroducing the parameter works 
fine; dma_alloc_coherent was also used when bridge was compiled as 
built-in the kernel but now it is not working either.

>
> So, first I wanted to try reserving some region with mem=X boot
> param, but that solution is ugly. If that worked, then I wanted ti
> see if flushing each time we access that shm memory block works, but
> in the process I wanted to reorganize the whole initialization code
> because right now it's very ugly and confusing.
>

Yes, I can help with that, I'm sending a patch to reintroduce the 
parameter for phys_mempool_base, however we need to remove or disable 
the memblock functions related with dspbridge. I was thinking of a 
menuconfig parameter to specify mempool base for built-in compilation.

Regards,

Omar

