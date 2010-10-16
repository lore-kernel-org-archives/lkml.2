Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0JPJv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 05:51:56 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:43270 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936Ab0JPJvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 05:51:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHMRuUx5LcB2gWdsb2JhbAChMRgWIiK8c4VJBI9K
Date: Sat, 16 Oct 2010 20:51:50 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/19] kernel: add bl_list
Message-ID: <20101016095150.GA7142@amd>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287216853-17634-3-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 07:13:56PM +1100, Dave Chinner wrote:
> From: Nick Piggin <npiggin@suse.de>
> +/**
> + * hlist_bl_lock	- lock a hash list
> + * @h:	hash list head to lock
> + */
> +static inline void hlist_bl_lock(struct hlist_bl_head *h)
> +{
> +	bit_spin_lock(0, (unsigned long *)h);
> +}
> +
> +/**
> + * hlist_bl_unlock	- unlock a hash list
> + * @h:	hash list head to unlock
> + */
> +static inline void hlist_bl_unlock(struct hlist_bl_head *h)
> +{
> +	__bit_spin_unlock(0, (unsigned long *)h);
> +}

I don't know why Christoph asked for these; he's usually against
obfuscating wrapper functions.

bit_spin_lock is fine in callers so please leave it at that.
Other users may not want a spinlock, or might want to use
bit_spin_is_locked, bit_spin_trylock etc.


> diff --git a/include/linux/poison.h b/include/linux/poison.h
> index 2110a81..d367d39 100644
> --- a/include/linux/poison.h
> +++ b/include/linux/poison.h
> @@ -22,6 +22,8 @@
>  #define LIST_POISON1  ((void *) 0x00100100 + POISON_POINTER_DELTA)
>  #define LIST_POISON2  ((void *) 0x00200200 + POISON_POINTER_DELTA)
>  
> +#define BL_LIST_POISON1  ((void *) 0x00300300 + POISON_POINTER_DELTA)
> +#define BL_LIST_POISON2  ((void *) 0x00400400 + POISON_POINTER_DELTA)
>  /********** include/linux/timer.h **********/
>  /*
>   * Magic number "tsta" to indicate a static timer initializer

I don't see the point of this, but if there is one it should be
documented in a different patch and propagated to other types of
lists too. I wouldn't worry about it though.

