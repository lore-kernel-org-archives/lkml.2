Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1H0ASy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 20:18:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754643Ab1H0ASx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 20:18:53 -0400
Date: Fri, 26 Aug 2011 17:18:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: jhbird.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, Donggeun Kim <dg77.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] driver/misc/fsa9480.c fix potential null-pointer
 dereference
Message-Id: <20110826171849.4f488908.akpm@linux-foundation.org>
In-Reply-To: <1311668375-24131-1-git-send-email-jhbird.choi@samsung.com>
References: <1311668375-24131-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011 17:19:35 +0900
jhbird.choi@samsung.com wrote:

> From: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/misc/fsa9480.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/fsa9480.c b/drivers/misc/fsa9480.c
> index 5325a7e..0bd1e5b 100644
> --- a/drivers/misc/fsa9480.c
> +++ b/drivers/misc/fsa9480.c
> @@ -400,7 +400,8 @@ static int fsa9480_irq_init(struct fsa9480_usbsw *usbsw)
>  			return ret;
>  		}
>  
> -		device_init_wakeup(&client->dev, pdata->wakeup);
> +		if (pdata)
> +			device_init_wakeup(&client->dev, pdata->wakeup);
>  	}
>  
>  	return 0;

So i2c_client.dev.platform_data was NULL.  Is this an allowed state? 
What would cause this?
