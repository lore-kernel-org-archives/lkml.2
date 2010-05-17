Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab0EQQff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:35:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab0EQQfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:35:31 -0400
Subject: Re: [PATCH 1/37] drivers/net/wireless/libertas: Use kmemdup
From: Dan Williams <dcbw@redhat.com>
To: Julia Lawall <julia@diku.dk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1005152312060.21345@ask.diku.dk>
References: <Pine.LNX.4.64.1005152312060.21345@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 09:35:17 -0700
Message-ID: <1274114117.2382.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-15 at 23:12 +0200, Julia Lawall wrote:
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

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_usb.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff -u -p a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c
> @@ -618,16 +618,14 @@ static void if_usb_receive_fwload(struct
>  		return;
>  	}
>  
> -	syncfwheader = kmalloc(sizeof(struct fwsyncheader), GFP_ATOMIC);
> +	syncfwheader = kmemdup(skb->data + IPFIELD_ALIGN_OFFSET,
> +			       sizeof(struct fwsyncheader), GFP_ATOMIC);
>  	if (!syncfwheader) {
>  		lbs_deb_usbd(&cardp->udev->dev, "Failure to allocate syncfwheader\n");
>  		kfree_skb(skb);
>  		return;
>  	}
>  
> -	memcpy(syncfwheader, skb->data + IPFIELD_ALIGN_OFFSET,
> -	       sizeof(struct fwsyncheader));
> -
>  	if (!syncfwheader->cmd) {
>  		lbs_deb_usb2(&cardp->udev->dev, "FW received Blk with correct CRC\n");
>  		lbs_deb_usb2(&cardp->udev->dev, "FW received Blk seqnum = %d\n",


