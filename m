Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab0CXMZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 08:25:50 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:8377 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab0CXMZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 08:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xzws3QgjF1hrWBeFFuzXdKjyf6jhKabCHxq/x5FJNV4czZVbGVsZ2BP0sU+mtknhXj
         GO14L5UoX6dFgOquSwKPp0ML6THUfExUf4iLJy4SMRYOzRrcv400GGjS+WppyoTSamLl
         dSfUI47ULIbMGMZG/1Dg93KWWoWqhCZ53I6i4=
MIME-Version: 1.0
In-Reply-To: <20100324120930.GH21147@csn.ul.ie>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	 <1269347146-7461-11-git-send-email-mel@csn.ul.ie>
	 <28c262361003231610p3753a136v51720df8568cfa0a@mail.gmail.com>
	 <20100324111159.GD21147@csn.ul.ie>
	 <28c262361003240459m7d981203nea98df5196812b6c@mail.gmail.com>
	 <20100324120930.GH21147@csn.ul.ie>
Date: Wed, 24 Mar 2010 21:25:48 +0900
Message-ID: <28c262361003240525v51a78880u63680bf576d1b618@mail.gmail.com>
Subject: Re: [PATCH 10/11] Direct compact when a high-order allocation fails
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 9:09 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Wed, Mar 24, 2010 at 08:59:45PM +0900, Minchan Kim wrote:
>> On Wed, Mar 24, 2010 at 8:11 PM, Mel Gorman <mel@csn.ul.ie> wrote:
>> > On Wed, Mar 24, 2010 at 08:10:40AM +0900, Minchan Kim wrote:
>> >> Hi, Mel.
>> >>
>> >> On Tue, Mar 23, 2010 at 9:25 PM, Mel Gorman <mel@csn.ul.ie> wrote:
>> >> > Ordinarily when a high-order allocation fails, direct reclaim is entered to
>> >> > free pages to satisfy the allocation.  With this patch, it is determined if
>> >> > an allocation failed due to external fragmentation instead of low memory
>> >> > and if so, the calling process will compact until a suitable page is
>> >> > freed. Compaction by moving pages in memory is considerably cheaper than
>> >> > paging out to disk and works where there are locked pages or no swap. If
>> >> > compaction fails to free a page of a suitable size, then reclaim will
>> >> > still occur.
>> >> >
>> >> > Direct compaction returns as soon as possible. As each block is compacted,
>> >> > it is checked if a suitable page has been freed and if so, it returns.
>> >> >
>> >> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
>> >> > Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

<snip>

>> You're right. I just wanted to change the name as one which imply
>> direct compaction.
>
> I think I'd fully agree with your point if there was more than one way to
> stall a process due to compaction. As it is, direct compaction is the only
> way to meaningfully stall a process and I can't think of alternative stalls
> in the future. Technically, a process using the sysfs or proc triggers for
> compaction also stalls but it's not interesting to count those events.
>
>> That's because I believe we will implement it by backgroud, too.
>
> This is a possibility but in that case it would be a separate process
> like kcompactd and I wouldn't count it as a stall as such.
>
>> Then It's more straightforward, I think. :-)
>>
>> > How about COMPACTSTALL like ALLOCSTALL? :/
>>
>> I wouldn't have a strong objection any more if you insist on it.
>>
>
> I'm not insisting as such, I just don't think renaming it to
> PGSCAN_COMPACT_X would be easier to understand.

Totally, I agree with your opinion.
>From now on, I don't have any objection.




-- 
Kind regards,
Minchan Kim
