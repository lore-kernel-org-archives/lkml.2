Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2KUKgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:36:21 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:42948 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab2KUKgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:36:19 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: trace filemap add and del
References: <1352404450-30100-1-git-send-email-robert.jarzmik@free.fr>
	<20121120155735.905bbf9e.akpm@linux-foundation.org>
X-URL: http://belgarath.falguerolles.org/
Date: Wed, 21 Nov 2012 11:36:09 +0100
In-Reply-To: <20121120155735.905bbf9e.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 20 Nov 2012 15:57:35 -0800")
Message-ID: <87sj835jl2.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>> +	TP_STRUCT__entry(
>> +		__field(struct page *, page)
>> +		__field(unsigned long, i_no)
>
> May as well call this i_ino - there's little benefit in using a
> different identifier.
Agreed for patch V2.
>
>> +		__field(unsigned long, pageofs)
>
> "index".
Agreed for patch V2.

>
>> +		__field(dev_t, s_dev)
>
> Perhaps use super_block.s_id here
If you imply by that that dereferencing page->mapping->host->i_sb and looking
for field s_dev, then I don't agree. Sometimes i_sb is NULL from what I recall,
especially in cases where the read page is from a journaling partition.

So unless I didn't understand you, I'll keep this part as well as the following,
to cover :
 - a mapping of an actual file
 - a mapping of a partition block

>
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->page = page;
>> +		__entry->i_no = page->mapping->host->i_ino;
>> +		__entry->pageofs = page->index;
>> +		if (page->mapping->host->i_sb)
>> +			__entry->s_dev = page->mapping->host->i_sb->s_dev;
>> +		else
>> +			__entry->s_dev = page->mapping->host->i_rdev;
>
> and hence avoid all this stuff.
See above.

>
>> +	),
>> +
>> +	TP_printk("page=%p pfn=%lu blk=%d:%d inode+ofs=%lu+%lu",
>> +		__entry->page,
>> +		page_to_pfn(__entry->page),
>> +		MAJOR(__entry->s_dev), MINOR(__entry->s_dev),
>> +		__entry->i_no,
>> +		__entry->pageofs << PAGE_SHIFT)
>> +);
>> +
>> +TRACE_EVENT(mm_filemap_add_to_page_cache,
>
Agreed for patch V2.

Thanks for the review.

-- 
Robert
