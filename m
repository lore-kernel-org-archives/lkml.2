Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab0JZL6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 07:58:14 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:56705 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384Ab0JZL6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 07:58:12 -0400
Message-ID: <4CC6C252.7080905@bfs.de>
Date: Tue, 26 Oct 2010 13:58:10 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/14] drivers/net/sb1000.c: delete double assignment
References: <1288088743-3725-1-git-send-email-julia@diku.dk> <1288088743-3725-6-git-send-email-julia@diku.dk>
In-Reply-To: <1288088743-3725-6-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Julia Lawall schrieb:
> From: Julia Lawall <julia@diku.dk>
> 
> The other code around these duplicated assignments initializes the 0 1 2
> and 3 elements of an array, so change the initialization of the
> rx_session_id array to do the same.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression i;
> @@
> 
> *i = ...;
>  i = ...;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> This changes the semantics and has not been tested.
> 
>  drivers/net/sb1000.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
> index a9ae505..66c2f1a 100644
> --- a/drivers/net/sb1000.c
> +++ b/drivers/net/sb1000.c
> @@ -961,9 +961,9 @@ sb1000_open(struct net_device *dev)
>  	lp->rx_error_count = 0;
>  	lp->rx_error_dpc_count = 0;
>  	lp->rx_session_id[0] = 0x50;
> -	lp->rx_session_id[0] = 0x48;
> -	lp->rx_session_id[0] = 0x44;
> -	lp->rx_session_id[0] = 0x42;
> +	lp->rx_session_id[1] = 0x48;
> +	lp->rx_session_id[2] = 0x44;
> +	lp->rx_session_id[3] = 0x42;
>  	lp->rx_frame_id[0] = 0;
>  	lp->rx_frame_id[1] = 0;
>  	lp->rx_frame_id[2] = 0;
> 

/me is surprised that this did not cause more problems.
Is it needed at all ?

re,
 wh

