Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2AIJlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:41:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54334 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2AIJll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:41:41 -0500
Date: Mon, 9 Jan 2012 09:41:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Marc Zyngier'" <marc.zyngier@arm.com>,
        "'Axel Lin'" <axel.lin@gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: Fix build error which was from common.c
	and old cpu.c
Message-ID: <20120109094115.GF21765@n2100.arm.linux.org.uk>
References: <01a001ccce6d$d9f3ea60$8ddbbf20$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01a001ccce6d$d9f3ea60$8ddbbf20$%kim@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 10:27:27AM +0900, Kukjin Kim wrote:
> This fixes build error and wrong merge conflicts.
> arch/arm/mach-exynos/common.c: In function 'exynos4_gic_irq_fix_base':
> arch/arm/mach-exynos/common.c:393: error: dereferencing pointer to incomplete type
> arch/arm/mach-exynos/common.c:396: error: dereferencing pointer to incomplete type
> 
> Following A and B have been created from different base and the build
> error was casued in the process of merging and should be fixed in this
> merge window.
> 
> A. commit db0d4db ("ARM: gic: allow GIC to support non-banked setups"),
>   commit 4e44d2c ("ARM: exynos4: convert to CONFIG_MULTI_IRQ_HANDLER")
>   and commit 69676c3 ("ARM: exynos4: Fix build error due to
>   'gic_bank_offset' undeclared")
> 
> B. commit cc511b8 ("ARM: 7257/1: EXYNOS: introduce arch/arm/mach-exynos/
>   common.[ch]") introduced common.[ch]")

Well, git isn't that good at telling you what conflicts on a delete/modify
conflict - all it does is leave you the modified file in the tree and
expect you to know what changes were made to it between the version which
was deleted, and the modified version.

The various git diff combinations really don't help you either - all you
get told by git is that the file is 'unmerged' and that's it.

I'd say these are the kind of merges which are always going to be full of
errors - and I doubt there's anything which can really be done to stop
them being so (unless git starts marking the file with merge conflict
markers for those changes I describe above.)
