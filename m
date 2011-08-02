Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1HBFoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 01:44:17 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49109 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1HBFoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 01:44:10 -0400
Date: Mon, 01 Aug 2011 22:44:01 -0700 (PDT)
Message-Id: <20110801.224401.31810103988544647.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: eric.dumazet@gmail.com, paulmck@linux.vnet.ibm.com, mchan@broadcom.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: convert uses of rcu_assign_pointer(x, NULL) to
 RCU_INIT_POINTER
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110801091900.1027396f@nehalam.ftrdhcpuser.net>
References: <20110801052342.GD2307@linux.vnet.ibm.com>
	<1312188453.2719.1.camel@edumazet-laptop>
	<20110801091900.1027396f@nehalam.ftrdhcpuser.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 01 Aug 2011 22:44:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Mon, 1 Aug 2011 09:19:00 -0700

> When assigning a NULL value to an RCU protected pointer, no barrier
> is needed. The rcu_assign_pointer, used to handle that but will soon
> change to not handle the special case.
> 
> Convert all rcu_assign_pointer of NULL value.
> 
> //smpl
> @@ expression P; @@
> 
> - rcu_assign_pointer(P, NULL)
> + RCU_INIT_POINTER(P, NULL)
> 
> // </smpl>
> 
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Acked-by: David S. Miller <davem@davemloft.net>
