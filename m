Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab0GMSkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:40:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47631 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab0GMSkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:40:20 -0400
Date: Tue, 13 Jul 2010 19:39:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, Yakui Zhao <yakui.zhao@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC] Tight check of pfn_valid on sparsemem
Message-ID: <20100713183932.GB31162@n2100.arm.linux.org.uk>
References: <20100712155348.GA2815@barrios-desktop> <20100713121947.612bd656.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTiny7dz8ssDknI7y4JFcVP9SV1aNM7f0YMUxafv7@mail.gmail.com> <20100713132312.a7dfb100.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTinVwmo5pemz86nXaQT3V_ujaPLOsyNeQIFhL0Vu@mail.gmail.com> <20100713072009.GA19839@n2100.arm.linux.org.uk> <20100713163417.17895202.kamezawa.hiroyu@jp.fujitsu.com> <20100713165808.e340e6dc.kamezawa.hiroyu@jp.fujitsu.com> <20100713170222.9369e649.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713170222.9369e649.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 05:02:22PM +0900, KAMEZAWA Hiroyuki wrote:
> How about stop using SPARSEMEM ? What's the benefit ? It just eats up
> memory for mem_section[].

The problem with that approach is that sometimes the mem_map array
doesn't fit into any memory banks.

We've gone around the loop of using flatmem with holes punched in it,
to using discontigmem, and now to using sparsemem.  It seems none of
these solutions does what we need for ARM.  I guess that's the price
we pay for not having memory architected to be at any particular place
in the physical memory map.

We're even seeing lately setups now where system memory is split into
two areas, where the second (higher physical address) is populated
first before the lower bank...  These kinds of games are getting rather
stupid and idiotic, but we're not the hardware designers and so we have
to live with it - or just tell the folk who are porting the kernel to
these platforms that we'll never take their patches.
