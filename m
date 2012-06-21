Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab2FUBr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:47:29 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59844 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab2FUBr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:47:28 -0400
MIME-Version: 1.0
In-Reply-To: <4FE26470.90401@kernel.org>
References: <4FE169B1.7020600@kernel.org> <4FE16E80.9000306@gmail.com>
 <4FE18187.3050103@kernel.org> <4FE23069.5030702@gmail.com> <4FE26470.90401@kernel.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 20 Jun 2012 21:39:07 -0400
Message-ID: <CAHGf_=pjoiHQ9vxXXe-GtbkYRzhxdDhu3pf6pwDsCe5pBQE8Nw@mail.gmail.com>
Subject: Re: Accounting problem of MIGRATE_ISOLATED freed page
To: Minchan Kim <minchan@kernel.org>
Cc: Aaditya Kumar <aaditya.kumar.30@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> number of isolate page block is almost always 0. then if we have such counter,
>> we almost always can avoid zone->lock. Just idea.
>
> Yeb. I thought about it but unfortunately we can't have a counter for MIGRATE_ISOLATE.
> Because we have to tweak in page free path for pages which are going to free later after we
> mark pageblock type to MIGRATE_ISOLATE.

I mean,

if (nr_isolate_pageblock != 0)
   free_pages -= nr_isolated_free_pages(); // your counting logic

return __zone_watermark_ok(z, alloc_order, mark,
                              classzone_idx, alloc_flags, free_pages);


I don't think this logic affect your race. zone_watermark_ok() is already
racy. then new little race is no big matter.
