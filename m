Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2JIDGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 23:06:15 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45252 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2JIDGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 23:06:13 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-d9-507394a3422f
Date: Tue, 9 Oct 2012 12:10:23 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rabin Vincent <rabin@rab.in>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: CMA and zone watermarks
Message-ID: <20121009031023.GF13817@bbox>
References: <CAH+eYFCJTtF+FeqKs_ho5yyX0tkUBoaa-yfsd1rVshcQ5Xxp=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH+eYFCJTtF+FeqKs_ho5yyX0tkUBoaa-yfsd1rVshcQ5Xxp=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 08, 2012 at 05:41:14PM +0200, Rabin Vincent wrote:
> It appears that when CMA is enabled, the zone watermarks are not properly
> respected, leading to for example GFP_NOWAIT allocations getting access to the
> high pools.
> 
> I ran the following test code which simply allocates pages with GFP_NOWAIT
> until it fails, and then tries GFP_ATOMIC.  Without CMA, the GFP_ATOMIC
> allocation succeeds, with CMA, it fails too.

Good spot. By wrong zone_watermark_check, it can consume reserved memory pool.

> 
> Logs attached (includes my patch which prints the migration type in the failure
> message http://marc.info/?l=linux-mm&m=134971041701306&w=2), taken on 3.6
> kernel.
> 

Fortunately, recently, Bart sent a patch about that.
http://marc.info/?l=linux-mm&m=134763299016693&w=2

Could you test above patches in your kernel?
You have to apply [2/4], [3/4], [4/4] and don't need [1/4].

Thanks.

-- 
Kind regards,
Minchan Kim
