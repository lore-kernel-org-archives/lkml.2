Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab1BXBkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 20:40:53 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:22196 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228Ab1BXBkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 20:40:52 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAM9EZU120uZw/2dsb2JhbACmHnS8FYVeBJFt
Message-ID: <4D65B71D.5030109@internode.on.net>
Date: Thu, 24 Feb 2011 12:10:45 +1030
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-AU; rv:1.9.2.13) Gecko/20101213 Icedove/3.1.7
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Clemens Ladisch <cladisch@googlemail.com>, alsa-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified
 - 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd
 for GFP_ATOMIC order > 0
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net> <4D6367B3.9050306@googlemail.com> <20110222134047.GT13092@random.random> <20110222161513.GC13092@random.random> <4D63F6C0.7060204@internode.on.net> <20110223162432.GL31195@random.random> <20110223165550.GP31195@random.random> <4D65691E.9080600@internode.on.net> <20110223212541.GV31195@random.random> <4D65825F.5080403@internode.on.net> <20110223235946.GW31195@random.random>
In-Reply-To: <20110223235946.GW31195@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrea Arcangeli wrote, on 24/02/11 10:29:
> On Thu, Feb 24, 2011 at 08:25:43AM +1030, Arthur Marsh wrote:
>> One more combination I tried:
>>
>> Mel Gorman's mm/compaction.c patch with Andrea Archangeli's
>> kswapd-high_wmark + compaction-no-kswapd-3 patches - kswapd0 CPU less
>> than 2 percent and no noticable slowdown of MIDI playback.
>
> Applying Mel's patch on top should decrease latency more.
>
>> If you can send me an updated patch compaction-no-kswapd-3 (I presume
>> that kswapd-high_wmark is still needed) it would be easier for me to apply.
>
> It's a compaction-kswapd-3. It's likely going to work the same as the
> previous compaction-kswapd-2 (not as good as
> compaction-no-kswapd). It's better to apply both the kswapd-high_wmark
> and Mel's patch too (not only this one) during testing.

OK, with kswapd-high_wmark + compaction-kswapd-3 + Mel's patch (with the 
compaction initialisation fix), MIDI playback is fine.
kswapd0 CPU can very occasionally hit equal highest (17 percent was the 
highest I noticed, but is generally below the top 4-5 processes and less 
than 10 percent when working, dropping to around 0.3 percent when swap 
activity has subsided). This was with loading KDE 3.5.10, konversation, 
aptitude -u, icedove and iceweasel with several dozen tabs in addition 
to aplaymidi.

Regards,

Arthur.
