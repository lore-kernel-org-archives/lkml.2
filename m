Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab1JILft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 07:35:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65476 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab1JILfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 07:35:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Jason Chagas <jason.chagas@marvell.com>, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH 17/26] ARM: pxa: pxa95x is incompatible with earlier pxa
Date: Sun, 09 Oct 2011 13:35:31 +0200
Message-ID: <5678343.s7jMIvu0rV@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <CAN1soZyDu43EN3W5YBttdzx7qx=MLKAR1OsJC3hUdqWWxhQaew@mail.gmail.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1499585.ED4ktnBDpX@wuerfel> <CAN1soZyDu43EN3W5YBttdzx7qx=MLKAR1OsJC3hUdqWWxhQaew@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:pXn+aB5ofW8AlXibSsGiWA0j7FZ8W1EhLeBawlC4pvi
 njFklbhkFvInH40WefzIoR67+wYkIAbfzgsHnyfJ9EKrCDX9/i
 ya427FUR1jJwhNDTryUP+dsXcBsfKfgde3tilgJdN7m6wVy3Oh
 QspUHMXaRSKmZbMP7VT7f/dXDj354zIhWXZxg22XOEs/zMsNGr
 0NsHJ5IS/DN0PGeNmEWBH63n5d+Mfvd77MUpRTJh1c5nnWlJga
 kNSo9GkagphIe60w7/s7I31GtpB3kiCwR3NheE2EDasdSNpXRt
 PQjN7JmH4UOeCGsAiG7a8PPQplCinzUOslX6e31fFxEMiHALQY
 WOv5cwHUVxfT2m89dTaA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 October 2011 14:21:35 Haojian Zhuang wrote:
> > If we move it to arch/arm/Kconfig, I would prefer making it a global option,
> > not a pxa specific one. If we introduce a top-level CONFIG_CPU_V6PLUS
> > option, we can make a number of decisions inside of Kconfig depend on that,
> > especially as we move to allow building multiple v6/v7 platforms together,
> > or multiple v5 platforms for that matter. I believe we don't need to
> > worry about v5+v7 at this point and can instead assume that won't ever
> > happen.
> >
> Nobody is using PJ4 as v6 architecture now. CPUv6 is used in old stepping
> of Dove and MMP2. CPU_PJ4 only enables CPU_v7 in the mainline code.
> 
> If we used ARCH_PXA_V7 in arch/arm/Kconfig, we would have two ARCH for
> pxa. One is ARCH_PXA, and the other is ARCH_PXA_V7. Those v5 machine
> should be based on ARCH_PXA. And the saarb, tavorevb3 should be based
> on ARCH_PXA_V7. So we can avoid to define PXA_V7_MACH_AUTO. I think
> the logic of Kconfig could be easier.

I was referring to building different subarchitectures together.
We want to eventually be able to build a single kernel that
works on e.g. pxa95x (ARMv7) and omap2 (ARMv6), and we hope to get
there within the next few release. This is completely unrelated to
building a combination of old-world (ARMv3/v4/v5) and new-world
(ARMv6/v7) in a single kernel, which is something that we decided
not to try supporting in the forseeable future.

	Arnd
