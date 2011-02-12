Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1BLK2e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 05:28:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34823 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1BLK23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 05:28:29 -0500
Date: Sat, 12 Feb 2011 10:28:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 15/19] ARM: LPAE: use phys_addr_t instead of
	unsigned long for physical addresses
Message-ID: <20110212102803.GC15616@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-16-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295891761-18366-16-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 05:55:57PM +0000, Catalin Marinas wrote:
>  arch/arm/include/asm/memory.h     |   17 +++++++++--------
>  arch/arm/include/asm/outercache.h |   14 ++++++++------
>  arch/arm/include/asm/pgtable.h    |    2 +-
>  arch/arm/include/asm/setup.h      |    2 +-
>  arch/arm/kernel/setup.c           |    5 +++--
>  arch/arm/mm/init.c                |    6 +++---
>  arch/arm/mm/mmu.c                 |    7 ++++---
>  7 files changed, 29 insertions(+), 24 deletions(-)

If this is split up into four separate patches, we can probably sort out
merging this for the upcoming window.

asm/memory.h will conflict non-trivially with p2v patch set, but I think
we can merge the changes to everything but __virt_to_phys/__phys_to_virt.

asm/outercache.h changes are stand-alone.

asm/pgtable.h looks like it could use __pfn_to_phys(pfn) rather than
adding the cast, and can be combined with mm/init.c and mm/mmu.c.

asm/setup.h and arch/arm/kernel/setup.c form another logical group.
