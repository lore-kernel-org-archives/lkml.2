Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab1JNWGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 18:06:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58764 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab1JNWGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 18:06:07 -0400
Message-ID: <4E98B24A.2070408@gmail.com>
Date: Fri, 14 Oct 2011 17:06:02 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Nicolas Pitre <nico@fluxnic.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Erik Gilling <konkers@android.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com> <201110141729.41515.arnd@arndb.de> <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com> <201110141827.53906.arnd@arndb.de> <CAOesGMgDwMeVmwo1WJ3tU+ZdjCSJ6F8mY42e_KwTmzAkGQsqmg@mail.gmail.com> <20111014192011.GS21648@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1110141549160.17040@xanadu.home> <74CDBE0F657A3D45AFBB94109FB122FF173BE1A362@HQMAIL01.nvidia.com> <alpine.LFD.2.02.1110141631530.17040@xanadu.home> <74CDBE0F657A3D45AFBB94109FB122FF173BE1A3A6@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A3A6@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 04:01 PM, Stephen Warren wrote:
> Nicolas Pitre wrote at Friday, October 14, 2011 2:45 PM:
>> On Fri, 14 Oct 2011, Stephen Warren wrote:
> ...
>>> I did originally briefly look into getting U-Boot to boot a zImage, but
>>> that looked like a far more invasive patch. There were rumours of some
>>> chip's custom U-Boot already having such support, but I couldn't find
>>> it, nor any evidence of such support in mainline U-Boot.
>>
>> FRom my clone of the u-Boot repo:
>>
>> $ git grep -l zImage
>> README
>> arch/sh/lib/zimageboot.c
>> arch/x86/lib/zimage.c
>> ...
>>
>> Even the name of some of those files clearly hints zImage support.
>>
>> In any case, loading zImage should be even simpler than loading uImage.
>> It is the same as loading uImage except that you just have to skip the
>> checking and relocating steps.
> 
> Just by way of background in case anyone is wondering why I wrote the
> patch I did:
> 
> Those files both implement custom commands "zimageboot" and "zboot". I
> was looking for integration with the existing "bootm" command.
> 
> The advantage of re-using "bootm" for this is that it already supports
> all the stuff like setting up kernel command-lines, initrds, knowing how
> to pass the FDT to the kernel, and whatever other OS-specific setup might
> be required.
> 
> The disadvantage of adding zImage support to bootm is that I'd have to
> teach a bunch of U-Boot image handling code about a new image format; it
> already knows about "legacy uImage", "FIT" images, and I'd have to add a
> third "zImage" format. Doing so would at least require adding a lot of
> "case IMAGE_FORMAT_ZIMAGE" everywhere, but it'd probably be best to add
> some kind of vtable for image formats to move all the image-format
> knowledge into format-specific files, leaving the users of the images
> with much smaller code.
> 
> I didn't feel like making such a large change. Hence, I chose to make a
> small change to the existing uImage support.
> 
> Now admittedly I did say I didn't find any traces of zImage support, which
> isn't what I'm saying here; I guess I forgot about the stuff I did find
> soon after I chose the path of modifying the uImage formats.
> 

FYI, this exact topic has been discussed on the Linaro weekly
boot-architecture call and list. The discussion has been more general in
terms of what can be done to make installing and updating kernels
easier/work for distros.

https://wiki.linaro.org/OfficeofCTO/BootArchitecture

Rob
