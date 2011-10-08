Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1JHNYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 09:24:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1JHNY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 09:24:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Jason Chagas <jason.chagas@marvell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/26] ARM: pxa: pxa95x is incompatible with earlier pxa
Date: Sat, 08 Oct 2011 15:24:04 +0200
Message-ID: <1499585.ED4ktnBDpX@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <CAN1soZy3_9Trycti8SCbnO75N6NE31tFqrKMpZtiJPgwNc2cbg@mail.gmail.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <CAMPhdO_L-g4vSj3fC-1ckqnHGAPhWOy6Hm4VL5iUbZbbdjRkNQ@mail.gmail.com> <CAN1soZy3_9Trycti8SCbnO75N6NE31tFqrKMpZtiJPgwNc2cbg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:CMoq2Ff990CfDqMikRtaqUVKj7GMhVuYlHDkk1ywHKK
 Mi1RsQM+mNIy0KeR+3i6aaHkSPmekw+p/j+SxD1KZ2xp+mkfov
 B6sfkD5mh3Hi1Z+56nWGBoh7QdtV0K5OLQS1dxbJ2MBFFwhvMT
 RZIZ8QJj8KguRrg10ttCeJmK0Xcl3mGP6El9TTsUaEYgvTnlMy
 O8+LQ6UQr13M05SEAHlL8bx1Z3WtUVXAoYedtWZ/IOCzdSxvoP
 i0k1CarKC7XHSbc2qO+YrDqyNc5ZtvAuH7eLocQx/Y2sE/2PMO
 p8bX1WRycJ6oTsYFBFDs37UhVfiRoJeR/HuVdP5WweN9n4s/W7
 BLquhaYFQ7QYzUkYeynI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 October 2011 11:32:14 Haojian Zhuang wrote:
> 
> Eric,
> 
> At first, a new macro (ARCH_PXA_V7) is defined in
> arch/arm/mach-pxa/Kconfig in this patch.
> I prefer to move this macro to arch/arm/Kconfig.

If we move it to arch/arm/Kconfig, I would prefer making it a global option,
not a pxa specific one. If we introduce a top-level CONFIG_CPU_V6PLUS
option, we can make a number of decisions inside of Kconfig depend on that,
especially as we move to allow building multiple v6/v7 platforms together,
or multiple v5 platforms for that matter. I believe we don't need to
worry about v5+v7 at this point and can instead assume that won't ever
happen.

> Secondly, pxa95x is both used in saarb and tavorevb3.

The patch makes that very explicit, doesn't it?

> Thirdly, PXA_V7_MACH_AUTO is unnecessary. We just need to select those
> machines in defconfig or define a new DT machine type to select all
> machines.

Enabling them in defconfig will not help here, it still allows creating
an invalid configuration by disabling both saarb and tavorevb3.
I agree that it would be best to have a single DT machine type that can
handle both saarb and tavorevb3 as well as any future pxa95x based machines,
but nobody has implemented that yet. In the meantime, I think we should
have the PXA_V7_MACH_AUTO or an equivalent mechanism to enforce that at
least one of the two board files gets built into any kernel. This is mostly
important to help the 'make randconfig' builds succeed, not for actual
users getting it wrong accidentally.

	Arnd
