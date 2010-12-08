Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0LHIYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:24:22 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:41004 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab0LHIYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:24:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GkSpb4elA6BQgSzhYApnWH4f66lBaMTEzKe3ecvW8Wj1FJwVC9ZJBzL/ZCXTYPFx0V
         FiUkpPG7v/kZpiZaHXTbJCsK5wzH+IvcMszXVrelJiY9Fl9Sw2HxcbzTE5/gKahfGSme
         orsyhN8YIXf8qNQx8h3AqEc+4ctczgzwRbngM=
MIME-Version: 1.0
In-Reply-To: <20101208170504.1750.A69D9226@jp.fujitsu.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
	<0724024711222476a0c8deadb5b366265b8e5824.1291568905.git.minchan.kim@gmail.com>
	<20101208170504.1750.A69D9226@jp.fujitsu.com>
Date: Wed, 8 Dec 2010 17:16:01 +0900
Message-ID: <AANLkTikG1EAMm8yPvBVUXjFz1Bu9m+vfwH3TRPDzS9mq@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] Reclaim invalidated page ASAP
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 5:04 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> invalidate_mapping_pages is very big hint to reclaimer.
>> It means user doesn't want to use the page any more.
>> So in order to prevent working set page eviction, this patch
>> move the page into tail of inactive list by PG_reclaim.
>>
>> Please, remember that pages in inactive list are working set
>> as well as active list. If we don't move pages into inactive list's
>> tail, pages near by tail of inactive list can be evicted although
>> we have a big clue about useless pages. It's totally bad.
>>
>> Now PG_readahead/PG_reclaim is shared.
>> fe3cba17 added ClearPageReclaim into clear_page_dirty_for_io for
>> preventing fast reclaiming readahead marker page.
>>
>> In this series, PG_reclaim is used by invalidated page, too.
>> If VM find the page is invalidated and it's dirty, it sets PG_reclaim
>> to reclaim asap. Then, when the dirty page will be writeback,
>> clear_page_dirty_for_io will clear PG_reclaim unconditionally.
>> It disturbs this serie's goal.
>>
>> I think it's okay to clear PG_readahead when the page is dirty, not
>> writeback time. So this patch moves ClearPageReadahead.
>>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> Acked-by: Rik van Riel <riel@redhat.com>
>> Acked-by: Mel Gorman <mel@csn.ul.ie>
>> Cc: Wu Fengguang <fengguang.wu@intel.com>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Nick Piggin <npiggin@kernel.dk>
>
> Until anyone should data, I will not ack this. This patch increase
> VM state, but benefit is doubious.

Make sense to me. If Ben is busy, I will measure it and send the result.
Thanks!

-- 
Kind regards,
Minchan Kim
