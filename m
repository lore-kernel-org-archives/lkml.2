Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab2IQUn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:43:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab2IQUn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:43:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] mfd: Fix compile for twl-core.c by removing cpu_is_omap usage
Date: Mon, 17 Sep 2012 20:43:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Olof Johansson <olof@lixom.net>, Felipe Balbi <balbi@ti.com>
References: <20120917202943.GV4521@atomide.com>
In-Reply-To: <20120917202943.GV4521@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209172043.45461.arnd@arndb.de>
X-Provags-ID: V02:K0:28dKumlM6ubHSfSw7gzzUeEhDgLHNisWwOEVpg2o0L6
 ppRx4rbPw8DLR/+hgBsNvEzsgp7KdJBVaS8TlVp51Gf/FUEouj
 9DQARbI5XDgMaL9E0uJnZBg+/WuTPLhbtt+erUlFaLD1LOppYX
 V7UYOKnxroBMlasw72J7O6wRMIxSQv1sJ6dVFTOL2XefgqYw+7
 tR8QXWoiMhPziOrYvLviBjaZeCsDDjFJlvwGNOBrTCAP4R0FmF
 /8tAGChzfgrAam0pDui4TlZOWC5+/0azLAl536jccGvmtsOw+8
 iNM/YNXsaKMtAwomFe9OhQneXgCAOVFoP4Rg6wtrKku8lM+LLi
 oJjQLcqhl5S5z/yMthbI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2012, Tony Lindgren wrote:
> Commit 7d7e1eba (ARM: OMAP2+: Prepare for irqs.h removal) broke
> compile for non-omap as include plat/cpu.h was added:
> 
> drivers/mfd/twl-core.c:49:22: fatal error: plat/cpu.h: No such file or directory
> 
> This header was indirectly included earlier when SPARSE_IRQ was not
> set, but does not exist on most platforms.
> 
> Fix the problem by removing the cpu_is_omap usage that should
> not exist in drivers at all. We can do this by adding proper
> clock aliases for the twl-core.c drivers, and drop separate
> handling for cases when clock framework is not available as
> the behaviour will stay the same.
> 
> Note that we need to add a platform device to avoid using the
> i2c provided names that may be different on various omaps.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Signed-off-by: Tony Lindgren <tony@atomide.com>


Acked-by: Arnd Bergmann <arnd@arndb.de>
