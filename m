Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab1HaRLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 13:11:24 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:32115 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab1HaRLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 13:11:21 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzEuK2RGvY=
X-RZG-CLASS-ID: mo00
Message-ID: <4E5E6B32.8040902@hartkopp.net>
Date: Wed, 31 Aug 2011 19:11:14 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110820 Icedove/3.1.12
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Urs Thuermann <urs.thuermann@volkswagen.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/24] can: Remove unnecessary OOM logging messages
References: <cover.1314650069.git.joe@perches.com> <d2773db0709a09bfe6d43a28ba1323c5d3f9a76b.1314650069.git.joe@perches.com>
In-Reply-To: <d2773db0709a09bfe6d43a28ba1323c5d3f9a76b.1314650069.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.08.2011 23:17, Joe Perches wrote:

> Removing unnecessary messages saves code and text.
> 
> Site specific OOM messages are duplications of a generic MM
> out of memory message and aren't really useful, so just
> delete them.
> 
> Signed-off-by: Joe Perches <joe@perches.com>


Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Tnx Joe.

> ---
>  net/can/af_can.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index b9efa94..11300be 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -770,11 +770,9 @@ static int can_notifier(struct notifier_block *nb, unsigned long msg,
>  
>  		/* create new dev_rcv_lists for this device */
>  		d = kzalloc(sizeof(*d), GFP_KERNEL);
> -		if (!d) {
> -			printk(KERN_ERR
> -			       "can: allocation of receive list failed\n");
> +		if (!d)
>  			return NOTIFY_DONE;
> -		}
> +
>  		BUG_ON(dev->ml_priv);
>  		dev->ml_priv = d;
>  


