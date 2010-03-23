Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab0CWGPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 02:15:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826Ab0CWGPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 02:15:51 -0400
Date: Mon, 22 Mar 2010 23:14:41 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Julia Lawall <julia@diku.dk>
Cc: Mark McClelland <mmcclell@bigfoot.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/media/video: avoid NULL dereference
Message-Id: <20100322231441.b7e33bf9.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.1003212230380.12371@ask.diku.dk>
References: <Pine.LNX.4.64.1003212230380.12371@ask.diku.dk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010 22:31:06 +0100 (CET) Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> If ov is NULL, it will not be possible to take the lock in the first place,
> so move the test up earlier.
> 
> ...
>
> --- a/drivers/media/video/ov511.c
> +++ b/drivers/media/video/ov511.c
> @@ -5913,14 +5913,12 @@ ov51x_disconnect(struct usb_interface *intf)
>  
>  	PDEBUG(3, "");
>  
> +	if (!ov)
> +		return;
> +
>  	mutex_lock(&ov->lock);
>  	usb_set_intfdata (intf, NULL);
>  
> -	if (!ov) {
> -		mutex_unlock(&ov->lock);
> -		return;
> -	}
> -
>  	/* Free device number */
>  	ov511_devused &= ~(1 << ov->nr);

I think we can pretty safely assume that we never get here with ov==NULL.

Oh well, I'll leave the test there for others to ponder.
