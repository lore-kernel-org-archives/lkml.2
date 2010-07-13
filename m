Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab0GMJsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:48:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35948 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab0GMJsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:48:01 -0400
Date: Tue, 13 Jul 2010 10:46:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, Yakui Zhao <yakui.zhao@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] Tight check of pfn_valid on sparsemem
Message-ID: <20100713094612.GF20590@n2100.arm.linux.org.uk>
References: <20100712155348.GA2815@barrios-desktop> <20100713093700.GD29885@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713093700.GD29885@csn.ul.ie>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 10:37:00AM +0100, Mel Gorman wrote:
> I prefer Kamezawa's suggestion of mapping on a ZERO_PAGE-like page full
> of PageReserved struct pages because it would have better performance
> and be more in line with maintaining the assumptions of the memory
> model. If we go in this direction, I would strongly prefer it was an
> ARM-only thing.

As I've said, this is not possible without doing some serious page
manipulation.

Plus the pages that where there become unusable as they don't correspond
with a PFN or obey phys_to_virt().  So there's absolutely no point to
this.

Now, why do we free the holes in the mem_map - because these holes can
be extremely large.  Every 512K of hole equates to one page of mem_map
array.  Balance that against memory placed at 0xc0000000 physical on
some platforms, and with PHYSMEM_BITS at 32 and SECTION_SIZE_BITS at
19 - well, you do the maths.  The result is certainly not pretty.
