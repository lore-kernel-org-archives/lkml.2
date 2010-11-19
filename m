Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0KSUhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:37:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33543
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301Ab0KSUhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:37:10 -0500
Date: Fri, 19 Nov 2010 12:37:35 -0800 (PST)
Message-Id: <20101119.123735.246535099.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: bhutchings@solarflare.com, shemminger@vyatta.com, netdev@vger.kernel.org,
        pv-drivers@vmware.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.37-rc1] net-next: Add multiqueue support to vmxnet3
 driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1011191023500.8304@sbhatewara-dev1.eng.vmware.com>
References: <alpine.LRH.2.00.1011191023500.8304@sbhatewara-dev1.eng.vmware.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Fri, 19 Nov 2010 10:46:59 -0800 (PST)

> 
> From: Shreyas Bhatewara <sbhatewara@vmware.com>
> 
> Add multiqueue support to vmxnet3 driver
> 
> This change adds multiqueue and thus receive side scaling support
> to vmxnet3 device driver. Number of rx queues is limited to 1 in cases
> where MSI is not configured or one MSIx vector is not available per rx 
> queue
> 
> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>
> Reviewed-by: Bhavesh Davda <bhavesh@vmware.com>

Your patch is corrupted:

> @@ -107,7 +110,7 @@ static void
>  vmxnet3_tq_start(struct vmxnet3_tx_queue *tq, struct vmxnet3_adapter *adapter)
>  {
>  	tq->stopped = false;
> -	netif_start_queue(adapter->netdev);
> +	netif_start_subqueue(adapter->netdev, tq - adapter->tx_queue);
>  }
>  
>  

This hunk has an incorrect header, the hunk header states that
both before and after the change there should be 7 lines in the
code block, but there are 8.

One way this can happen is if you edit the patch in emacs since
it has a patch editing mode which kicks which tries to "fix up"
the hunk headers, but most of the time it actually corrupts them.
