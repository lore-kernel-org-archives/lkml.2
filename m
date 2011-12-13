Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1LMP2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:28:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46547 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab1LMP2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:28:51 -0500
Date: Tue, 13 Dec 2011 16:28:43 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mm: bootmem: drop superfluous range check when
 freeing pages in bulk
Message-ID: <20111213152843.GD4585@pengutronix.de>
References: <1323784711-1937-1-git-send-email-hannes@cmpxchg.org>
 <1323784711-1937-4-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1323784711-1937-4-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Johannes,

On Tue, Dec 13, 2011 at 02:58:30PM +0100, Johannes Weiner wrote:
> The area node_bootmem_map represents is aligned to BITS_PER_LONG, and
> all bits in any aligned word of that map valid.  When the represented
> area extends beyond the end of the node, the non-existant pages will
> be marked as reserved.
> 
> As a result, when freeing a page block, doing an explicit range check
> for whether that block is within the node's range is redundant as the
> bitmap is consulted anyway to see whether all pages in the block are
> unreserved.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
I suggest to drop my patch then and add something like

	Reported-by: $me

to this one instead.

Other than that I will give your series a spin on my ARM machine later
today.

Best regards
Uwe

> ---
>  mm/bootmem.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 3e6f152..1aea171 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -197,7 +197,7 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
>  		idx = start - bdata->node_min_pfn;
>  		vec = ~map[idx / BITS_PER_LONG];
>  
> -		if (aligned && vec == ~0UL && start + BITS_PER_LONG <= end) {
> +		if (aligned && vec == ~0UL) {
>  			int order = ilog2(BITS_PER_LONG);
>  
>  			__free_pages_bootmem(pfn_to_page(start), order);
> -- 
> 1.7.7.3
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
