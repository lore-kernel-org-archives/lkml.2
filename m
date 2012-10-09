Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2JIDL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 23:11:57 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41092 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2JIDLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 23:11:54 -0400
Message-id: <50739615.9080205@samsung.com>
Date: Tue, 09 Oct 2012 05:12:21 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907
 Thunderbird/15.0.1
MIME-version: 1.0
To: Minchan Kim <minchan@kernel.org>
Cc: Rabin Vincent <rabin@rab.in>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: CMA and zone watermarks
References: <CAH+eYFCJTtF+FeqKs_ho5yyX0tkUBoaa-yfsd1rVshcQ5Xxp=A@mail.gmail.com>
 <20121009031023.GF13817@bbox>
In-reply-to: <20121009031023.GF13817@bbox>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/9/2012 5:10 AM, Minchan Kim wrote:

> On Mon, Oct 08, 2012 at 05:41:14PM +0200, Rabin Vincent wrote:
>> It appears that when CMA is enabled, the zone watermarks are not properly
>> respected, leading to for example GFP_NOWAIT allocations getting access to the
>> high pools.
>>
>> I ran the following test code which simply allocates pages with GFP_NOWAIT
>> until it fails, and then tries GFP_ATOMIC.  Without CMA, the GFP_ATOMIC
>> allocation succeeds, with CMA, it fails too.
>
> Good spot. By wrong zone_watermark_check, it can consume reserved memory pool.

That was the main reason for the Bartek's research.

>> Logs attached (includes my patch which prints the migration type in the failure
>> message http://marc.info/?l=linux-mm&m=134971041701306&w=2), taken on 3.6
>> kernel.
>>
>
> Fortunately, recently, Bart sent a patch about that.
> http://marc.info/?l=linux-mm&m=134763299016693&w=2
>
> Could you test above patches in your kernel?
> You have to apply [2/4], [3/4], [4/4] and don't need [1/4].

AFAIR without patch [1/4], free cma page counter will go below zero and 
weird thing will happen, so better apply the complete patchset.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center
