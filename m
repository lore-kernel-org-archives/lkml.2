Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab1C3NTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:19:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab1C3NTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:19:42 -0400
Date: Wed, 30 Mar 2011 09:19:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com
Subject: Re: [PATCH] blk-throttle: don't call xchg on bool
Message-ID: <20110330131936.GA1291@redhat.com>
References: <1292447255-10698-1-git-send-email-vgoyal@redhat.com>
 <1292447255-10698-3-git-send-email-vgoyal@redhat.com>
 <m21v1ph639.fsf_-_@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m21v1ph639.fsf_-_@igel.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 01:14:50AM +0200, Andreas Schwab wrote:
> xchg does not work portably with smaller than 32bit types.
> 

Hi Andreas,

Which arch creates the problem and what's the issue here if data type
is smaller than 32bit? Is it a compile time warning?

Also, you also probably need to chagne ->limits_changed assignments?
Instead of using true/false use 1/0.

Thanks
Vivek

> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> ---
>  block/blk-throttle.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 5352bda..6c98cfe 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -77,7 +77,7 @@ struct throtl_grp {
>  	unsigned long slice_end[2];
>  
>  	/* Some throttle limits got updated for the group */
> -	bool limits_changed;
> +	int limits_changed;
>  };
>  
>  struct throtl_data
> @@ -102,7 +102,7 @@ struct throtl_data
>  	/* Work for dispatching throttled bios */
>  	struct delayed_work throtl_work;
>  
> -	bool limits_changed;
> +	int limits_changed;
>  };
>  
>  enum tg_state_flags {
> -- 
> 1.7.4.2
> 
> 
> -- 
> Andreas Schwab, schwab@linux-m68k.org
> GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
> "And now for something completely different."
