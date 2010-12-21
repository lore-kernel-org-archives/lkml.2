Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab0LUUTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 15:19:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36419
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223Ab0LUUTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 15:19:30 -0500
Date: Tue, 21 Dec 2010 12:20:00 -0800 (PST)
Message-Id: <20101221.122000.183069341.davem@davemloft.net>
To: tj@kernel.org
Cc: mchan@broadcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] bnx2: remove cancel_work_sync() from
 remove_one
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101221105103.GA32744@htj.dyndns.org>
References: <4D08C81D.8020606@kernel.org>
	<20101220.131146.115941299.davem@davemloft.net>
	<20101221105103.GA32744@htj.dyndns.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Tue, 21 Dec 2010 11:51:04 +0100

> Yeah, I agree the synchronize_rcu() there would guarantee the actual
> timer completion but as it currently stands it looks a bit too subtle.
> Maybe it's a good idea to add a big fat comment explaining that the
> the timer is guaranteed to stop after close() and how it's guaranteed
> through synchronize_rcu() at the moment?  Also, it might be better to
> use synchronize_sched() there as timer synchronization through
> synchronize_rcu() is more of a happy accident.

I'm not sure the synchronize_*() is even necessary to guarentee
watchdog timer completion.

Like I said, I think the netif_tx_lock() held around both the timer
function itself, and the del_timer() call, are sufficient.

So, this ensures that the watchdog timer either runs to completion or
sees the no-op scheduler attached and returns immediately without
rescheduling the timer.

In any event, I'm going to apply your bnx2 patch to net-next-2.6

Thanks.
