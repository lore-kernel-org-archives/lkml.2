Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2HAHlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 03:41:23 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3170 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab2HAHlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 03:41:21 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <1343806877.834.3.camel@lb-tlvb-dmitry.il.broadcom.com>
Subject: Re: [PATCH] bnx2x: fix mem leak when command is unknown
From: "Dmitry Kravkov" <dmitry@broadcom.com>
To: "Jesper Juhl" <jj@chaosbits.net>
cc: "Eilon Greenstein" <eilong@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 1 Aug 2012 10:41:17 +0300
In-Reply-To: <alpine.LNX.2.00.1207312337590.7100@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1207312337590.7100@swampdragon.chaosbits.net>
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-Version: 1.0
X-WSS-ID: 7C0602DD3NK10831140-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 23:39 +0200, Jesper Juhl wrote:
> In bnx2x_mcast_enqueue_cmd() we'll leak the memory allocated to
> 'new_cmd' if we hit the deafault case of the 'switch (cmd)'.
> Add a 'kfree(new_cmd)' to that case to avoid the leak.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
>   note: due to lack of hardware this patch is compile tested only.
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
> index 734fd87..62f754b 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
> @@ -2485,6 +2485,7 @@ static int bnx2x_mcast_enqueue_cmd(struct bnx2x *bp,
>  		break;
>  
>  	default:
> +		kfree(new_cmd);
>  		BNX2X_ERR("Unknown command: %d\n", cmd);
>  		return -EINVAL;
>  	}
> -- 
> 1.7.11.3
> 
Thanks a lot, Jesper.

Acked-by: Dmitry Kravkov <dmitry@broadcom.com>
> 



