Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab0GFGiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 02:38:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40526 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab0GFGiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 02:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YWddjfRL2MFLw5O9IIWMcc5rp8fIRaf4ZeILimuK8idb+bsdBz5MQx2Z7Zd4nPeoAG
         krgihivcJQUNebEN7/u/HLSI4eYMaaSvS0AMhYqE6i3MYpE+zuX1JWnGoKdGjFQz3mUJ
         HHug3fP6pB0VbnhjzVUrA1x9VEcV9yaoF5k7s=
MIME-Version: 1.0
In-Reply-To: <20100706150030.CCFA.A69D9226@jp.fujitsu.com>
References: <20100706093529.CCD1.A69D9226@jp.fujitsu.com>
	<AANLkTimk6SwmljTWpIgp_OI_eLP6w8BCWKf-VRUFQ65H@mail.gmail.com>
	<20100706150030.CCFA.A69D9226@jp.fujitsu.com>
Date: Tue, 6 Jul 2010 15:38:09 +0900
Message-ID: <AANLkTimXqmTi9nM8Z10IwU68XTJmrbrie-oxzke8BD40@mail.gmail.com>
Subject: Re: [PATCH 12/14] vmscan: Do not writeback pages in direct reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
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

On Tue, Jul 6, 2010 at 3:02 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Tue, Jul 6, 2010 at 9:36 AM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > Hello,
>> >
>> >> Ok, that's reasonable as I'm still working on that patch. For example, the
>> >> patch disabled anonymous page writeback which is unnecessary as the stack
>> >> usage for anon writeback is less than file writeback.
>> >
>> > How do we examine swap-on-file?
>>
>> bool is_swap_on_file(struct page *page)
>> {
>>     struct swap_info_struct *p;
>>     swp_entry_entry entry;
>>     entry.val = page_private(page);
>>     p = swap_info_get(entry);
>>     return !(p->flags & SWP_BLKDEV)
>> }
>
> Well, do you suggested we traverse all pages in lru _before_
> starting vmscan?
>

No. I don't suggest anything.
What I say is just we can do it.
If we have to implement it, Couldn't we do it in write_reclaim_page?



-- 
Kind regards,
Minchan Kim
