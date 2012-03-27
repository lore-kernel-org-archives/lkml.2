Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab2C0WUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:20:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63673 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2C0WUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:20:50 -0400
Date: Tue, 27 Mar 2012 15:20:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net/hyperv: Add flow control based on hi/low
 watermark
Message-ID: <20120327222045.GA469@kroah.com>
References: <1332886987-11613-1-git-send-email-haiyangz@microsoft.com>
 <1332886987-11613-2-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332886987-11613-2-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 03:23:07PM -0700, Haiyang Zhang wrote:
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -274,6 +274,35 @@ struct hv_ring_buffer_debug_info {
>  	u32 bytes_avail_towrite;
>  };
>  
> +/* Amount of space to write to */
> +#define BYTES_AVAIL_TO_WRITE(r, w, z) \
> +	(((w) >= (r)) ? ((z) - ((w) - (r))) : ((r) - (w)))
> +

That's a very bad #define to use in a .h file, please do not do that.

> +
> +/*
> + *
> + * hv_get_ringbuffer_availbytes()
> + *
> + * Get number of bytes available to read and to write to
> + * for the specified ring buffer
> + */
> +extern inline void
> +hv_get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
> +			  u32 *read, u32 *write)

What does "extern inline" mean?

Please fix.

greg k-h
