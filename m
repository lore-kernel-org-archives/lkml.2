Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab0JLOGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 10:06:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42553 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477Ab0JLOGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 10:06:10 -0400
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?Penttil=E4?= Mika <mika.penttila@ixonos.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HWPOISON: Implement hwpoison-on-free for soft offlining
References: <1A61D8EA6755AF458F06EA669A4EC81815FDA6FE@JKLMAIL02.ixonos.local>
Date: Tue, 12 Oct 2010 16:06:08 +0200
In-Reply-To: <1A61D8EA6755AF458F06EA669A4EC81815FDA6FE@JKLMAIL02.ixonos.local>
	(Penttil's message of "Tue, 12 Oct 2010 12:38:10 +0000")
Message-ID: <8762x733qn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Penttilä Mika <mika.penttila@ixonos.com> writes:

Please always cc people when answering list emails.
Missed this earlier.

>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -564,6 +564,8 @@ static inline int free_pages_check(struct page *page)
>>  		(page->mapping != NULL)  |
>>  		(atomic_read(&page->_count) != 0) |
>>  		(page->flags & PAGE_FLAGS_CHECK_AT_FREE))) {
>> +		if (PageHWPoisonOnFree(page))
>> +			hwpoison_page_on_free(page);
>
> hwpoison_page_on_free() seems to be undefined when
> CONFIG_HWPOISON_ON_FREE is not defined.

The optimizer takes care of that.

>
>>  		bad_page(page);
>>  		return 1;
>>  	}
>
> And of course PAGE_FLAGS_CHECK_AT_FREE should include
> pahehwpoisononfree this to be effective

It is of course (__PG_HWPOISON_ON_FREE)

Thanks for the review.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
