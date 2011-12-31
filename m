Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1LaOcq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 09:32:46 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52532 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab1LaOcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 09:32:43 -0500
MIME-Version: 1.0
In-Reply-To: <20111229150717.6c8ba825.akpm@linux-foundation.org>
References: <CAJd=RBAp=ooYGoDqJG0qkUhRuYTsSKG9h+bUvC0dvuVCvfkCgQ@mail.gmail.com>
	<20111229150717.6c8ba825.akpm@linux-foundation.org>
Date: Sat, 31 Dec 2011 22:25:29 +0800
Message-ID: <CAJd=RBAp-nC2-VoxgfZ2NjDz08hVkjD_YOoRWuO54ASQCL5hvA@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: fix typo in isolating lru pages
From: Hillf Danton <dhillf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBVEXP5j028393

On Fri, Dec 30, 2011 at 7:07 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 29 Dec 2011 20:38:41 +0800
> Hillf Danton <dhillf@gmail.com> wrote:
>
>> It is not the tag page but the cursor page that we should process, and it looks
>> a typo.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> Cc: Michal Hocko <mhocko@suse.cz>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Hugh Dickins <hughd@google.com>
>> ---
>>
>> --- a/mm/vmscan.c     Thu Dec 29 20:20:16 2011
>> +++ b/mm/vmscan.c     Thu Dec 29 20:23:30 2011
>> @@ -1231,13 +1231,13 @@ static unsigned long isolate_lru_pages(u
>>
>>                               mem_cgroup_lru_del(cursor_page);
>>                               list_move(&cursor_page->lru, dst);
>> -                             isolated_pages = hpage_nr_pages(page);
>> +                             isolated_pages = hpage_nr_pages(cursor_page);
>>                               nr_taken += isolated_pages;
>>                               nr_lumpy_taken += isolated_pages;
>>                               if (PageDirty(cursor_page))
>>                                       nr_lumpy_dirty += isolated_pages;
>>                               scan++;
>> -                             pfn += isolated_pages-1;
>> +                             pfn += isolated_pages - 1;
>>                       } else {
>>                               /*
>>                                * Check if the page is freed already.
>
> This problem looks pretty benign in mainline.  But Andrea's "mm:
> vmscan: check if we isolated a compound page during lumpy scan" came
> along and uses isolated_pages rather a lot more, including using it to
> advance across the pfn array.
>
> I jiggled your patch to suit current mainline then reworked everything
> else so we end up with this result.
>
Hi folks

Thanks for your comments, ack and nack, in 2011.

Happy New Year

Hillf Danton
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
