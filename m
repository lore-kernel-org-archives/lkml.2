Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab2J2IBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:01:01 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:54322
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492Ab2J2IBA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:01:00 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 9
X-BigFish: VPS9(zz9371I542M1432I4015Izz1202h1d1ah1d2ahzz17326ah8275bhz30ih95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>,
        "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>
Subject: RE: [PATCH v4 3/5] zynq: remove use of CLKDEV_LOOKUP
Thread-Topic: [PATCH v4 3/5] zynq: remove use of CLKDEV_LOOKUP
Thread-Index: AQHNtWmqR0jy2nBNz0KZdE3HSTwJmpfP7ASQ
Date: Mon, 29 Oct 2012 08:00:29 +0000
References: <cover.1351466765.git.josh.cartwright@ni.com>
 <079dc4cc1d0abd19cef111045ba305c474eb0e4c.1351466765.git.josh.cartwright@ni.com>
In-Reply-To: <079dc4cc1d0abd19cef111045ba305c474eb0e4c.1351466765.git.josh.cartwright@ni.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.26.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <0d24b66c-f001-4b67-89c0-abd3cd06c03a@VA3EHSMHS004.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> Sent: Sunday, October 21, 2012 6:17 PM
> To: arm@kernel.org; Arnd Bergmann
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; John
> Linn; Nick Bowler; Michal Simek
> Subject: [PATCH v4 3/5] zynq: remove use of CLKDEV_LOOKUP
> 
> The Zynq support in mainline does not (yet) make use of any of the generic clk
> or clk lookup functionality.  Remove what is upstream for now, until the out-of-
> tree implementation is in suitable form for merging.
> 
> An important side effect of this patch is that it allows the building of a Zynq
> kernel without running into unresolved symbol problems:
> 
>    drivers/built-in.o: In function `amba_get_enable_pclk':
>    clkdev.c:(.text+0x444): undefined reference to `clk_enable'
>    drivers/built-in.o: In function `amba_remove':
>    clkdev.c:(.text+0x488): undefined reference to `clk_disable'
>    drivers/built-in.o: In function `amba_probe':
>    clkdev.c:(.text+0x540): undefined reference to `clk_disable'
>    drivers/built-in.o: In function `amba_device_add':
>    clkdev.c:(.text+0x77c): undefined reference to `clk_disable'
>    drivers/built-in.o: In function `enable_clock':
>    clkdev.c:(.text+0x29738): undefined reference to `clk_enable'
>    drivers/built-in.o: In function `disable_clock':
>    clkdev.c:(.text+0x29778): undefined reference to `clk_disable'
>    drivers/built-in.o: In function `__pm_clk_remove':
>    clkdev.c:(.text+0x297f8): undefined reference to `clk_disable'
>    drivers/built-in.o: In function `pm_clk_suspend':
>    clkdev.c:(.text+0x29bc8): undefined reference to `clk_disable'
>    drivers/built-in.o: In function `pm_clk_resume':
>    clkdev.c:(.text+0x29c28): undefined reference to `clk_enable'
>    make[2]: *** [vmlinux] Error 1
>    make[1]: *** [sub-make] Error 2
>    make: *** [all] Error 2
> 
> In addition, eliminate Zynq's "use" of the versatile platform, as it is no longer
> needed.  As Nick Bowler points out:
> 
> 	For the record, I think this was introduced by commit 56a34b03ff427
> 	("ARM: versatile: Make plat-versatile clock optional") which forgot to
> 	select PLAT_VERSATILE_CLOCK on Zynq.  This is not all that surprising,
> 	because the fact that Zynq "uses" PLAT_VERSATILE is secretly hidden in
> 	the Makefile.
> 
> 	Nevertheless, the only feature from versatile that Zynq needed was the
> 	clock support, so this patch should *also* delete the secret use of
> 	plat-versatile by removing this line from arch/arm/Makefile:
> 
> 	  plat-$(CONFIG_ARCH_ZYNQ)      += versatile
> 
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Cc: John Linn <john.linn@xilinx.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Tested-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  arch/arm/Kconfig                         |  1 -
>  arch/arm/Makefile                        |  1 -
>  arch/arm/mach-zynq/common.c              |  1 -
>  arch/arm/mach-zynq/include/mach/clkdev.h | 32 --------------------------------
>  4 files changed, 35 deletions(-)
>  delete mode 100644 arch/arm/mach-zynq/include/mach/clkdev.h
> 

Applied to http://git.xilinx.com/?p=linux-xlnx.git;a=shortlog;h=refs/heads/arm-next

Thanks,
Michal


