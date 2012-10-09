Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab2JIEjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:39:11 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45308 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2JIEjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:39:08 -0400
X-AuditID: 9c930197-b7b6dae000000e70-df-5073aa69e60e
Date: Tue, 9 Oct 2012 13:43:17 +0900
From: Minchan Kim <minchan@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Rabin Vincent <rabin@rab.in>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: CMA and zone watermarks
Message-ID: <20121009044317.GG13817@bbox>
References: <CAH+eYFCJTtF+FeqKs_ho5yyX0tkUBoaa-yfsd1rVshcQ5Xxp=A@mail.gmail.com>
 <20121009031023.GF13817@bbox>
 <50739615.9080205@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50739615.9080205@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 05:12:21AM +0200, Marek Szyprowski wrote:
> Hello,
> 
> On 10/9/2012 5:10 AM, Minchan Kim wrote:
> 
> >On Mon, Oct 08, 2012 at 05:41:14PM +0200, Rabin Vincent wrote:
> >>It appears that when CMA is enabled, the zone watermarks are not properly
> >>respected, leading to for example GFP_NOWAIT allocations getting access to the
> >>high pools.
> >>
> >>I ran the following test code which simply allocates pages with GFP_NOWAIT
> >>until it fails, and then tries GFP_ATOMIC.  Without CMA, the GFP_ATOMIC
> >>allocation succeeds, with CMA, it fails too.
> >
> >Good spot. By wrong zone_watermark_check, it can consume reserved memory pool.
> 
> That was the main reason for the Bartek's research.

Okay. It shoud have written down for more good description at that time. :)

> 
> >>Logs attached (includes my patch which prints the migration type in the failure
> >>message http://marc.info/?l=linux-mm&m=134971041701306&w=2), taken on 3.6
> >>kernel.
> >>
> >
> >Fortunately, recently, Bart sent a patch about that.
> >http://marc.info/?l=linux-mm&m=134763299016693&w=2
> >
> >Could you test above patches in your kernel?
> >You have to apply [2/4], [3/4], [4/4] and don't need [1/4].
> 
> AFAIR without patch [1/4], free cma page counter will go below zero
> and weird thing will happen, so better apply the complete patchset.

I can't understand your point. [1/4] is just fix for correcting trace
No?

http://marc.info/?l=linux-mm&m=134763301216713&w=2


> 
> Best regards
> -- 
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
