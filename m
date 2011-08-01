Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1HAIr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 04:47:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63268 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab1HAIrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 04:47:52 -0400
Subject: Re: RCU: how to suppress warnings from rcu_assign_pointer?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        mchan@broadcom.com, linux-kernel@vger.kernel.org
In-Reply-To: <20110801052342.GD2307@linux.vnet.ibm.com>
References: <20110729003843.GA2373@linux.vnet.ibm.com>
	 <20110729105058.2cb9fa86@nehalam.ftrdhcpuser.net>
	 <1312028225.2873.104.camel@edumazet-laptop>
	 <20110730.201609.2157787571393748046.davem@davemloft.net>
	 <20110801052342.GD2307@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 10:47:33 +0200
Message-ID: <1312188453.2719.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 31 juillet 2011 à 22:23 -0700, Paul E. McKenney a écrit :
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> rcu: Make rcu_assign_pointer() unconditionally insert a memory barrier
> 
> Recent changes to gcc give warning messages on rcu_assign_pointers()'s
> checks that allow it to determine when it is OK to omit the memory
> barrier.  Stephen Hemminger tried a number of gcc tricks to silence
> this warning, but #pragmas and CPP macros do not work together in the
> way that would be required to make this work.
> 
> However, we now have RCU_INIT_POINTER(), which already omits this
> memory barrier, and which therefore may be used when assigning NULL to
> an RCU-protected pointer that is accessible to readers.  This commit
> therefore makes rcu_assign_pointer() unconditionally emit the memory
> barrier.
> 
> Reported-by: Stephen Hemminger <shemminger@vyatta.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Acked-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>  

Sure Paul, thanks for doing this. I have _very_ limited access to
Internet this week.

Eric


