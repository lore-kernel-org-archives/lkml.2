Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab2BHT1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:27:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64610 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab2BHT1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:27:21 -0500
MIME-Version: 1.0
In-Reply-To: <op.v9cr9sqm3l0zgt@mpn-glaptop>
References: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
 <1328271538-14502-12-git-send-email-m.szyprowski@samsung.com>
 <20120203140428.GG5796@csn.ul.ie> <CA+K6fF49BQiNer=7Di+gCU_EX4E41q-teXJJUBjEd2xc12-j4w@mail.gmail.com>
 <op.v9cr9sqm3l0zgt@mpn-glaptop>
From: sandeep patil <psandeep.s@gmail.com>
Date: Wed, 8 Feb 2012 11:26:40 -0800
Message-ID: <CA+K6fF7naDkPOK8Dv1gg-4RdrrCC5OTx498nFLxg==PPHz-q6g@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 11/15] mm: trigger page reclaim in
 alloc_contig_range() to stabilize watermarks
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Marek Szyprowski <m.szyprowski@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@linux.vnet.ibm.com>, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Clark <rob.clark@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/8 Michal Nazarewicz <mina86@mina86.com>:
> On Wed, 08 Feb 2012 03:04:18 +0100, sandeep patil <psandeep.s@gmail.com>
> wrote:
>>
>> There's another problem I am facing with zone watermarks and CMA.
>>
>> Test details:
>> Memory  : 480 MB of total memory, 128 MB CMA region
>> Test case : around 600 MB of file transfer over USB RNDIS onto target
>> System Load : ftpd with console running on target.
>> No one is doing CMA allocations except for the DMA allocations done by the
>> drivers.
>>
>> Result : After about 300MB transfer, I start getting GFP_ATOMIC
>> allocation failures.  This only happens if CMA region is reserved.
>> Total memory available is way above the zone watermarks. So, we ended
>> up starving
>> UNMOVABLE/RECLAIMABLE atomic allocations that cannot fallback on CMA
>> region.
>
>
> This looks like something Mel warned me about.  I don't really have a good
> solution for that yet. ;/

What if we have NR_FREE_CMA_PAGES in vmstat and use them to calculate
__zone_watermark_ok()?
However, it still doesn't solve the problem when we DON'T want to use
NR_FREE_CMA_PAGES in case of MOVABLE allocations.


Sandeep
