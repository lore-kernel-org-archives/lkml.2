Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab0IBAnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 20:43:46 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:29864 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753715Ab0IBAnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 20:43:45 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 3yJZbHAVM1mmSKjyeb9z6fw_8f.P_23Tfowd82Ttm1dkq9A
 H8fW4CvvCJxrIvrpE_nUVkI4vcdHYTXBHDnaQBl49oa9TJOH08GVG8.SRVXV
 2EXFc1Fc.zQPCIDT56D_wWi9ejW4b6zgrzNfP.8hZz1ElP2X01N7uK_NYvkG
 zQ9gaApeRBaTKBznGcEDogiIMyihqIqL9uCp3dVsAjsFu01kyKUPcR2dwITP
 C
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 1 Sep 2010 19:43:41 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of
 NR_FREE_PAGES when memory is low and kswapd is awake
In-Reply-To: <1283276257-1793-3-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1009011942150.21189@router.home>
References: <1283276257-1793-1-git-send-email-mel@csn.ul.ie> <1283276257-1793-3-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010, Mel Gorman wrote:

> +#ifdef CONFIG_SMP
> +/* Called when a more accurate view of NR_FREE_PAGES is needed */
> +unsigned long zone_nr_free_pages(struct zone *zone)
> +{
> +	unsigned long nr_free_pages = zone_page_state(zone, NR_FREE_PAGES);

You cannot call zone_page_state here because zone_page_state clips the
counter at zero. The nr_free_pages needs to reflect the unclipped state
and then the deltas need to be added. Then the clipping at zero can be
done.
