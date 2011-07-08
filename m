Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1GHGWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 02:22:17 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:34252 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247Ab1GHGWQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 02:22:16 -0400
From: Sachin Sanap <ssanap@marvell.com>
To: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
CC: "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Zhangfei Gao <zgao6@marvell.com>, Philip Rakity <prakity@marvell.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 7 Jul 2011 23:20:03 -0700
Subject: RE: [047/107] pxa168_eth: fix race in transmit path.
Thread-Topic: [047/107] pxa168_eth: fix race in transmit path.
Thread-Index: Acw9LE212VXjZKrBS3CO5TA/iBmIrwACrH9A
Message-ID: <EC64E4604C8024438259B683BB2514E1085C4A9142@SC-VEXCH1.marvell.com>
In-Reply-To: <20110708001657.257533921@clark.kroah.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK.

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, July 08, 2011 5:46 AM
> To: linux-kernel@vger.kernel.org; stable@kernel.org
> Cc: stable-review@kernel.org; torvalds@linux-foundation.org; akpm@linux-
> foundation.org; alan@lxorguk.ukuu.org.uk; Sachin Sanap; Zhangfei Gao;
> Philip Rakity; Richard Cochran; Eric Dumazet; David S. Miller
> Subject: [047/107] pxa168_eth: fix race in transmit path.
> 
> 2.6.39-stable review patch.  If anyone has any objections, please let us
> know.
> 
> ------------------
> 
> From: Richard Cochran <richardcochran@gmail.com>
> 
> commit 384420409d9b5d4443940abace49363d26135412 upstream.
> 
> Because the socket buffer is freed in the completion interrupt, it is not
> safe to access it after submitting it to the hardware.
> 
> Cc: Sachin Sanap <ssanap@marvell.com>
> Cc: Zhangfei Gao <zgao6@marvell.com>
> Cc: Philip Rakity <prakity@marvell.com>
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/net/pxa168_eth.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/net/pxa168_eth.c
> +++ b/drivers/net/pxa168_eth.c
> @@ -1273,7 +1273,7 @@ static int pxa168_eth_start_xmit(struct
>  	wmb();
>  	wrl(pep, SDMA_CMD, SDMA_CMD_TXDH | SDMA_CMD_ERD);
> 
> -	stats->tx_bytes += skb->len;
> +	stats->tx_bytes += length;
>  	stats->tx_packets++;
>  	dev->trans_start = jiffies;
>  	if (pep->tx_ring_size - pep->tx_desc_count <= 1) {
> 

