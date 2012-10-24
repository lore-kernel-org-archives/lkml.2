Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab2JXMFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:05:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57880 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab2JXMFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:05:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH v3 3/5] zynq: remove use of CLKDEV_LOOKUP
Date: Wed, 24 Oct 2012 12:05:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, John Linn <john.linn@xilinx.com>,
        Nick Bowler <nbowler@elliptictech.com>
References: <20121024003442.GD31625@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121024003442.GD31625@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210241205.34557.arnd@arndb.de>
X-Provags-ID: V02:K0:f1Su12690Ai2LvN+0MHE16nf2XInmNAKSbgTy6RWRG/
 xu9bwI5gswXPBfBwlkzCw16lyFECpwKRdhjlMw3C84qzhpK62q
 uQrL/nlCQ8UMei8bbCBHG2NZ8Gs1QeX2YXUn0pwU5/KC3cdk1v
 fIyH+bqcoFRsRdP9Car4kNVXzXQ7taeazMxQupOdgvkYMvhZLs
 v97Iu4CpiB50jolIscLdnE5n47dRCCMhMqKvOJvHaEze/Ox+0B
 f1fSwq/KQi0vmp7Cc1F37uNG8sY5HGOUZc3QueT2CV1jdSyKUR
 v3P0hugzq9zrOMLqtdmfSJR8O1FVL7iG1qld+AQrA8s4SIxM6A
 Rg/MLSsBQCD3lmoMpPO4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2012, Josh Cartwright wrote:
> The Zynq support in mainline does not (yet) make use of any of the
> generic clk or clk lookup functionality.  Remove what is upstream for
> now, until the out-of-tree implementation is in suitable form for
> merging.
> 
> An important side effect of this patch is that it allows the building of
> a Zynq kernel without running into unresolved symbol problems:
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
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Cc: John Linn <john.linn@xilinx.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

I think I forgot to mention in the previous review round that it would be nice
to just enable CONFIG_COMMON_CLK right away. Not important though.

	Arnd
