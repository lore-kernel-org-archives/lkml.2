Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab2FJEgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 00:36:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:40950 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab2FJEgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 00:36:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163698501"
Date: Sun, 10 Jun 2012 12:36:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: Re: [PATCH] page-writeback.c: fix update bandwidth time judgment
 error
Message-ID: <20120610043641.GA10355@localhost>
References: <1339302005-366-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339302005-366-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanpeng,

Sorry this I won't take this: it don't really improve anything.  Even
with the changed test, the real intervals are still some random values
above (and not far away from) 200ms.. We are saying about 200ms
intervals just for convenience.

Thanks,
Fengguang

On Sun, Jun 10, 2012 at 12:20:05PM +0800, Wanpeng Li wrote:
> From: Wanpneg Li <liwp@linux.vnet.ibm.com>
> 
> Since bdi_update_bandwidth function  should estimate write bandwidth at 200ms intervals,
> so the time is bdi->bw_time_stamp + BANDWIDTH_INTERVAL == jiffies, but
> if use time_is_after_eq_jiffies intervals will be bdi->bw_time_stamp +
> BANDWIDTH_INTERVAL + 1.
> 
> Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
> ---
>  mm/page-writeback.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index c833bf0..099e225 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1032,7 +1032,7 @@ static void bdi_update_bandwidth(struct backing_dev_info *bdi,
>  				 unsigned long bdi_dirty,
>  				 unsigned long start_time)
>  {
> -	if (time_is_after_eq_jiffies(bdi->bw_time_stamp + BANDWIDTH_INTERVAL))
> +	if (time_is_after_jiffies(bdi->bw_time_stamp + BANDWIDTH_INTERVAL))
>  		return;
>  	spin_lock(&bdi->wb.list_lock);
>  	__bdi_update_bandwidth(bdi, thresh, bg_thresh, dirty,
> -- 
> 1.7.9.5
