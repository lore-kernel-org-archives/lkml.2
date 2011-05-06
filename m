Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab1EFPou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 11:44:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab1EFPos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 11:44:48 -0400
Date: Fri, 6 May 2011 16:44:44 +0100
From: Mel Gorman <mgorman@suse.de>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mel Gorman <mgorman@novell.com>, Jan Kara <jack@suse.cz>,
        colin.king@canonical.com, Chris Mason <chris.mason@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback related.
Message-ID: <20110506154444.GG6591@suse.de>
References: <20110428171826.GZ4658@suse.de>
 <1304015436.2598.19.camel@mulgrave.site>
 <20110428192104.GA4658@suse.de>
 <1304020767.2598.21.camel@mulgrave.site>
 <1304025145.2598.24.camel@mulgrave.site>
 <1304030629.2598.42.camel@mulgrave.site>
 <20110503091320.GA4542@novell.com>
 <1304431982.2576.5.camel@mulgrave.site>
 <1304432553.2576.10.camel@mulgrave.site>
 <20110506074224.GB6591@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110506074224.GB6591@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 08:42:24AM +0100, Mel Gorman wrote:
> 
> 1. High-order allocations? You machine is using i915 and RPC, something
>    neither of my test machine uses. i915 is potentially a source for
>    high-order allocations. I'm attaching a perl script. Please run it as
>    ./watch-highorder.pl --output /tmp/highorders.txt
>    while you are running tar. When kswapd is running for about 30
>    seconds, interrupt it with ctrl+c twice in quick succession and
>    post /tmp/highorders.txt
> 

Colin send me this information for his test case at least and I see

11932 instances order=1 normal gfp_flags=GFP_NOWARN|GFP_NORETRY|GFP_COMP|GFP_NOMEMALLOC
 => alloc_pages_current+0xa5/0x110 <ffffffff81149ef5>
 => new_slab+0x1f5/0x290 <ffffffff81153645>
 => __slab_alloc+0x262/0x390 <ffffffff81155192>
 => kmem_cache_alloc+0x115/0x120 <ffffffff81155ab5>
 => mempool_alloc_slab+0x15/0x20 <ffffffff8110e705>
 => mempool_alloc+0x59/0x140 <ffffffff8110ea49>
 => bio_alloc_bioset+0x3e/0xf0 <ffffffff811976ae>
 => bio_alloc+0x15/0x30 <ffffffff81197805>

Colin and James: Did you happen to switch from SLAB to SLUB between
2.6.37 and 2.6.38? My own tests were against SLAB which might be why I
didn't see the problem. Am restarting the tests with SLUB.

-- 
Mel Gorman
SUSE Labs
