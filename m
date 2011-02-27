Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab1B0IsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 03:48:11 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:59160 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528Ab1B0IsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 03:48:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPqbaU120uZw/2dsb2JhbACmRXW6NoVhBJF4
Message-ID: <4D6A0FC0.1000307@internode.on.net>
Date: Sun, 27 Feb 2011 19:18:00 +1030
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-AU; rv:1.9.2.13) Gecko/20101213 Icedove/3.1.7
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Clemens Ladisch <cladisch@googlemail.com>, alsa-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified
 - 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd
 for GFP_ATOMIC order > 0
References: <20110222161513.GC13092@random.random> <4D63F6C0.7060204@internode.on.net> <20110223162432.GL31195@random.random> <20110223165550.GP31195@random.random> <4D65691E.9080600@internode.on.net> <20110223212541.GV31195@random.random> <4D65825F.5080403@internode.on.net> <20110223235946.GW31195@random.random> <4D65B71D.5030109@internode.on.net> <20110224015405.GD31195@random.random> <20110226064339.GC19630@random.random>
In-Reply-To: <20110226064339.GC19630@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrea Arcangeli wrote, on 26/02/11 17:13:
> On Thu, Feb 24, 2011 at 02:54:05AM +0100, Andrea Arcangeli wrote:
>> Ok so tomorrow I'll get all results on these 3 kernels (
>> compaction-kswapd-3+compaction_alloc_lowlat-2 vs
>> compaction-no-kswapd-3+compaction_alloc_lowlat-2 vs
>> compaction_alloc_lowlat2) on network server load, where throughout is
>> measured in addition to latency. Then we'll have a better picture to
>
> Latency is still lowest with compaction-no-kswapd-3. compaction_alloc
> still is at the top of the profiling with
> compaction-kswapd-3+compaction_alloc_lowlat-2. However
> compaction-kswapd-3 reduced the overhead somewhat but not enough to be
> as fast as with compaction-no-kswapd-3 (even if much better than
> before).
>
> So we should apply compaction-no-kswapd-3 to 2.6.38 I think.

I built a kernel based against git head of around 0800 UTC Saturday 
2011-02-26 plus compaction-no-kswapd-3 (Andrea's) and 
compaction_alloc_lowlat-2 (Mel's) patches.

The the latency performance for MIDI playback is excellent and kswap0 
has reported 100 seconds of CPU time in 22 hours of the kernel kernel 
running.

However, I am now battling against the kernel freeing up memory when 
using icedove/thunderbird. top is reporting 74 MiB resident, 418 MiB 
virtual, and as I pause typing to watch top output, free RAM has gone up 
to 50 MiB and I'm stuck waiting for parts of icedove to swap back in so 
that I can get a response from my input (either scrolling a message when 
reading it or composing a message, where I am left waiting for the text 
that I typed to appear).

Normally in this machine with only 384 MiB RAM and (say) 2.6.35-2.6.37 
kernels, free RAM will hover around the 5 MiB mark when lots of 
applications are open. I may wait when switching from one running 
application to another for it to respond, but once I am using that 
particular application it sufficiently responsive not to be annoying.

The aggressive reclamation of RAM by the kernel I built around 0800 UTC 
Saturday is working against the application currently in focus.

I will try Andrea's and Mel's patches built against 2.6.36-rc6 over the 
next several hours to see how that compares.

Arthur.
