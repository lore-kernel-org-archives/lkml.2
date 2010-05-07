Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab0EGLnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 07:43:53 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43292 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab0EGLnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 07:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VV/ur7gz5FreXYKjiS4EGPdl5vnf5JcX2k8MGtojBstVSMtnG4HUcaP2YVgZgSv5x0
         KvVxvNwiPFnSOKFrCZfdb8L+CuKCGHEWm0Ef1SEsLuI86BKyZaQLUrGP4GQcwI96V3yS
         a1WeFqbz3TlxoH20WBj+Hn3AP019y+Asc9EOw=
MIME-Version: 1.0
In-Reply-To: <20100507093256.GB19936@n2100.arm.linux.org.uk>
References: <1272848060-28049-1-git-send-email-linus.walleij@stericsson.com>
	 <i2t63386a3d1005070213u2ad32613w694be1ecbeb46856@mail.gmail.com>
	 <20100507093256.GB19936@n2100.arm.linux.org.uk>
Date: Fri, 7 May 2010 13:43:49 +0200
Message-ID: <x2j63386a3d1005070443yfadbaf3ct8686a8f7aae6412f@mail.gmail.com>
Subject: Re: [PATCH 0/7] DMAENGINE: fixes and PrimeCells
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
       linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/7 Russell King - ARM Linux <linux@arm.linux.org.uk>:

> I would have thought given the concerns that I stated, merely running
> the drivers in PIO mode would not address those concerns.  So no, I'm
> not satisfied.

Sorry didn't get it, I understood it as it should be tested on the Versatile
without regressions.

So now I understand that you want the drivers to be tested in DMA mode
on the ARM reference HW. Right?

So in order for this to be accepted, I also have to implement
support for the DMA controller found in the reference platforms from
ARM, PL080 and PL081, since there is only this S3C-tilted driver
in the kernel so far:
arch/arm/mach-s3c64xx/dma.c

This is hard for me to do since I have to try to lend a device to
test it on.

Anyway, I will see if I can lend the RealView machine again and
play around a bit with patching up Bens driver to work with the
DMAengine and show that it runs, in DMA mode, on the RealView,
as a proof of concept. Would that be OK then?

> As I've said, I don't want the ARM platforms to be boxed into a corner
> such that they can never have DMA support because this stuff hasn't been
> properly thought out.

I'm thinking all I can, I promise. Perhaps I'm not smart enough all the
time, it's a known problem, I'm working on it.

> Or let me put it another way - if people are happy for Linux to support
> new ARM CPU architectures, but with very little attention given to DMA
> support on those architectures, then feel free to box the ARM platforms
> into a corner on DMA support - but on the understanding that _you_ will
> have to deal with the DMA API breakage on those architectures yourself.
> Because with ARM platforms not having DMA support, there's absolutely
> no way to run any checks what so ever on DMA when the CPU architecture
> support is created.

I'm doing the best I can to meet exactly this goal. The changes done in
the DMA engine were done towards the end of making the DMA
engine support *any* DMA controller for the PrimeCells, and I've proven
it to be possible for two different architectures: U300 and U8500. These
are totally different even though they're coming out of the same
company (we *weren't* the same company when they were created!).
One is ARM9 the other is Cortex A9 dualcore. One use a DMA silicon
called COH901318 the other use a DMA silicon named DMA40.

So now I guess I have to make it tick on the block known as PL080/PL081
as well, and I'll have a try at it.

> This is why people like the OMAP folk end up doing a lot of the DMA
> debugging; they tend to be the first group to pick up new architectures
> with fully functional platforms.

Yep it seems we're going to have the same issue with Cortex A9 for
U8500.

Right now we're doing DMA debugging and testing on U300 and
U8500 to make sure neither break as a result of these patches,
and defining the API for the DMA engine.

Yours,
Linus Walleij
