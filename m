Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1HBKcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:32:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36544 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab1HBKcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:32:20 -0400
Date: Tue, 2 Aug 2011 03:32:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: shemminger@vyatta.com, eric.dumazet@gmail.com, mchan@broadcom.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: convert uses of rcu_assign_pointer(x, NULL) to
 RCU_INIT_POINTER
Message-ID: <20110802103216.GB2352@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110801052342.GD2307@linux.vnet.ibm.com>
 <1312188453.2719.1.camel@edumazet-laptop>
 <20110801091900.1027396f@nehalam.ftrdhcpuser.net>
 <20110801.224401.31810103988544647.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801.224401.31810103988544647.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 10:44:01PM -0700, David Miller wrote:
> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Mon, 1 Aug 2011 09:19:00 -0700
> 
> > When assigning a NULL value to an RCU protected pointer, no barrier
> > is needed. The rcu_assign_pointer, used to handle that but will soon
> > change to not handle the special case.
> > 
> > Convert all rcu_assign_pointer of NULL value.
> > 
> > //smpl
> > @@ expression P; @@
> > 
> > - rcu_assign_pointer(P, NULL)
> > + RCU_INIT_POINTER(P, NULL)
> > 
> > // </smpl>
> > 
> > 
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Very good, thank you!

This patch does not depend on Eric's earlier patch because
RCU_INIT_POINTER() already exists.  So although I would be happy to
carry this patch, there is no reason I can see not to run it up through
net-next.  Either way, the Coccinelle script does look generally
useful.  ;-)

If you would prefer me to carry it, please let me know.  Otherwise:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

							Thanx, Paul
