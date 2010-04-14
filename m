Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0DNBvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 21:51:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55849
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754367Ab0DNBvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 21:51:02 -0400
Date: Tue, 13 Apr 2010 18:51:06 -0700 (PDT)
Message-Id: <20100413.185106.46340154.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Weird rcu lockdep warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100414014930.GI2538@linux.vnet.ibm.com>
References: <20100414000226.GH5602@nowhere>
	<20100413.171306.25868761.davem@davemloft.net>
	<20100414014930.GI2538@linux.vnet.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 13 Apr 2010 18:49:30 -0700

> On Tue, Apr 13, 2010 at 05:13:06PM -0700, David Miller wrote:
>> From: Frederic Weisbecker <fweisbec@gmail.com>
>> Date: Wed, 14 Apr 2010 02:02:27 +0200
>> 
>> > I just have a guess though....
>> > This seems to always happen from NMI path, and lockdep is disabled on NMI.
>> > I suspect the lock_acquire() performed by rcu_read_lock() is just ignored
>> > and then the rcu_read_lock_held() check has the wrong result...
>> 
>> Yeah, I bet that's it too.
>> 
>> lock_is_held() can't return anything meaningful while lockdep is
>> disabled, which it is during NMIs.
> 
> Ah!  So I just need to add a "current->lockdep_recursion"
> check to debug_lockdep_rcu_enabled().  And move the function to
> kernel/rcutree_plugin.h to avoid #include hell.
> 
> See below for (untested) patch.

Looks good to me, Frederic please test :-)
