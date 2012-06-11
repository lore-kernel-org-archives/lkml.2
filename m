Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab2FKIgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:36:50 -0400
Received: from antcom.de ([188.40.178.216]:41705 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab2FKIgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:36:49 -0400
Message-ID: <4FD5AE1D.9030807@antcom.de>
Date: Mon, 11 Jun 2012 10:36:45 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] net: lpc_eth: Replace WARN() trace with simple pr_warn()
References: <1339401793-12258-1-git-send-email-stigge@antcom.de> <1339403108.6001.1697.camel@edumazet-glaptop>
In-Reply-To: <1339403108.6001.1697.camel@edumazet-glaptop>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave and Eric,

thanks for your feedback!

On 06/11/2012 10:25 AM, Eric Dumazet wrote:
> On Mon, 2012-06-11 at 10:03 +0200, Roland Stigge wrote:
>> A WARN() trace indicating a "BUG!" was identified as a "normal" case in the
>> xmit function in case all TX descriptors are occupied already. In this case,
>> NETDEV_TX_BUSY is returned, nothing buggy at all.
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>> Tested-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
>>
>> ---
>>  drivers/net/ethernet/nxp/lpc_eth.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- linux-2.6.orig/drivers/net/ethernet/nxp/lpc_eth.c
>> +++ linux-2.6/drivers/net/ethernet/nxp/lpc_eth.c
>> @@ -1114,7 +1114,7 @@ static int lpc_eth_hard_start_xmit(struc
>>  		   buffers */
>>  		netif_stop_queue(ndev);
>>  		spin_unlock_irq(&pldat->lock);
>> -		WARN(1, "BUG! TX request when no free TX buffers!\n");
>> +		pr_warn("Note: TX request when no free TX buffers.\n");
>>  		return NETDEV_TX_BUSY;
>>  	}
>>  
> 
> Entering this path is a bug, don't hide it...
> 
> Please share with us how this bug was identified as a "normal case" ?

I encountered cases where this happened for me on a custom board under
heavy load.

I discussed this with Kevin Wells, the original driver author. We
identified the case of xmit()'s TX request (from .ndo_start_xmit) with
full TX driver buffers as valid when ethernet is busy.

But maybe this is wrong. Can you please give me a hint how the net
subsystem makes sure that this doesn't happen under normal circumstances?

Thanks in advance!

Roland
