Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1BLKAA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 05:00:00 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55242 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1BLJ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 04:59:56 -0500
Date: Sat, 12 Feb 2011 09:59:43 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 03/19] ARM: LPAE: use long long format when printing
	physical addresses and ptes
Message-ID: <20110212095943.GB15616@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-4-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295891761-18366-4-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 05:55:45PM +0000, Catalin Marinas wrote:
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 5ea4fb7..3d23f0f 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -449,7 +449,7 @@ static int __init arm_add_memory(unsigned long start, unsigned long size)
>  
>  	if (meminfo.nr_banks >= NR_BANKS) {
>  		printk(KERN_CRIT "NR_BANKS too low, "
> -			"ignoring memory at %#lx\n", start);
> +			"ignoring memory at %#08llx\n", (long long)start);

This is not equivalent.  %#lx produces '0x0'.  %#08llx produces '0x000000'
not '0x00000000' - the '0x' is included in the field width.  So you want
'%#010llx' or '0x%08llx' - there's no real advantage to either.  Or just
convert '%#lx' to '%#llx'.
