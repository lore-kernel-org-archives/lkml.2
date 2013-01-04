Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3ADXUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 18:20:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41819 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab3ADXUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 18:20:32 -0500
Date: Fri, 04 Jan 2013 15:20:31 -0800 (PST)
Message-Id: <20130104.152031.1827815520394695268.davem@davemloft.net>
To: lkundrak@v3.sk
Cc: buytenh@wantstofly.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mv643xx_eth: Fix a possible deadlock upon ifdown
From: David Miller <davem@davemloft.net>
In-Reply-To: <1357309063-20236-1-git-send-email-lkundrak@v3.sk>
References: <1357308422-19639-1-git-send-email-lkundrak@v3.sk>
	<1357309063-20236-1-git-send-email-lkundrak@v3.sk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>
Date: Fri,  4 Jan 2013 15:17:43 +0100

> @@ -943,7 +943,7 @@ static int txq_reclaim(struct tx_queue *txq, int budget, int force)
>  	struct netdev_queue *nq = netdev_get_tx_queue(mp->dev, txq->index);
>  	int reclaimed;
>  
> -	__netif_tx_lock(nq, smp_processor_id());
> +	__netif_tx_lock_bh(nq);

I still don't understand why this change is necessary.

The TX reclaim function is invoked in software interrupt context in
all of the places where this lockdep warning might matter.
