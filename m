Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab1JILcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 07:32:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50153 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab1JILcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 07:32:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH 17/26] ARM: pxa: pxa95x is incompatible with earlier pxa
Date: Sun, 09 Oct 2011 13:31:52 +0200
Message-ID: <1361960.V5WIS69XTX@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <CAMPhdO8_cZU8FEGsK0m_XrhbR33TiZFFaNrXddKT1YrHREt-TQ@mail.gmail.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <CAN1soZyDu43EN3W5YBttdzx7qx=MLKAR1OsJC3hUdqWWxhQaew@mail.gmail.com> <CAMPhdO8_cZU8FEGsK0m_XrhbR33TiZFFaNrXddKT1YrHREt-TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Q0Y9He431uuP41q+AZXFha4S8cB6ffpuYvPAdZjm9hf
 /59priZ74CfrykwIg7EMQCidwKvOu1+hPcnKaxmb34EydYZUal
 Ksj0xjQPx1JFsvev/nDNPtT/BWD9ye1mey6Jv0wds58v/prRup
 l+TZwkZNPDehKxFqzXP/3MPUgnc1qPI/Mw5w99rBPy9Julle76
 i/HvDh4NsR7sdT4oYfeBzeJGQId+svPqsHMG/6YXrBjVctoHGP
 JRDWMKiVU49V2FtUu2NBt4AernzATy3XG151Pg7K/g/YB+hBUU
 bGvf8bNJIqPDXUHQySJwfop9BDqF+whdMefsVzeeJ09H3OiDvu
 K5cTqTaQIlPEBL2YUypw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 October 2011 14:36:52 Eric Miao wrote:
> 
> They are actually not mutually exclusive - it's a trick we use to select
> MACH_TAVOREVB3 by default but this option also disappears once SAARB
> is selected.

Right. It's a bit hard to read when there are only two of them, but that
is the idea.

> The 'depends on ARCH_PXA_V7' could actually be removed here, as the
> option is already encapsulated in if ARCH_PXA_V7 ... endif. And this
> trick won't work very well when there are more than 2 boards.

Actually, the option is outside of the if ARCH_PXA_V7, but that could
easily be changed.

The trick works with as many boards as you like, it just gets a
little clumsy after while, as in

config MACH_OMAP_AUTO_BOARD
        def_bool y
        depends on !MACH_OMAP2_TUSB6010
        depends on !MACH_OMAP_H4
        depends on !MACH_OMAP_APOLLON
        depends on !MACH_OMAP_APOLLON
        depends on !MACH_OMAP_2430SDP
        depends on !MACH_OMAP3_BEAGLE
        depends on !MACH_DEVKIT8000
        depends on !MACH_OMAP_LDP
        depends on !MACH_OMAP3530_LV_SOM
        depends on !MACH_OMAP3_TORPEDO
        depends on !MACH_OVERO
        depends on !MACH_OMAP3EVM
        depends on !MACH_OMAP3517EVM
        depends on !MACH_CRANEBOARD
        depends on !MACH_OMAP3_PANDORA
        depends on !MACH_OMAP3_TOUCHBOOK
        depends on !MACH_NOKIA_N8X0
        depends on !MACH_NOKIA_RM680
        depends on !MACH_NOKIA_RX51
        depends on !MACH_OMAP_ZOOM2
        depends on !MACH_OMAP_ZOOM3
        depends on !MACH_CM_T35
        depends on !MACH_CM_T3517
        depends on !MACH_IGEP0020
        depends on !MACH_IGEP0030
        depends on !MACH_SBC3530
        depends on !MACH_OMAP_3630SDP
        depends on !MACH_TI8168EVM
        depends on !MACH_OMAP4_PANDA
        select MACH_OMAP_GENERIC if ARCH_OMAP2
        select MACH_OMAP_3430SDP if ARCH_OMAP3 && !ARCH_OMAP2
        select MACH_OMAP_4430SDP if ARCH_OMAP4 && !ARCH_OMAP3 && !ARCH_OMAP2
        help
          The kernel needs to have support for at least one board
          in order to build. If none is selected, default to the
          generic board.

We should probably do something like this for the ARMv5 based PXA boards,
but at least a randconfig won't trigger that normally, just because there
are so many of them that almost always at least one is enabled. However,
an allnoconfig will fail with PXA right now.

	Arnd
