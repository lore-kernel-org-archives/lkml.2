Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab2GGT1Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 15:27:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62418 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2GGT1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 15:27:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Date: Sat, 7 Jul 2012 19:27:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
In-Reply-To: <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207071927.13135.arnd@arndb.de>
X-Provags-ID: V02:K0:/eVOohxP/GM6ufB0msh95V8lA/K8+4Iy4Ad4awEpf6J
 qOzFkrdzd10YFgo9tVQ9Bpe1UlLYM9R8Pw6DwktuZ2N10XxEAg
 A77iJHDdYF6+fpYAjTTfWreX3ROa3cXgw3d6ASAuhkK8xI38Vz
 2pTSSL8aB70SLeLIjNnZ57cVLPa07eJokxLHnOkTq8d6QUpdgG
 mWvQgB2lRQx4A66B02tbAb9cLfyV3PxooFiQz+lingaPLMPdtv
 bmSZwpP8+MyHFxmrQpyh59Kgau1antQxnilmy8dyMmCp6aVeNB
 jU4iSkUZZ7l5R1qEtn+SlaEsIM6WV6N8cOV5DZjXKqncun4nl7
 eo/eLg+tD+XdmX7Mqqoc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 July 2012, Olof Johansson wrote:

> > ARM introduced AArch64 as part of the ARMv8 architecture
> 
> With the risk of bikeshedding here, but I find the name awkward. How
> about just naming the arch port arm64 instead? It's considerably more
> descriptive in the context of the kernel.  For reference, we didn't
> name ppc64, nor powerpc, after what the IBM/power.org marketing people
> were currently calling the architecture at the time either.

I agree the name sucks, and I'd much prefer to just call it arm64
as well. The main advantage of the aarch64 name is that it's the
same as the identifier in the elf triplet, and it makes sense to
keep the same name for all places where we need to identify the
architecture. This also includes the rpm and dpkg architecture names,
and the string returned by the uname syscall. If everything else
is aarch64, we should use that in the kernel directory too, but
if everyone calls it arm64 anyway, we should probably use that name
for as many things as possible.

> > There is no hardware platform available at this point. From a kernel
> > perspective, the aim is to minimise (or even completely remove) the
> > platform code from the architecture specific directory. FDT is currently
> > mandated and there are ongoing discussions for ACPI support.
> 
> This will be interesting to see how it plays out over time, and how
> many vendors will drop in arm64 cores on their existing designs and
> thus need to pull over infrastructure from arch/arm for their platform
> type. A lot of the drivers have moved out to common code so much of it
> should be possible to do cleanly, but there is still some risk for
> duplication.

For new platforms, the risk is very low, even if they want to support
the same peripherals in both 32 and 64 bit kernels, since almost all
of that can be in drivers/ already. The main missing bits are the
lack of a place to put irqchip drivers (I think there are already
patches to create drivers/irqchip/) and dma engines require platform
specific setup code because of the lack of DT bindings (also being
worked on).

I'm a little more worried about platforms that have an existing 32 bit
code base and have developers that want to reuse the existing code.
We have to make it very clear from the start that copying platform
code from arch/arm to arch/arm64 is not acceptable. Using Makefile
magic to redirect into the 32 bit platform directory would be a
possibility but I would really hope we can get everyone to do a clean
64 platform from the start, and hopefully move the 32 bit code over
to use the same drivers over time, and drastically shrink their
exisiting platform code.

> I guess it's a good chance to clean up some of it and start from a
> clean slate, if you can avoid the temptation of just moving over code.

Agreed. It's clear from the code that it started out as a copy of the
32 bit ARM code base, which I think was a mistake, but it has also
moved on since then and many areas of the 64 bit code are now much
cleaner because they don't have to worry about breaking legacy code.
We're also more flexible with trying out stuff without having to
worry about breaking some 10 year old board code.

	Arnd
