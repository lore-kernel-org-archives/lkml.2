Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab1IJFlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 01:41:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40944 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751537Ab1IJFlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 01:41:36 -0400
Subject: Re: [PATCH 1/2] staging: et131x: Fix checkpatch whitespace warnings
From: Joe Perches <joe@perches.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com
Date: Fri, 09 Sep 2011 22:41:35 -0700
In-Reply-To: <1315050547-4781-1-git-send-email-mark.einon@gmail.com>
References: <1315050547-4781-1-git-send-email-mark.einon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1315633296.23777.32.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-09-03 at 12:49 +0100, Mark Einon wrote:
> Some of my previous hacking attempts have not been following the rules.
> All fixes either lines > 80 chars or whitespace corrections (spaces->tabs etc).
[]
> diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
> index ab85cb3..36f2168 100644
> --- a/drivers/staging/et131x/et1310_mac.c
> +++ b/drivers/staging/et131x/et1310_mac.c
> @@ -191,7 +191,8 @@ void et1310_config_mac_regs2(struct et131x_adapter *adapter)
>  	cfg1 |= CFG1_RX_ENABLE | CFG1_TX_ENABLE | CFG1_TX_FLOW;
>  	/* Initialize loop back to off */
>  	cfg1 &= ~(CFG1_LOOPBACK | CFG1_RX_FLOW);
> -	if (adapter->flowcontrol == FLOW_RXONLY || adapter->flowcontrol == FLOW_BOTH)
> +	if (adapter->flowcontrol == FLOW_RXONLY ||
> +				adapter->flowcontrol == FLOW_BOTH)

Especially in cases like this, it helps readability
to align to open parenthesis like:

	if (adapter->flowcontrol == FLOW_RXONLY ||
	    adapter->flowcontrol == FLOW_BOTH)

[]
> @@ -641,7 +641,8 @@ static inline void free_send_packet(struct et131x_adapter *adapter,
>  		 * they point to
>  		 */
>  		do {
> -			desc = (struct tx_desc *)(adapter->tx_ring.tx_desc_ring +
> +			desc = (struct tx_desc *)
> +				    (adapter->tx_ring.tx_desc_ring +
>  						INDEX10(tcb->index_start));

Isn't this an unnecessary cast?
Perhaps it's better as:

			u32 i10 = INDEX10(tcb->index_start);

			desc = &adapter->tx_ring.tx_desc_ring[i10];


