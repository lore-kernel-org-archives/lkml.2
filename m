Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab1HLHEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 03:04:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50023 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1HLHEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 03:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <20110812065858.GA6916@redhat.com>
References: <1313094715-31187-1-git-send-email-jweiner@redhat.com>
	<1313094715-31187-2-git-send-email-jweiner@redhat.com>
	<CAEwNFnBp7JBWpuaT=ZKDyfQTQqOe_mT0CLFAw9LWo10GoXaFnQ@mail.gmail.com>
	<20110812065858.GA6916@redhat.com>
Date: Fri, 12 Aug 2011 16:04:08 +0900
Message-ID: <CAEwNFnDHdPKLrN0aDxd1RTYZT-ua=yTpYVQqAunNaqkr8ok4nQ@mail.gmail.com>
Subject: Re: [patch 2/2] mm: vmscan: drop nr_force_scan[] from get_scan_count
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Balbir Singh <bsingharora@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 3:58 PM, Johannes Weiner <jweiner@redhat.com> wrote:
> On Fri, Aug 12, 2011 at 08:44:34AM +0900, Minchan Kim wrote:
>> On Fri, Aug 12, 2011 at 5:31 AM, Johannes Weiner <jweiner@redhat.com> wrote:
>> > The nr_force_scan[] tuple holds the effective scan numbers for anon
>> > and file pages in case the situation called for a forced scan and the
>> > regularly calculated scan numbers turned out zero.
>> >
>> > However, the effective scan number can always be assumed to be
>> > SWAP_CLUSTER_MAX right before the division into anon and file.  The
>> > numerators and denominator are properly set up for all cases, be it
>> > force scan for just file, just anon, or both, to do the right thing.
>> >
>> > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
>>
>> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>
> Thanks.
>
>> There is a nitpick at below.
>
>> > @@ -1927,20 +1917,10 @@ out:
>> >                scan = zone_nr_lru_pages(zone, sc, l);
>> >                if (priority || noswap) {
>> >                        scan >>= priority;
>> > +                       if (!scan && force_scan)
>> > +                               scan = SWAP_CLUSTER_MAX;
>> >                        scan = div64_u64(scan * fraction[file], denominator);
>> >                }
>> > -
>> > -               /*
>> > -                * If zone is small or memcg is small, nr[l] can be 0.
>> > -                * This results no-scan on this priority and priority drop down.
>> > -                * For global direct reclaim, it can visit next zone and tend
>> > -                * not to have problems. For global kswapd, it's for zone
>> > -                * balancing and it need to scan a small amounts. When using
>> > -                * memcg, priority drop can cause big latency. So, it's better
>> > -                * to scan small amount. See may_noscan above.
>> > -                */
>>
>> Please move this comment with tidy-up at where making force_scan true.
>> Of course, we can find it by git log[246e87a9393] but as I looked the
>> git log, it explain this comment indirectly and it's not
>> understandable to newbies. I think this comment is more understandable
>> than changelog in git.
>
> I guess you are right, I am a bit overeager when deleting comments.
> How is this?
>
> ---
> From: Johannes Weiner <jweiner@redhat.com>
> Subject: [patch] mm: vmscan: drop nr_force_scan[] from get_scan_count
>
> The nr_force_scan[] tuple holds the effective scan numbers for anon
> and file pages in case the situation called for a forced scan and the
> regularly calculated scan numbers turned out zero.
>
> However, the effective scan number can always be assumed to be
> SWAP_CLUSTER_MAX right before the division into anon and file.  The
> numerators and denominator are properly set up for all cases, be it
> force scan for just file, just anon, or both, to do the right thing.
>
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Thanks, Hannes.
-- 
Kind regards,
Minchan Kim
