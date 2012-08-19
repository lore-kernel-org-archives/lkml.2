Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab2HSCSC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:18:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:5628 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab2HSCSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:18:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="204888263"
Date: Sun, 19 Aug 2012 10:17:57 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: fix incorrect return value type of
 bdi_dirty_limit
Message-ID: <20120819021757.GB16796@localhost>
References: <1345283361-7802-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345283361-7802-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 05:49:21AM -0400, Namjae Jeon wrote:
> unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long dirty)
> 
> Above function return type is unsigned long, but return value is
> kept in "u64 bdi_dirty".
> It can return incorrect value by type casting.

I don't see how the cast can return wrong value.
The u64 is necessary for the intermediate calculations.

Thanks,
Fengguang

> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> ---
>  mm/page-writeback.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 49133b6..73a7a06 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -546,7 +546,7 @@ static unsigned long hard_dirty_limit(unsigned long thresh)
>   */
>  unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long dirty)
>  {
> -	u64 bdi_dirty;
> +	unsigned long bdi_dirty;
>  	long numerator, denominator;
>  
>  	/*
> -- 
> 1.7.9.5
