Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab2LCKL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:11:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab2LCKL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:11:57 -0500
Date: Mon, 3 Dec 2012 12:14:36 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, krkumar2@in.ibm.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bhutchings@solarflare.com, jwhan@filewood.snu.ac.kr, shiyer@redhat.com
Subject: Re: [net-next rfc v7 2/3] virtio_net: multiqueue support
Message-ID: <20121203101436.GB23009@redhat.com>
References: <1354011360-39479-1-git-send-email-jasowang@redhat.com>
 <1354011360-39479-3-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354011360-39479-3-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 06:15:59PM +0800, Jason Wang wrote:
> -	if (!try_fill_recv(&vi->rq, GFP_KERNEL))
> -		schedule_delayed_work(&vi->rq.refill, 0);
> +	for (i = 0; i < vi->max_queue_pairs; i++)
> +		if (!try_fill_recv(&vi->rq[i], GFP_KERNEL))
> +			schedule_delayed_work(&vi->rq[i].refill, 0);
>  
>  	mutex_lock(&vi->config_lock);
>  	vi->config_enable = true;
>  	mutex_unlock(&vi->config_lock);
>  
> +	BUG_ON(virtnet_set_queues(vi));
> +
>  	return 0;
>  }
>  #endif

Also crashing on device nack of command is also not nice.
In this case it seems we can just switch to
single-queue mode which should always be safe.
