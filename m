Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2FHS5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:57:04 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:46566 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab2FHS5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:57:00 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jun 2012 14:57:00 EDT
Date: Fri, 8 Jun 2012 20:50:08 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        drbd-user@lists.linbit.com
Subject: Re: [DRBD-user] [patch -resend] drbd: fix resync_dump_detail() output
Message-ID: <20120608185008.GC8030@soda.linbit>
Mail-Followup-To: Dan Carpenter <dan.carpenter@oracle.com>,
	Lars Ellenberg <drbd-dev@lists.linbit.com>,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-user@lists.linbit.com
References: <20120608123128.GA18293@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608123128.GA18293@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 03:31:28PM +0300, Dan Carpenter wrote:
> The tests here aren't correct.  It should be doing a shift before doing
> the bitwise AND.  (bme->flags & BME_NO_WRITES) is always false and
> (bme->flags & BME_LOCKED) checks for BME_NO_WRITES instead of checking
> for locked.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Ack.

> ---
> I sent this to the drbd-user list in March, but never recieved a
> response.

Sorry, seems to have been lost :-(

	Lars

> diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
> index 2959cdf..ffe1ee4 100644
> --- a/drivers/block/drbd/drbd_proc.c
> +++ b/drivers/block/drbd/drbd_proc.c
> @@ -187,8 +187,10 @@ static void resync_dump_detail(struct seq_file *seq, struct lc_element *e)
>  	struct bm_extent *bme = lc_entry(e, struct bm_extent, lce);
>  
>  	seq_printf(seq, "%5d %s %s\n", bme->rs_left,
> -		   bme->flags & BME_NO_WRITES ? "NO_WRITES" : "---------",
> -		   bme->flags & BME_LOCKED ? "LOCKED" : "------"
> +		   test_bit(BME_NO_WRITES, &bme->flags) ?
> +			"NO_WRITES" : "---------",
> +		   test_bit(BME_LOCKED, &bme->flags) ?
> +			"LOCKED" : "------"
>  		   );
>  }

-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com
