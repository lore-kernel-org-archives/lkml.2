Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab2FYBTQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 21:19:16 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59641 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2FYBTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 21:19:15 -0400
X-AuditID: 9c930197-b7c94ae0000037ff-f6-4fe7bc8db320
Message-ID: <4FE7BCAD.4090002@kernel.org>
Date: Mon, 25 Jun 2012 10:19:41 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: undisclosed-recipients:";
	Kamezawa Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        Aaditya Kumar <aaditya.kumar.30@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	undisclosed-recipients:;Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
						^-missing end of address
Subject: Re: Accounting problem of MIGRATE_ISOLATED freed page
References: <4FE169B1.7020600@kernel.org> <4FE16E80.9000306@gmail.com> <4FE18187.3050103@kernel.org> <4FE23069.5030702@gmail.com> <4FE26470.90401@kernel.org> <CAHGf_=pjoiHQ9vxXXe-GtbkYRzhxdDhu3pf6pwDsCe5pBQE8Nw@mail.gmail.com> <4FE27F15.8050102@kernel.org> <CAHGf_=pDw4axwG2tQ+B5hPks-sz2S5+G1Kk-=HSDmo=DSXOkEw@mail.gmail.com> <4FE2A937.6040701@kernel.org> <4FE2FCFB.4040808@jp.fujitsu.com> <4FE3C4E4.2050107@kernel.org> <4FE414A2.3000700@kernel.org> <4FE530F7.1060108@gmail.com>
In-Reply-To: <4FE530F7.1060108@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2012 11:59 AM, KOSAKI Motohiro wrote:

> 
> One more.
> 
> 
>> +/*
>> + * NOTE:
>> + * Don't use set_pageblock_migratetype(page, MIGRATE_ISOLATE) direclty.
>> + * Instead, use {un}set_pageblock_isolate.
>> + */
>>  void set_pageblock_migratetype(struct page *page, int migratetype)
>>  {
>>         if (unlikely(page_group_by_mobility_disabled))
> 
> I don't think we need this comment. please just add BUG_ON.


It adds new condition check in __rmqueue_fallback.
If it's okay, no problem.

But as you know, calling MIGRATE_ISOLATE is very very rare and we can
make sure it's no problem on existing code. So the problem is future
user and I hope they can look at the code comment before using and we mm
have strong review system rather than other subsystem, I believe. :)

If you can't agree, I am willing to add BUG_ON but not sure others
like it. (Especially, Mel).



-- 
Kind regards,
Minchan Kim
