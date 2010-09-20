Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab0ITLPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 07:15:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47664 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab0ITLPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 07:15:49 -0400
Message-ID: <215a2d3717d0d55026688fb59ff7bb79.squirrel@www.firstfloor.org>
In-Reply-To: <20100920110323.GI1998@csn.ul.ie>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com>
    <1283908781-13810-4-git-send-email-n-horiguchi@ah.jp.nec.com>
    <20100920110323.GI1998@csn.ul.ie>
Date: Mon, 20 Sep 2010 13:15:44 +0200
Subject: Re: [PATCH 03/10] hugetlb: redefine hugepage copy functions
From: "Andi Kleen" <andi@firstfloor.org>
To: "Mel Gorman" <mel@csn.ul.ie>
Cc: "Naoya Horiguchi" <n-horiguchi@ah.jp.nec.com>,
        "Andi Kleen" <andi@firstfloor.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Christoph Lameter" <cl@linux-foundation.org>,
        "Wu Fengguang" <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        "linux-mm" <linux-mm@kvack.org>, "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +static void copy_gigantic_page(struct page *dst, struct page *src)
>> +{
>> +	int i;
>> +	struct hstate *h = page_hstate(src);
>> +	struct page *dst_base = dst;
>> +	struct page *src_base = src;
>> +
>> +	for (i = 0; i < pages_per_huge_page(h); ) {
>> +		cond_resched();
>
> Should this function not have a might_sleep() check too?

cond_resched() implies might_sleep I believe. I think
that answers the earlier question too becuse that function
calls this.

	/*
>
> Other than the removal of the might_sleep() check, this looks ok too.

Can I assume an Ack?

Thanks,
-Andi

