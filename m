Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1D0IM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:12:26 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62904 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab1D0IMU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:12:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g5OfpBVIVUmY5K7aKQwGkZms1gWX8iOm8+CFIP1wumnjsn+HfeAqn3IZOP+5LhuMeL
         7IMplVWAtADxqMeHAz8tqsTKipeUOQ/Uec3f4yrzXxVYbEDClJQF3fowBKG5LsNm28Ha
         fgckAjyvRGYLzLHqA0R/oFlXMwNKO00aePY1I=
MIME-Version: 1.0
In-Reply-To: <20110427165437.bef6967a.kamezawa.hiroyu@jp.fujitsu.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<1d9791f27df2341cb6750f5d6279b804151f57f9.1303833417.git.minchan.kim@gmail.com>
	<20110427165437.bef6967a.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 27 Apr 2011 17:12:19 +0900
Message-ID: <BANLkTinq7w+cejBgBMuWvGw9htK0YJOvEw@mail.gmail.com>
Subject: Re: [RFC 1/8] Only isolate page we can handle
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 4:54 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 27 Apr 2011 01:25:18 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> There are some places to isolate lru page and I believe
>> users of isolate_lru_page will be growing.
>> The purpose of them is each different so part of isolated pages
>> should put back to LRU, again.
>>
>> The problem is when we put back the page into LRU,
>> we lose LRU ordering and the page is inserted at head of LRU list.
>> It makes unnecessary LRU churning so that vm can evict working set pages
>> rather than idle pages.
>>
>> This patch adds new filter mask when we isolate page in LRU.
>> So, we don't isolate pages if we can't handle it.
>> It could reduce LRU churning.
>>
>> This patch shouldn't change old behavior.
>> It's just used by next patches.
>>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> nitpick below.
>
>> ---
>>  include/linux/swap.h |    3 ++-
>>  mm/compaction.c      |    2 +-
>>  mm/memcontrol.c      |    2 +-
>>  mm/vmscan.c          |   26 ++++++++++++++++++++------
>>  4 files changed, 24 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index 384eb5f..baef4ad 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -259,7 +259,8 @@ extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
>>                                               unsigned int swappiness,
>>                                               struct zone *zone,
>>                                               unsigned long *nr_scanned);
>> -extern int __isolate_lru_page(struct page *page, int mode, int file);
>> +extern int __isolate_lru_page(struct page *page, int mode, int file,
>> +                             int not_dirty, int not_mapped);
>
> Hmm, which is better to use 4 binary args or a flag with bitmask ?

Yes. Even I added new flags one more in next patch.
So I try to use bitmask flag in next version.
Thanks.


>
> Thanks,
> -Kame
>
>



-- 
Kind regards,
Minchan Kim
