Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab2IQW7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:59:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:21690 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab2IQW7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:59:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,439,1344236400"; 
   d="scan'208";a="146096754"
Date: Tue, 18 Sep 2012 00:59:30 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] mfd: Fix compile for twl-core.c by removing cpu_is_omap
 usage
Message-ID: <20120917225930.GV3647@sortiz-mobl>
References: <20120917202943.GV4521@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917202943.GV4521@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Mon, Sep 17, 2012 at 01:29:44PM -0700, Tony Lindgren wrote:
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
That's fine with me:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
