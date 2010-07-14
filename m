Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab0GNVLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:11:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53654
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757423Ab0GNVLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:11:03 -0400
Date: Wed, 14 Jul 2010 14:11:18 -0700 (PDT)
Message-Id: <20100714.141118.260092331.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 2.6.35-rc1] net-next: vmxnet3 fixes [5/5] Respect the
 interrupt type in VM configuration
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1007131750060.32055@localhost.localdomain>
References: <alpine.LRH.2.00.1007070202080.5939@localhost.localdomain>
	<alpine.LRH.2.00.1007070232300.5939@localhost.localdomain>
	<alpine.LRH.2.00.1007131750060.32055@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Tue, 13 Jul 2010 17:51:39 -0700 (PDT)

> 
> Do not ignore interrupt type in VM configuration
> 
> When interrupt type is not auto, do not ignore the interrupt type set from
> VM configuration.
> Driver may not always respect the interrupt type in configuration but it 
> will certainly try to. Eg: if MSIx is configured and enabling MSIx fails 
> in driver, it fall back on MSI and then on INTx.
> 
> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>
 ...
> @@ -291,7 +291,7 @@ vmxnet3_set_flags(struct net_device *netdev, u32 data)
>  
>  		/* update harware LRO capability accordingly */
>  		if (lro_requested)
> -			adapter->shared->devRead.misc.uptFeatures &= UPT1_F_LRO;
> +			adapter->shared->devRead.misc.uptFeatures |= UPT1_F_LRO;
>  		else

This change has nothing to do with respecting the VM interrupt setting.

Do not stuff unrelated changes into a commit.

I have to be frank with you, this patch series... it stinks.

It papers over races with incorrect tests, unrelated changes are mixed
together, it fixes RX ring exhaustion incorrectly, it illegals starts a
transmit queue before the device is every brought up, etc.
