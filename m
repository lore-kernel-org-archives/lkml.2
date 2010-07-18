Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab0GRONW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 10:13:22 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58708 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab0GRONU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 10:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nvG1QHPzCs2cKSPRvX2iRmkALZBVGAO84wHZCAxD5dbBrvHaK+HTXj4TvL2ZhXrvro
         gTlZ2mbmXpfi9/CYoEhM1mo+hJUifHWaSdjyjFKa9WCTFvQxMwZdhSArOpBGaAgWKRRO
         Kkpxtxsrn0M6uSA0JezSMYJB+D9e5FO0jqdHc=
Date: Sun, 18 Jul 2010 23:13:10 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v2
Message-ID: <20100718141240.GA30402@barrios-desktop>
References: <1279448311-29788-1-git-send-email-minchan.kim@gmail.com>
 <AANLkTilQf-43GMAIDa-MKmcB2afdVgkERMg0b5mhIbhE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilQf-43GMAIDa-MKmcB2afdVgkERMg0b5mhIbhE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyoungmin, 

On Sun, Jul 18, 2010 at 08:53:25PM +0900, Kyungmin Park wrote:
> Hi Minchan,
> 
> Please see the OneDRAM spec. it's OneDRAM memory usage.
> Actually memory size is 80MiB + 16MiB at AP side and it's used 80MiB
> for dedicated AP.
> The shared 16MiB used between AP and CP. So we also use the 16MiB.

It's not only s5pv210 but general problem of memmap hole 
on ARM's sparsemem. 

It doesn't matter with 16M or 80M. 
The thing is that section size is greater than physical memory's groups.

Current sparsemen aren't designed to have memmap hole but ARM makes holes
to save memory space. So we should solve it by not SECTION_SIZE but more 
fundamental solution.

I think this patch suggests it.
-- 
Kind regards,
Minchan Kim
