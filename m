Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab0C2Tbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 15:31:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53836 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab0C2Tbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 15:31:31 -0400
Message-ID: <4BB10010.5060505@mathtm.de>
Date: Mon, 29 Mar 2010 21:31:28 +0200
From: =?UTF-8?B?VGhvbWFzIE3DvGxsZXI=?= <thomas@mathtm.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Shirley Ma <mashirle@us.ibm.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH next-next-2.6] virtio_net: missing sg_init_table
References: <1269887518.13277.13.camel@localhost.localdomain>
In-Reply-To: <1269887518.13277.13.camel@localhost.localdomain>
X-Enigmail-Version: 1.0.1
OpenPGP: id=E514BAAF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1+0UVkKRdwe+7D0onvMtKjJnyS5M06akkHB1f3
 J2/sIvtIte0bzJiyLQY7UPfgRuL9dYjW7UZ2bVe0tq1XTIKpN3
 5kS5DSjJMm3otS2eAvwfrgl5/Sdxen0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.03.2010 20:31, schrieb Shirley Ma:
> Add missing sg_init_table for sg_set_buf in virtio_net.
> 
> Reported-by: Thomas Müller <thomas@mathtm.de>
> Signed-off-by: Shirley Ma <xma@us.ibm.com>

I've just tested the patch and it works fine, so I guess you can add a
Tested-by: Thomas Müller <thomas@mathtm.de>
line, if you like.

Thanks,
Thomas


> ---
>  drivers/net/virtio_net.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 25dc77c..3f5be35 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -326,6 +326,7 @@ static int add_recvbuf_small(struct virtnet_info *vi, gfp_t gfp)
>  	struct scatterlist sg[2];
>  	int err;
>  
> +	sg_init_table(sg, 2);
>  	skb = netdev_alloc_skb_ip_align(vi->dev, MAX_PACKET_LEN);
>  	if (unlikely(!skb))
>  		return -ENOMEM;
> @@ -351,6 +352,7 @@ static int add_recvbuf_big(struct virtnet_info *vi, gfp_t gfp)
>  	char *p;
>  	int i, err, offset;
>  
> +	sg_init_table(sg, MAX_SKB_FRAGS + 2);
>  	/* page in sg[MAX_SKB_FRAGS + 1] is list tail */
>  	for (i = MAX_SKB_FRAGS + 1; i > 1; --i) {
>  		first = get_a_page(vi, gfp);
> 
> 
