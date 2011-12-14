Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab1LNPhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:37:45 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62144 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab1LNPho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:37:44 -0500
MIME-Version: 1.0
In-Reply-To: <20111214122041.GF3487@suse.de>
References: <1323798271-1452-1-git-send-email-mikew@google.com>
 <1323829490.22361.395.camel@sli10-conroe> <CAGTjWtDvmLnNqUoddUCmLVSDN0HcOjtsuFbAs+MFy24JFX-P3g@mail.gmail.com>
 <20111214122041.GF3487@suse.de>
From: Mike Waychison <mikew@google.com>
Date: Wed, 14 Dec 2011 07:37:22 -0800
Message-ID: <CAGTjWtByuv2Z+7rydJzdydrQmxiE5ErHH8OaX6fhOg5eS6X9OQ@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix kswapd livelock on single core, no preempt kernel
To: Mel Gorman <mgorman@suse.de>
Cc: Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickens <hughd@google.com>, Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 4:20 AM, Mel Gorman <mgorman@suse.de> wrote:
> On Tue, Dec 13, 2011 at 08:36:43PM -0800, Mike Waychison wrote:
>> FYI, this was seen with a 2.6.39-based kernel with no-numa, no-memcg
>> and swap-enabled.
>>
>
> If this is 2.6.39, can you try applying the commit
> [f06590bd: mm: vmscan: correctly check if reclaimer should schedule during shrink_slab]
>
> There have been a few fixes around kswapd hogging the CPU since 2.6.39.

In this particular case, I didn't see any problem acquiring
shrinker_rwsem (the shrinkers should up in the cpu profile I
gathered).  I think this patch would fix my issue though as it happens
to drop in a cond_resched() into the path.  It isn't obvious that this
cond_resched() really belongs in shrink_slab() though.  Thanks :)

>
> --
> Mel Gorman
> SUSE Labs
