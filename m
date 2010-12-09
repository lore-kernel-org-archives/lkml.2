Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab0LIDch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:32:37 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:25178 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab0LIDcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:32:35 -0500
Subject: Re: [PATCH 6/7] e1000e: cleanup: swap arguments to avoid
 checkpatch errors
From: Ben Hutchings <bhutchings@solarflare.com>
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291862457-16671-7-git-send-email-asbjorn@asbjorn.biz>
References: <1291862457-16671-1-git-send-email-asbjorn@asbjorn.biz>
	 <1291862457-16671-7-git-send-email-asbjorn@asbjorn.biz>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Thu, 09 Dec 2010 03:32:28 +0000
Message-ID: <1291865548.19763.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Dec 2010 03:32:34.0783 (UTC) FILETIME=[B825EEF0:01CB9751]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17816.005
X-TM-AS-Result: No--14.079800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 02:40 +0000, Asbjoern Sloth Toennesen wrote:
> Swap argument order in order to avoid checkpatch treating it as an
> unary operation, instead of an binary one, and obtain consistency
> with the 3 other similar assignments in netdev.c (tdlen & rdlen).
> 
> This patch fixes 3 checkpatch errors.

You have got to be kidding.  If the checkpatch warning offends you, fix
the bug in checkpatch instead of changing perfectly good code.

Ben.

> Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
> ---
>  drivers/net/e1000e/netdev.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
> index bb6a1f5..bdd3774 100644
> --- a/drivers/net/e1000e/netdev.c
> +++ b/drivers/net/e1000e/netdev.c
> @@ -2059,7 +2059,7 @@ int e1000e_setup_tx_resources(struct e1000_adapter *adapter)
>  	struct e1000_ring *tx_ring = adapter->tx_ring;
>  	int err = -ENOMEM, size;
>  
> -	size = sizeof(struct e1000_buffer) * tx_ring->count;
> +	size = tx_ring->count * sizeof(struct e1000_buffer);
>  	tx_ring->buffer_info = vzalloc(size);
>  	if (!tx_ring->buffer_info)
>  		goto err;
> @@ -2094,7 +2094,7 @@ int e1000e_setup_rx_resources(struct e1000_adapter *adapter)
>  	struct e1000_buffer *buffer_info;
>  	int i, size, desc_len, err = -ENOMEM;
>  
> -	size = sizeof(struct e1000_buffer) * rx_ring->count;
> +	size = rx_ring->count * sizeof(struct e1000_buffer);
>  	rx_ring->buffer_info = vzalloc(size);
>  	if (!rx_ring->buffer_info)
>  		goto err;
> @@ -2151,7 +2151,7 @@ static void e1000_clean_tx_ring(struct e1000_adapter *adapter)
>  		e1000_put_txbuf(adapter, buffer_info);
>  	}
>  
> -	size = sizeof(struct e1000_buffer) * tx_ring->count;
> +	size = tx_ring->count * sizeof(struct e1000_buffer);
>  	memset(tx_ring->buffer_info, 0, size);
>  
>  	memset(tx_ring->desc, 0, tx_ring->size);

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

