Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab2JGQNm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 12:13:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60366 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750746Ab2JGQNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 12:13:36 -0400
Message-ID: <1349626414.15802.2.camel@joe-AO722>
Subject: Re: [PATCH 2/5] mfd: tps65090: add error prints when mem alloc
 failed
From: Joe Perches <joe@perches.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        vbyravarasu@nvidia.com
Date: Sun, 07 Oct 2012 09:13:34 -0700
In-Reply-To: <1349623340-21807-3-git-send-email-ldewangan@nvidia.com>
References: <1349623340-21807-1-git-send-email-ldewangan@nvidia.com>
	 <1349623340-21807-3-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-07 at 20:52 +0530, Laxman Dewangan wrote:
> Add error prints when memory allocation failed for
> tps65090 data. Also cleanups the melloc arguments.

The new dev_err is unnecessary.
A dump_stack is already done on alloc failures.
The sizeof(* is ok.


> diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
[]
> @@ -263,10 +263,11 @@ static int __devinit tps65090_i2c_probe(struct i2c_client *client,
>  		return -EINVAL;
>  	}
>  
> -	tps65090 = devm_kzalloc(&client->dev, sizeof(struct tps65090),
> -		GFP_KERNEL);
> -	if (tps65090 == NULL)
> +	tps65090 = devm_kzalloc(&client->dev, sizeof(*tps65090), GFP_KERNEL);
> +	if (!tps65090) {
> +		dev_err(&client->dev, "mem alloc for tps65090 failed\n");
>  		return -ENOMEM;
> +	}



