Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1HCPyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 11:54:37 -0400
Received: from www17.your-server.de ([213.133.104.17]:58363 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab1HCPyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:54:35 -0400
Subject: Re: [PATCH 8/20] drivers/parport: Use kzalloc
From: Thomas Meyer <thomas@m3y3r.de>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Wed, 03 Aug 2011 17:54:04 +0200
In-Reply-To: <Pine.LNX.4.64.1005132200410.6282@ask.diku.dk>
References: <Pine.LNX.4.64.1005132200410.6282@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312386848.2629.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 13.05.2010, 22:01 +0200 schrieb Julia Lawall:

> From: Julia Lawall <julia@diku.dk>
> 
> Use kzalloc rather than the combination of kmalloc and memset.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,size,flags;
> statement S;
> @@
> 
> -x = kmalloc(size,flags);
> +x = kzalloc(size,flags);
>  if (x == NULL) S
> -memset(x, 0, size);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Reviewed-by: Thomas Meyer <thomas@m3y3r.de>

> 
> ---
>  drivers/parport/share.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff -u -p a/drivers/parport/share.c b/drivers/parport/share.c
> --- a/drivers/parport/share.c
> +++ b/drivers/parport/share.c
> @@ -282,14 +282,13 @@ struct parport *parport_register_port(un
>  	int device;
>  	char *name;
>  
> -	tmp = kmalloc(sizeof(struct parport), GFP_KERNEL);
> +	tmp = kzalloc(sizeof(struct parport), GFP_KERNEL);
>  	if (!tmp) {
>  		printk(KERN_WARNING "parport: memory squeeze\n");
>  		return NULL;
>  	}
>  
>  	/* Init our structure */
> - 	memset(tmp, 0, sizeof(struct parport));
>  	tmp->base = base;
>  	tmp->irq = irq;
>  	tmp->dma = dma;



