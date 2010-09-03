Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0ICPws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 11:52:48 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46287 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab0ICPwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 11:52:47 -0400
Date: Fri, 3 Sep 2010 08:52:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.hengli.com.au, linville@tuxdriver.com,
        netdev@vger.kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH] netpoll: use non-BH variant of RCU
Message-ID: <20100903155244.GC2413@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100813175157.GA29586@gondor.apana.org.au>
 <20100814.235033.02286546.davem@davemloft.net>
 <20100902172625.GD2349@linux.vnet.ibm.com>
 <20100903.083409.52185570.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100903.083409.52185570.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 08:34:09AM -0700, David Miller wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Date: Thu, 2 Sep 2010 10:26:25 -0700
> 
> >     softirq: adjust error check
> >     
> >     The error check for _local_bh_enable_ip() warns on both in_irq() and
> >     irqs_disabled().  The check for in_irq() is necessary, because a hardirq
> >     might well have interrupted bh execution, in which case it is simply
> >     not possible for the hardirq to exclude the bh that got interrupted.
> >     
> >     However, it is perfectly reasonable to disable bh while hardirqs are
> >     disabled, and this in fact promotes common code.  This commit therefore
> >     removes the irqs_disabled() check.
> >     
> >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thank you, David!

							Thanx, Paul
