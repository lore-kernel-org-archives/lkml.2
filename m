Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0GIBqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 21:46:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53428 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0GIBqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 21:46:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cE6ldt1wMbBIqunQS6rmb8SJ9JjdVVC5YHvbmW7loPn44kMEoliSuDwSUgYsuadvWT
         aVljJQIkkEa1lTCQjEtcUA3KgiXiMyd0+1W8Sf3CdREAjNnseelgp/XiFQoIVfyYjPNH
         rHzd3NArqyraXRheSTsQgoN9OK21DbepoQj+Q=
MIME-Version: 1.0
In-Reply-To: <20100709090956.CD51.A69D9226@jp.fujitsu.com>
References: <20100708163401.CD34.A69D9226@jp.fujitsu.com>
	<20100708130048.fccfcdad.akpm@linux-foundation.org>
	<20100709090956.CD51.A69D9226@jp.fujitsu.com>
Date: Fri, 9 Jul 2010 10:46:32 +0900
Message-ID: <AANLkTik_NdsbyY3BBxqERxTVIQjKMzXCi-mw7EaISo7R@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] vmscan: don't subtraction of unsined
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 10:16 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>
>> > @@ -2628,16 +2628,16 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>> >              * take a long time.
>> >              */
>> >             while (shrink_slab(sc.nr_scanned, gfp_mask, order) &&
>> > -                   zone_page_state(zone, NR_SLAB_RECLAIMABLE) >
>> > -                           slab_reclaimable - nr_pages)
>> > +                  (zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages > n))
>> >                     ;
>> >
>> >             /*
>> >              * Update nr_reclaimed by the number of slab pages we
>> >              * reclaimed from this zone.
>> >              */
>> > -           sc.nr_reclaimed += slab_reclaimable -
>> > -                   zone_page_state(zone, NR_SLAB_RECLAIMABLE);
>> > +           m = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
>> > +           if (m < n)
>> > +                   sc.nr_reclaimed += n - m;
>>
>> And it's not a completly trivial objection.  Your patch made the above
>> code snippet quite a lot harder to read (and hence harder to maintain).
>
> Initially, I proposed following patch to Christoph. but he prefer n and m.
> To be honest, I don't think this naming is big matter. so you prefer following
> I'll submit it.
>
>
>
>
> =====================================================================
> From 397199d69860061eaa5e1aaadac45c46c76b0522 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Wed, 30 Jun 2010 13:35:16 +0900
> Subject: [PATCH] vmscan: don't subtraction of unsined
>
> 'slab_reclaimable' and 'nr_pages' are unsigned. so, subtraction is
> unsafe.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

I like this than n,m.

-- 
Kind regards,
Minchan Kim
