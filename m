Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0EPXBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 19:01:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:41799 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0EPXBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 19:01:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,243,1272870000"; 
   d="scan'208";a="567683413"
Date: Mon, 17 May 2010 01:01:36 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Julia Lawall <julia@diku.dk>
Cc: "Zhu, Yi" <yi.zhu@intel.com>, Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 13/37] drivers/net/wireless/iwmc3200wifi: Use kmemdup
Message-ID: <20100516230135.GA3112@sortiz.org>
References: <Pine.LNX.4.64.1005152316400.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005152316400.21345@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 15, 2010 at 10:16:58PM +0100, Julia Lawall wrote:
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
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.
 
> ---
>  drivers/net/wireless/iwmc3200wifi/rx.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -u -p a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
> --- a/drivers/net/wireless/iwmc3200wifi/rx.c
> +++ b/drivers/net/wireless/iwmc3200wifi/rx.c
> @@ -321,14 +321,14 @@ iwm_rx_ticket_node_alloc(struct iwm_priv
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> -	ticket_node->ticket = kzalloc(sizeof(struct iwm_rx_ticket), GFP_KERNEL);
> +	ticket_node->ticket = kmemdup(ticket, sizeof(struct iwm_rx_ticket),
> +				      GFP_KERNEL);
>  	if (!ticket_node->ticket) {
>  		IWM_ERR(iwm, "Couldn't allocate RX ticket\n");
>  		kfree(ticket_node);
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> -	memcpy(ticket_node->ticket, ticket, sizeof(struct iwm_rx_ticket));
>  	INIT_LIST_HEAD(&ticket_node->node);
>  
>  	return ticket_node;

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

