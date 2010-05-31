Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0EaQ6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:58:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37849 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab0EaQ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:58:38 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C03EAAA.6050603@s5r6.in-berlin.de>
Date: Mon, 31 May 2010 18:58:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 12/27] drivers/ieee1394: Use memdup_user
References: <Pine.LNX.4.64.1005221021460.13021@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1005221021460.13021@ask.diku.dk>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote on 2010-05-22:
...
> --- a/drivers/ieee1394/video1394.c
> +++ b/drivers/ieee1394/video1394.c
> @@ -1045,14 +1045,9 @@ static long video1394_ioctl(struct file *file,
>  			if (get_user(qv, &p->packet_sizes))
>  				return -EFAULT;
>  
> -			psizes = kmalloc(buf_size, GFP_KERNEL);
> -			if (!psizes)
> -				return -ENOMEM;
> -
> -			if (copy_from_user(psizes, qv, buf_size)) {
> -				kfree(psizes);
> -				return -EFAULT;
> -			}
> +			psizes = memdup_user(qv, buf_size);
> +			if (IS_ERR(psizes))
> +				return PTR_ERR(psizes);
>  		}
>  
>  		spin_lock_irqsave(&d->lock,flags);

Committed to linux1394-2.6.git now, thanks.  (Because akpm said that it
is worth it regardless of video1394 being at its end of life.)
-- 
Stefan Richter
-=====-==-=- -=-= =====
http://arcgraph.de/sr/
