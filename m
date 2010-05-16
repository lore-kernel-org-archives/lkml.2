Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139Ab0EPExN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 00:53:13 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:40867 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab0EPExL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 00:53:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F53lgxUx8Cieo8KAddLHMDO4D/J4YHhgXTYDkHxYi4Fg5ZyicVQsK1mZeI+gY3q8as
         JkBHw4AyXGMXcfrvPY4D8Nh4oMOgHRkYm3CCj2klJnZHCdDreLj0HvPywciKw1ZbGl+9
         Bqd7XAeMchVUxkT3i4bcEHEnDcqzkjeUx+hDw=
Date: Sun, 16 May 2010 01:53:31 -0300
From: "Gustavo F. Padovan" <gustavo@padovan.org>
To: Julia Lawall <julia@diku.dk>
Cc: Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 20/37] drivers/bluetooth: Use kmemdup
Message-ID: <20100516045331.GA25105@vigoh>
References: <Pine.LNX.4.64.1005152318590.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005152318590.21345@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Julia Lawall <julia@diku.dk> [2010-05-15 23:19:15 +0200]:

> From: Julia Lawall <julia@diku.dk>
> 
> Use kmemdup when some other buffer is immediately copied into the
> allocated region.
> 
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression from,to,size,flag;
> statement S;
> @@
> 
> -  to = \(kmalloc\|kzalloc\)(size,flag);
> +  to = kmemdup(from,size,flag);
>    if (to==NULL || ...) S
> -  memcpy(to, from, size);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/bluetooth/bcm203x.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff -u -p a/drivers/bluetooth/bcm203x.c b/drivers/bluetooth/bcm203x.c
> --- a/drivers/bluetooth/bcm203x.c
> +++ b/drivers/bluetooth/bcm203x.c
> @@ -224,7 +224,7 @@ static int bcm203x_probe(struct usb_inte
>  
>  	BT_DBG("firmware data %p size %zu", firmware->data, firmware->size);
>  
> -	data->fw_data = kmalloc(firmware->size, GFP_KERNEL);
> +	data->fw_data = kmemdup(firmware->data, firmware->size, GFP_KERNEL);
>  	if (!data->fw_data) {
>  		BT_ERR("Can't allocate memory for firmware image");
>  		release_firmware(firmware);
> @@ -234,7 +234,6 @@ static int bcm203x_probe(struct usb_inte
>  		return -ENOMEM;
>  	}
>  
> -	memcpy(data->fw_data, firmware->data, firmware->size);
>  	data->fw_size = firmware->size;
>  	data->fw_sent = 0;


Acked-by: Gustavo F. Padovan <padovan@profusion.mobi>

-- 
Gustavo F. Padovan
http://padovan.org
