Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab0JYNYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 09:24:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50898 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab0JYNYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 09:24:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OCKf7Rj6uaWZsPI8nrRanJI9OkhAckBxfO4BG/jelSiteqcfSLiTTPqZUkxZBVaXc4
         /uKboYEoVsZDNrVPY3Wx/BYGXFfO5bsZnS1biJ+WEaESzKBWypmATMxGZKZz1Myg8DT9
         5F1gR+64DU4hjRa6lko6q0Mp99xMVZ/02CP0s=
Message-ID: <4CC5851D.1040204@lwfinger.net>
Date: Mon, 25 Oct 2010 08:24:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Serafeim Zanikolas <sez@debian.org>
CC: herton@mandriva.com.br, htl10@users.sourceforge.net,
        linville@tuxdriver.com, joe@perches.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: rtl818x: request DMA-able memory
References: <1287952327-9924-1-git-send-email-sez@debian.org>
In-Reply-To: <1287952327-9924-1-git-send-email-sez@debian.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2010 03:32 PM, Serafeim Zanikolas wrote:
> Despite the indicated intention in comment, the kmalloc() call was not
> explicitly requesting memory from ZONE_DMA.
> 
> Signed-off-by: Serafeim Zanikolas <sez@debian.org>
> ---
>  drivers/net/wireless/rtl818x/rtl8187_dev.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> index 38fa824..771794d 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -1343,7 +1343,8 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
>  	priv->is_rtl8187b = (id->driver_info == DEVICE_RTL8187B);
>  
>  	/* allocate "DMA aware" buffer for register accesses */
> -	priv->io_dmabuf = kmalloc(sizeof(*priv->io_dmabuf), GFP_KERNEL);
> +	priv->io_dmabuf = kmalloc(sizeof(*priv->io_dmabuf),
> +				  GFP_DMA | GFP_KERNEL);
>  	if (!priv->io_dmabuf) {
>  		err = -ENOMEM;
>  		goto err_free_dev;

ACK.

Larry

