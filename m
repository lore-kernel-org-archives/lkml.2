Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2IQWIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:08:43 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:52559 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab2IQWIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:08:41 -0400
Date: Mon, 17 Sep 2012 22:08:40 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] mfd: Fix compile for twl-core.c by removing cpu_is_omap
 usage
In-Reply-To: <20120917202943.GV4521@atomide.com>
Message-ID: <alpine.DEB.2.00.1209172207480.16117@utopia.booyaka.com>
References: <20120917202943.GV4521@atomide.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012, Tony Lindgren wrote:

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
> 
> ---
> 
> Samuel, I'd like to queue this via arm-soc as that's where I have
> the breaking patch is if this patch is OK with you.

It would be ideal if I could queue this one, due to the clock dependency.  
Still hoping that we can get the CCF conversion patches in for 3.7.


- Paul
