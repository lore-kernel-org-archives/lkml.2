Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115Ab1D2PZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:25:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56222 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab1D2PZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:25:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fdDqFoc/47U85q2b472uBM/NaMYfbbVOiJc+1wcLHCG0eGgZJBzgU7jt1mVfJizNLC
         VRi9sndpEvVQuXxA/+uekr1yQGJ1FfRndac7PULGDfIzHlZIh8NUMURTW59oko5bz8Hg
         ZmBExzOnLmbDhc2WFjVsmpMvGNF4ByxjzAxAU=
MIME-Version: 1.0
In-Reply-To: <20110428105027.GT4658@suse.de>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<2b79bbf9ddceb73624f49bbe9477126147d875fd.1303833417.git.minchan.kim@gmail.com>
	<20110428105027.GT4658@suse.de>
Date: Sat, 30 Apr 2011 00:25:41 +0900
Message-ID: <BANLkTi=bMm+iyO23+16FxK__V1-aM50zWQ@mail.gmail.com>
Subject: Re: [RFC 5/8] compaction: remove active list counting
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 7:50 PM, Mel Gorman <mgorman@suse.de> wrote:
> On Wed, Apr 27, 2011 at 01:25:22AM +0900, Minchan Kim wrote:
>> acct_isolated of compaction uses page_lru_base_type which returns only
>> base type of LRU list so it never returns LRU_ACTIVE_ANON or LRU_ACTIVE_FILE.
>> So it's pointless to add lru[LRU_ACTIVE_[ANON|FILE]] to get sum.
>>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>
> hmm, isolate_migratepages() is doing a linear scan of PFNs and is
> calling __isolate_lru_page(..ISOLATE_BOTH..). Using page_lru_base_type
> happens to work because we're only interested in the number of isolated
> pages and your patch still covers that. Using page_lru might be more
> accurate in terms of accountancy but does not seem necessary.

True.

>
> Adding a comment explaining why we account for it as inactive and why
> that's ok would be nice although I admit this is something I should have
> done when acct_isolated() was introduced.

When Kame pointed out comment, I wanted to avoid unnecessary comment
so decided changing it with page_lru although it adds overhead a
little bit. But Hannes, you and maybe Kame don't want it. I don't mind
adding comment.
Okay. fix it in next version.

Thanks.

-- 
Kind regards,
Minchan Kim
