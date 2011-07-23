Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab1GWAR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 20:17:59 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36284 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab1GWARs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 20:17:48 -0400
Date: Fri, 22 Jul 2011 17:16:42 -0700 (PDT)
Message-Id: <20110722.171642.1498051921735569337.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: romieu@fr.zoreil.com, greearb@candelatech.com,
        torvalds@linux-foundation.org, david@unsolicited.net, tj@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: allow netif_carrier to be called safely from IRQ
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110722155356.5911225f@nehalam.ftrdhcpuser.net>
References: <20110722212629.GA10833@electric-eye.fr.zoreil.com>
	<20110722150956.5b341488@nehalam.ftrdhcpuser.net>
	<20110722155356.5911225f@nehalam.ftrdhcpuser.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 22 Jul 2011 17:16:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Fri, 22 Jul 2011 15:53:56 -0700

> As reported by Ben Greer and Froncois Romieu. The code path in 
> the netif_carrier code leads it to try and disable
> a late workqueue to reenable it immediately
> netif_carrier_on
> -> linkwatch_fire_event
>    -> linkwatch_schedule_work
>       -> cancel_delayed_work
>          -> del_timer_sync  
> 
> If __cancel_delayed_work is used instead then there is no
> problem of waiting for running linkwatch_event.
> 
> There is a race between linkwatch_event running re-scheduling
> but it is harmless to schedule an extra scan of the linkwatch queue.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Applied.
