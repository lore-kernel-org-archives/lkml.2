Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab0LBRlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 12:41:42 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:33870 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752662Ab0LBRll convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 12:41:41 -0500
MIME-Version: 1.0
In-Reply-To: <20101003202920K.fujita.tomonori@lab.ntt.co.jp>
References: <20101001163958.GA22533@n2100.arm.linux.org.uk>
	<20101003195758B.fujita.tomonori@lab.ntt.co.jp>
	<20101003112839.GA32736@n2100.arm.linux.org.uk>
	<20101003202920K.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 2 Dec 2010 11:41:39 -0600
Message-ID: <AANLkTikES5y=hJhuE=iX-WJvcUvbpSqjDPBr2W8jGeJL@mail.gmail.com>
Subject: Re: [PATCH] scatterlist: define SG chain for arm architecture
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        Hiroshi.DOYU@nokia.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>, Bhavin Shah <bshah@ti.com>,
        Vijay Pasam <vpasam@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 3, 2010 at 6:34 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Sun, 3 Oct 2010 12:28:39 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>
>> On Sun, Oct 03, 2010 at 08:02:52PM +0900, FUJITA Tomonori wrote:
>> > On Fri, 1 Oct 2010 17:39:58 +0100
>> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>> >
>> > > On Fri, Oct 01, 2010 at 11:28:41AM -0500, Fernando Guzman Lugo
> wrote:
>> > > > Define SG chain for ARM architecture in order to work
>> > > > with big buffers. This patch is needed in order to
>> > > > iovmm users can pass a big buffer to map it and ARM
>> > > > architecture has not issues using SG chain.
>> > > >
>> > > > This change was suggested by FUJITA Tomonori.
>> > >
>> > > Have you audited all places where SG lists are used in the ARM
>> > > architecture to ensure that SG chain support is safe?  (That
>> > > goes for ARM generic code and ARM specific drivers.)
>> >
>> > As far as I know, only SCSI actually uses SG chain feature (that is,
>> > sending chained scatter lists). All SCSI drivers were converted when
>> > we added SG chain feature. So what you need to care about is the dma
>> > code.
>> >
>> > There are only several files that actually use scatter list under
>> > arch/arm.
>> >
>> > >From a quick look, arch/arm/mm/dma-mapping.c,
>> > arch/arm/common/dmabounce.c, arch/arm/kernel/dma.c, and
>> > arch/arm/include/asm/dma-mapping.h looks fine.
>> >
>> > arm/mach-imx/dma-v1.c also looks like to use chained sg API properly
>> > (but this isn't used with SCSI, right?).
>> >
>> > Seems that arch/arm/plat-omap/iovmm.c can handle the chained SG
>> > too. It doesn't allocate the chained SG now though.
>>
>> There's also RiscPC and its SCSI drivers could well be an issue for SG
>> chaining.  They have to manually save the SCSI 'data pointer' (down to
>> the byte position in the SG chain and be able to restore a previously
>> saved point.)  This code was written before SG chaining ever appeared,
>> and although it has been partly fixed up, it's probably buggy if SG
>> chaining were to be enabled.
>
> What SCSI drviers we need to fix?

Russell,

Any update with this? I hope it can be merged for 2.6.38.

>
>
>> If it's just OMAP users who wish to enable SG chaining, then the sane
>> thing to do would be to make the definition of the macro conditional
>> on OMAP.
>
> Yeah, that should work.

some like this in scatterlist.h is ok?

#ifdef CONFIG_ARCH_OMAP
#define ARCH_HAS_SG_CHAIN
#endif


Regards,
Fernando.
>
