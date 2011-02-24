Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1BXBym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 20:54:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab1BXByl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 20:54:41 -0500
Date: Thu, 24 Feb 2011 02:54:05 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Clemens Ladisch <cladisch@googlemail.com>, alsa-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd for
 GFP_ATOMIC order > 0
Message-ID: <20110224015405.GD31195@random.random>
References: <20110222134047.GT13092@random.random>
 <20110222161513.GC13092@random.random>
 <4D63F6C0.7060204@internode.on.net>
 <20110223162432.GL31195@random.random>
 <20110223165550.GP31195@random.random>
 <4D65691E.9080600@internode.on.net>
 <20110223212541.GV31195@random.random>
 <4D65825F.5080403@internode.on.net>
 <20110223235946.GW31195@random.random>
 <4D65B71D.5030109@internode.on.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D65B71D.5030109@internode.on.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arthur,

On Thu, Feb 24, 2011 at 12:10:45PM +1030, Arthur Marsh wrote:
> OK, with kswapd-high_wmark + compaction-kswapd-3 + Mel's patch (with the 
> compaction initialisation fix), MIDI playback is fine.
> kswapd0 CPU can very occasionally hit equal highest (17 percent was the 
> highest I noticed, but is generally below the top 4-5 processes and less 
> than 10 percent when working, dropping to around 0.3 percent when swap 
> activity has subsided). This was with loading KDE 3.5.10, konversation, 
> aptitude -u, icedove and iceweasel with several dozen tabs in addition 
> to aplaymidi.

That sounds good... so maybe we don't have to backout compaction out
of kswapd and the new kswapd+compaction logic is working fine without
overloading the system like the older logic did.

Ok so tomorrow I'll get all results on these 3 kernels (
compaction-kswapd-3+compaction_alloc_lowlat-2 vs
compaction-no-kswapd-3+compaction_alloc_lowlat-2 vs
compaction_alloc_lowlat2) on network server load, where throughout is
measured in addition to latency. Then we'll have a better picture to
decide. If throughput is decreased in any measurable way I still
prefer compaction-no-kswapd and to rethink at this later without
hurry. The network load with jumbo frames from e1000 is very good at
stressing compaction+kswapd so there should be no surprises if
throughput and latency are ok with the new compaction kswapd logic.

I suggest you to keep running with this combination
(compaction-kswapd-3 + Mel's patch with the initialization fix that I
sent you + kswapd-high_wmark) if you can, to be sure it works fine for
you.

Thanks a lot for now!
Andrea
