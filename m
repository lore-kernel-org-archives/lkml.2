Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1K1SWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 13:22:22 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55110 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1K1SWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 13:22:18 -0500
Date: Mon, 28 Nov 2011 10:22:06 -0800
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        ralf@linux-mips.org, schwidefsky@de.ibm.com, liqin.chen@sunplusct.com,
        lethal@linux-sh.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [GIT PULL tip/x86/memblock] updated x86/memblock branch
Message-ID: <20111128182206.GF18864@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo, hpa,

For some reason (probably the korg issue played a role), x86/memblock
got dropped from tip and missed the merge window and I didn't notice
it either until benh poke me about testing pending patches (thanks a
lot).  I resurrected the branch and there are some conflicts as
expected but nothing major.

I pulled in the current linux/master 401d0069cb "Merge branch
'fbdev-for-linus' of git://github.com/schandinat/linux-2.6" into
x86/memblock and resolve all the conflicts.  List of conflicts and
resolutions follow (also included in the commit message).

    * arch/x86/xen/setup.c

	dc91c728fd "xen: allow extra memory to be in multiple regions"
	24aa07882b "memblock, x86: Replace memblock_x86_reserve/free..."
    
        conflicted on xen_add_extra_mem() updates.  The resolution is
        trivial as the latter just want to replace
        memblock_x86_reserve_range() with memblock_reserve().

    * drivers/pci/intel-iommu.c

        166e9278a3f "x86/ia64: intel-iommu: move to drivers/iommu/"
        5dfe8660a3d "bootmem: Replace work_with_active_regions() with..."

        conflicted as the former moved the file under drivers/iommu/.
        Resolved by applying the chnages from the latter on the moved
        file.

    * mm/Kconfig

        6661672053a "memblock: add NO_BOOTMEM config symbol"
        c378ddd53f9 "memblock, x86: Make ARCH_DISCARD_MEMBLOCK a config option"

        conflicted trivially.  Both added config options.  Just
        letting both add their own options resolves the conflict.

    * mm/memblock.c

        d1f0ece6cdc "mm/memblock.c: small function definition fixes"
        ed7b56a799c "memblock: Remove memblock_memory_can_coalesce()"

        confliected.  The former updates function removed by the
        latter.  Resolution is trivial.

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-memblock

to receive the merged branch.  I'll soon post the pending patches on
top of the merged branch.

Thank you.

-- 
tejun
