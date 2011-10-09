Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab1JIGVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 02:21:39 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50493 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1JIGVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 02:21:36 -0400
MIME-Version: 1.0
In-Reply-To: <1499585.ED4ktnBDpX@wuerfel>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
	<CAMPhdO_L-g4vSj3fC-1ckqnHGAPhWOy6Hm4VL5iUbZbbdjRkNQ@mail.gmail.com>
	<CAN1soZy3_9Trycti8SCbnO75N6NE31tFqrKMpZtiJPgwNc2cbg@mail.gmail.com>
	<1499585.ED4ktnBDpX@wuerfel>
Date: Sun, 9 Oct 2011 14:21:35 +0800
Message-ID: <CAN1soZyDu43EN3W5YBttdzx7qx=MLKAR1OsJC3hUdqWWxhQaew@mail.gmail.com>
Subject: Re: [PATCH 17/26] ARM: pxa: pxa95x is incompatible with earlier pxa
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Jason Chagas <jason.chagas@marvell.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 8, 2011 at 9:24 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 08 October 2011 11:32:14 Haojian Zhuang wrote:
>>
>> Eric,
>>
>> At first, a new macro (ARCH_PXA_V7) is defined in
>> arch/arm/mach-pxa/Kconfig in this patch.
>> I prefer to move this macro to arch/arm/Kconfig.
>
> If we move it to arch/arm/Kconfig, I would prefer making it a global option,
> not a pxa specific one. If we introduce a top-level CONFIG_CPU_V6PLUS
> option, we can make a number of decisions inside of Kconfig depend on that,
> especially as we move to allow building multiple v6/v7 platforms together,
> or multiple v5 platforms for that matter. I believe we don't need to
> worry about v5+v7 at this point and can instead assume that won't ever
> happen.
>
Nobody is using PJ4 as v6 architecture now. CPUv6 is used in old stepping
of Dove and MMP2. CPU_PJ4 only enables CPU_v7 in the mainline code.

If we used ARCH_PXA_V7 in arch/arm/Kconfig, we would have two ARCH for
pxa. One is ARCH_PXA, and the other is ARCH_PXA_V7. Those v5 machine
should be based on ARCH_PXA. And the saarb, tavorevb3 should be based
on ARCH_PXA_V7. So we can avoid to define PXA_V7_MACH_AUTO. I think
the logic of Kconfig could be easier.

>> Secondly, pxa95x is both used in saarb and tavorevb3.
>
> The patch makes that very explicit, doesn't it?
>
+config PXA_V7_MACH_AUTO
+       def_bool y
+       depends on ARCH_PXA_V7
+       depends on !MACH_SAARB
+       select MACH_TAVOREVB3
+

Please check this. In your patch, SAARB and TAVOREVB3 is a mutex.

>> Thirdly, PXA_V7_MACH_AUTO is unnecessary. We just need to select those
>> machines in defconfig or define a new DT machine type to select all
>> machines.
>
> Enabling them in defconfig will not help here, it still allows creating
> an invalid configuration by disabling both saarb and tavorevb3.
> I agree that it would be best to have a single DT machine type that can
> handle both saarb and tavorevb3 as well as any future pxa95x based machines,
> but nobody has implemented that yet. In the meantime, I think we should
> have the PXA_V7_MACH_AUTO or an equivalent mechanism to enforce that at
> least one of the two board files gets built into any kernel. This is mostly
> important to help the 'make randconfig' builds succeed, not for actual
> users getting it wrong accidentally.
>
>        Arnd
>

Exactly we need to define a single DT machine type in both arch-pxa
and arch-mmp.
I'll register it first.

Thanks
Haojian
