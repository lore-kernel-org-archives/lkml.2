Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2CIMV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:21:57 -0500
Received: from mga14.intel.com ([143.182.124.37]:11271 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab2CIMVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:21:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="75552500"
Date: Fri, 9 Mar 2012 14:21:58 +0200
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: marcel@holtmann.org, padovan@profusion.mobi, davem@davemloft.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: Resend: [PATCH] Bluetooth: Fix Endian Bug.
Message-ID: <20120309122154.GA17167@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	santosh nayak <santoshprasadnayak@gmail.com>, marcel@holtmann.org,
	padovan@profusion.mobi, davem@davemloft.net,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1330622196-12967-1-git-send-email-santoshprasadnayak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330622196-12967-1-git-send-email-santoshprasadnayak@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 10:46:36PM +0530, santosh nayak wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Fix network to host endian conversion for L2CAP chan id.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>

Acked-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

> ---
>  net/bluetooth/l2cap_sock.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> index 401d942..86d5067 100644
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -82,7 +82,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
>  	}
>  
>  	if (la.l2_cid)
> -		err = l2cap_add_scid(chan, la.l2_cid);
> +		err = l2cap_add_scid(chan, __le16_to_cpu(la.l2_cid));
>  	else
>  		err = l2cap_add_psm(chan, &la.l2_bdaddr, la.l2_psm);
>  
> @@ -123,7 +123,8 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr, int al
>  	if (la.l2_cid && la.l2_psm)
>  		return -EINVAL;
>  
> -	err = l2cap_chan_connect(chan, la.l2_psm, la.l2_cid, &la.l2_bdaddr);
> +	err = l2cap_chan_connect(chan, la.l2_psm, __le16_to_cpu(la.l2_cid),
> +				&la.l2_bdaddr);
>  	if (err)
>  		goto done;
>  
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
