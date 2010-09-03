Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab0ICPdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 11:33:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49570
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197Ab0ICPdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 11:33:52 -0400
Date: Fri, 03 Sep 2010 08:34:09 -0700 (PDT)
Message-Id: <20100903.083409.52185570.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: herbert@gondor.hengli.com.au, linville@tuxdriver.com,
        netdev@vger.kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH] netpoll: use non-BH variant of RCU
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100902172625.GD2349@linux.vnet.ibm.com>
References: <20100813175157.GA29586@gondor.apana.org.au>
	<20100814.235033.02286546.davem@davemloft.net>
	<20100902172625.GD2349@linux.vnet.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 2 Sep 2010 10:26:25 -0700

>     softirq: adjust error check
>     
>     The error check for _local_bh_enable_ip() warns on both in_irq() and
>     irqs_disabled().  The check for in_irq() is necessary, because a hardirq
>     might well have interrupted bh execution, in which case it is simply
>     not possible for the hardirq to exclude the bh that got interrupted.
>     
>     However, it is perfectly reasonable to disable bh while hardirqs are
>     disabled, and this in fact promotes common code.  This commit therefore
>     removes the irqs_disabled() check.
>     
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: David S. Miller <davem@davemloft.net>
