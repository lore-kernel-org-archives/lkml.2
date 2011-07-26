Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1GZVOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 17:14:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43832 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab1GZVO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 17:14:29 -0400
MIME-Version: 1.0
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
Date: Tue, 26 Jul 2011 14:14:28 -0700
Message-ID: <CAE9FiQX0i2UwO9fSntwSEMUWiO6KdzbQth8Bf+_9OnKXntasKQ@mail.gmail.com>
Subject: Re: [PATCHSET tip:x86/memblock] memblock: Kill early_node_map[]
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: benh@kernel.crashing.org, tony.luck@intel.com, ralf@linux-mips.org,
        schwidefsky@de.ibm.com, liqin.chen@sunplusct.com, lethal@linux-sh.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 8:35 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> This patchset builds on the previous "memblock, x86: Allow node info
> in memblock and remove x86 specific memblock code" patchset, which now
> is in tip:x86/memblock.  This patchset updates memblock so that it's
> easier to use, converts all archs which use early_node_map[] to use
> memblock instead, and kills early_node_map[].
>
> Bootmem allocator is still looming there but this ensures a unified
> way forward where memblock is the universal early memory management
> mechanism.  This cleans up the entanglement between memblock and
> early_node_map[] in the backend but API visible to archs is still a
> bit confusing and can use some cleanup and documentation once things
> settle down a bit.
>
> x86, powerpc and sparc are boot tested in several different
> configurations.  On x86 allmod/noconfigs are compile tested.  On all
> other archs except for score, defconfig + some variations are compile
> tested.
>
> This does touch a lot of archs but except for x86 and powerpc the
> changes are mostly trivial and as bulk of the changes involve updates
> to generic memblock code, it would be great if these can be routed
> through single tree (tip:x86/memblock).
>
> David, Ben, Paul, patches 0015-0017 are identical sans some offsets to
> the previously posted versions.
>
>  0001-memblock-Make-memblock_overlaps_region-static.patch
>  0002-memblock-Make-memblock_-add-remove-free-reserve-retu.patch
>  0003-memblock-Use-memblock_reserve-in-memblock-internal-f.patch
>  0004-memblock-Add-__memblock_dump_all.patch
>  0005-memblock-Kill-sentinel-entries-at-the-end-of-static-.patch
>  0006-memblock-Kill-memblock_init.patch
>  0007-memblock-Separate-out-memblock_isolate_range-from-me.patch
>  0008-memblock-Reimplement-__memblock_remove-using-membloc.patch
>  0009-memblock-Make-memblock-functions-handle-overflowing-.patch
>  0010-memblock-Reimplement-memblock_enforce_memory_limit-u.patch
>  0011-powerpc-Cleanup-memblock-usage.patch
>  0012-memblock-Track-total-size-of-regions-automatically.patch
>  0013-memblock-s-memblock_analyze-memblock_allow_resize-an.patch
>  0014-memblock-Implement-memblock_add_node.patch
>  0015-powerpc-Use-HAVE_MEMBLOCK_NODE_MAP.patch
>  0016-sparc-Use-HAVE_MEMBLOCK_NODE_MAP.patch
>  0017-SuperH-Use-HAVE_MEMBLOCK_NODE_MAP.patch
>  0018-ia64-Use-HAVE_MEMBLOCK_NODE_MAP.patch
>  0019-mips-Use-HAVE_MEMBLOCK_NODE_MAP.patch
>  0020-s390-Use-HAVE_MEMBLOCK_NODE_MAP.patch
>  0021-score-Use-HAVE_MEMBLOCK_NODE_MAP.patch
>  0022-memblock-Kill-early_node_map.patch
>  0023-memblock-Reimplement-memblock-allocation-using-rever.patch
>
> 0001-0014 clean up and improve generic memblock code (powerpc update
> is to allow updates to generic code) so that it's easier for archs.
> e.g. memblock_init/analyze() are no longer necessary.
>
> 0015-0017 convert archs which were using memblock + early_node_map[]
> to use MEMBLOCK_HAVE_NODE_MAP.
>
> 0018-0021 convert archs which were using only early_node_map[] to
> MEMBLOCK_HAVE_NODE_MAP.
>
> 0022 kills now unused early_node_map[].
>
> 0023 reimplements memblock allocator in sane way, which is possible
> with early_node_map[] gone.
>
> This patchset is available in the following git branch.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git memblock
>

it passes test with my x86 64bits setups.

looks like tip/master does not include tip/x86/memblock and tip/x86/mm yet.

So tip/x86/memblock, tip/x86/mm will not get into 3.1?
