Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0GFLY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 07:24:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42729 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0GFLY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 07:24:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cx1dBkjvSwi0gqa5mqSaEs6adfGT/fS5dolNzA9kBmIK0sFwdhTrE8bTiMbAeYzWXJ
         kRGLCYNwuLDvrGzpRosFRTyZfdGO4nO+slxCSfuPGhAGHJG1wSJyI8sDZx/abBR5Q6pd
         L4Wd/AZo1e+ENk7GV03pB9bQcP4YspGBuM0CE=
MIME-Version: 1.0
In-Reply-To: <20100706101235.GE13780@csn.ul.ie>
References: <20100702125155.69c02f85.akpm@linux-foundation.org>
	<20100705134949.GC13780@csn.ul.ie>
	<20100706093529.CCD1.A69D9226@jp.fujitsu.com>
	<20100706101235.GE13780@csn.ul.ie>
Date: Tue, 6 Jul 2010 20:24:57 +0900
Message-ID: <AANLkTin8FotAC1GvjuoYU9XA2eiSr6FWWh6bwypTdhq3@mail.gmail.com>
Subject: Re: [PATCH 12/14] vmscan: Do not writeback pages in direct reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mel.

On Tue, Jul 6, 2010 at 7:12 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Tue, Jul 06, 2010 at 09:36:41AM +0900, KOSAKI Motohiro wrote:
>> Hello,
>>
>> > Ok, that's reasonable as I'm still working on that patch. For example, the
>> > patch disabled anonymous page writeback which is unnecessary as the stack
>> > usage for anon writeback is less than file writeback.
>>
>> How do we examine swap-on-file?
>>
>
> Anything in particular wrong with the following?
>
> /*
>  * For now, only kswapd can writeback filesystem pages as otherwise
>  * there is a stack overflow risk
>  */
> static inline bool reclaim_can_writeback(struct scan_control *sc,
>                                        struct page *page)
> {
>        return !page_is_file_cache(page) || current_is_kswapd();
> }
>
> Even if it is a swapfile, I didn't spot a case where the filesystems
> writepage would be called. Did I miss something?


As I understand Kosaki's opinion, He said that if we make swapout in
pageout, it isn't a problem in case of swap device since swapout of
block device is light but it is still problem in case of swap file.
That's because swapout on swapfile cause file system writepage which
makes kernel stack overflow.

Do I misunderstand kosaki's point?


-- 
Kind regards,
Minchan Kim
