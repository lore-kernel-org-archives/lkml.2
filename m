Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab1KNFmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:42:18 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59465 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1KNFmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:42:17 -0500
Message-ID: <4EC0AA31.9040403@gmail.com>
Date: Mon, 14 Nov 2011 16:42:09 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Changli Gao <xiaosuo@gmail.com>,
        Ben Greear <greearb@candelatech.com>,
        Chetan Loke <loke.chetan@gmail.com>, waltje@uWalt.NL.Mugnet.ORG,
        gw4pts@gw4pts.ampr.org, waltje@linux.com, ross.biro@gmail.com,
        alan@linux.intel.com
Subject: Re: [PATCH] net/packet: remove dead code and unneeded variable from
 prb_setup_retire_blk_timer()
References: <alpine.LNX.2.00.1111132247440.3368@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1111132247440.3368@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/11 08:55, Jesper Juhl wrote:

> We test for 'tx_ring' being != zero and BUG() if that's the case. So after
> that check there is no way that 'tx_ring' could be anything _but_ zero, so
> testing it again is just dead code. Once that dead code is removed, the
> 'pkc' local variable becomes entirely redundant, so remove that as well.


What if CONFIG_BUG=n?

~Ryan

 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  net/packet/af_packet.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
>  only compile tested.
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 82a6f34..ab10e84 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -516,13 +516,11 @@ static void prb_init_blk_timer(struct packet_sock *po,
>  
>  static void prb_setup_retire_blk_timer(struct packet_sock *po, int tx_ring)
>  {
> -	struct tpacket_kbdq_core *pkc;
> -
>  	if (tx_ring)
>  		BUG();
>  
> -	pkc = tx_ring ? &po->tx_ring.prb_bdqc : &po->rx_ring.prb_bdqc;
> -	prb_init_blk_timer(po, pkc, prb_retire_rx_blk_timer_expired);
> +	prb_init_blk_timer(po, &po->rx_ring.prb_bdqc,
> +			   prb_retire_rx_blk_timer_expired);
>  }
>  
>  static int prb_calc_retire_blk_tmo(struct packet_sock *po,


