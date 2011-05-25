Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab1EYMss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:48:48 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:55485 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520Ab1EYMsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:48:35 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Wed, 25 May 2011 14:48:32 +0200
In-Reply-To: <4DDCC1E4.706@fusionio.com>
References: <20110519222404.GG12600@redhat.com>
			 <20110521210013.GJ2271@linux.vnet.ibm.com>
			 <20110523152141.GB4019@redhat.com>
			 <20110523153848.GC2310@linux.vnet.ibm.com>
		 <1306189249.15900.10.camel@t41.thuisdomein> <4DDB7D36.60905@fusionio.com>
	 <1306312155.9059.8.camel@t41.thuisdomein> <4DDCC1E4.706@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306327713.2785.2.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 10:46 +0200, Jens Axboe wrote:
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index ab7a9e6..f37e3df 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1827,6 +1827,7 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
>  static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
>  					      struct cfq_queue *cur_cfqq)
>  {
> +#if 0
>  	struct cfq_queue *cfqq;
>  
>  	if (cfq_class_idle(cur_cfqq))
> @@ -1870,6 +1871,9 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
>  		return NULL;
>  
>  	return cfqq;
> +#else
> +	return cfqq;

This won't compile, obviously. Did you perhaps mean

	return NULL;

here?

> +#endif
>  }
>  
>  /*


Paul Bolle

