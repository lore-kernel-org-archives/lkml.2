Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab0JRFwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 01:52:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47005 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0JRFwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 01:52:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wcHg+5MCnO67mp5VTt1CkDAL9N0QhnlOa/sfTKsZEvxq1FTCmstdtUVFkIdvYYJTNz
         pSYGXS75I7dYa0acS/UAOtMyVH8Y4nsSQ567VdgtJE59X6SIdSGZMMiODqhyMW5VcCH0
         GpmkTOjqXNC/c5P1GPqndgAfi4Fw+yxvp3BIw=
MIME-Version: 1.0
In-Reply-To: <20101018143108.4e0e5299.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
	<20101013121829.c3320944.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTingNmxT6ww_VB_K=rjsgR+dHANLnyNkwV1Myvnk@mail.gmail.com>
	<20101018093533.abd4c8ee.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikt+kq2LHZNSJAN3EQwYALdYtGuOAXfVghN-7oY@mail.gmail.com>
	<20101018143108.4e0e5299.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 18 Oct 2010 14:52:19 +0900
Message-ID: <AANLkTimpVWwH=znGkG8zEPBcYxq-+UR+7mN29f-RK7d=@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/3] alloc contig pages with migration.
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 2:31 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Mon, 18 Oct 2010 14:18:52 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>> >
>> >> > + *
>> >> > + * Search an area of @size in the physical memory map and checks wheter
>> >>
>> >> Typo
>> >> whether
>> >>
>> >> > + * we can create a contigous free space. If it seems possible, try to
>> >> > + * create contigous space with page migration. If no_search==true, we just try
>> >> > + * to allocate [hint, hint+size) range of pages as contigous block.
>> >> > + *
>> >> > + * Returns a page of the beginning of contiguous block. At failure, NULL
>> >> > + * is returned. Each page in the area is set to page_count() = 1. Because
>> >>
>> >> Why do you mention page_count() = 1?
>> >> Do users of this function have to know it?
>> >
>> > A user can free any page within the range for his purpose.
>>
>> I think it's not a good idea if we allow handling of page by page, not
>> for page-chunk requested by user.
>> By mistake, free_contig_pages could have a trouble to free pages.
>> Why do you support the feature?  Do you have any motivation?
>>
> No big motivation.
>
> Usual pages are set up by prep_compund_page(page, order), but it is pages smaller
> than MAX_ORDER.  Then, I called prep_new_page() one by one.
> And I don't think some new prep_xxxx_page() is required.
>
> If you requests, ok, I'll add one.

Maybe we are talking another thing.

My question is why you noticed "page_count() == 1" in function description.
So your answer was for user to free some pages within big contiguous page.
Then, my concern is that if you didn't mentioned page_count() == 1 in
description, anonymous user will use just alloc_contig_pages and
free_contig_pages. That's enough for current our requirement. But
since you mentioned page_count() == 1 and you want for user to free
some pages within big contiguous page, anonymous user who isn't expert
in mm or careless people can free pages _freely_. It could make BUG
easily(free_contig_pages can free the page which is freed by user's
put_page).

So if there isn't strong cause, I hope removing the mention for
preventing careless API usage.

>
> Thanks,
> -Kame
>
>



-- 
Kind regards,
Minchan Kim
