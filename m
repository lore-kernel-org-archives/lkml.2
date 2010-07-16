Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935248Ab0GPBjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 21:39:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59276
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935236Ab0GPBi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 21:38:57 -0400
Date: Thu, 15 Jul 2010 18:39:13 -0700 (PDT)
Message-Id: <20100715.183913.71134002.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev@vger.kernel.org, pv-drivers@vmware.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.35-rc1] net-next: vmxnet3 fixes [1/5] Spare skb to
 avoid starvation
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1007151656140.10176@localhost.localdomain>
References: <alpine.LRH.2.00.1007070214400.6105@localhost.localdomain>
	<alpine.LRH.2.00.1007131743520.32055@localhost.localdomain>
	<alpine.LRH.2.00.1007151656140.10176@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Thu, 15 Jul 2010 18:19:39 -0700 (PDT)

> 
> Reposting this patch with struct vmxnet3_cmd_ring *ring made const 
> according to Stephen's feedback.

Please address my feedback, which is that this is not the way to
handle this problem.

You can prevent all forms of starvation, without hacky spare-skbs or
things like that, by trying to allocate the replacement SKB _before_
sending the packet up to the stack.

If the replacement SKB allocation fails, you do not give the packet to
the network stack.  Instead, you give it back to the card's RX ring.

See drivers/net/tg3.c, drivers/net/niu.c, etc. for examples of this.
