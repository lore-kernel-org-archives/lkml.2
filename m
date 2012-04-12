Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683Ab2DLBNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:13:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60602 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab2DLBNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:13:47 -0400
Date: Wed, 11 Apr 2012 21:08:43 -0400 (EDT)
Message-Id: <20120411.210843.716144028821174908.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: shemminger@vyatta.com, mroos@linux.ee, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: suspicious RCU usage warnings in 3.3.0
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120412004507.GF2473@linux.vnet.ibm.com>
References: <20120411171004.016ddd95@nehalam.linuxnetplumber.net>
	<20120411.201854.1070083308359208025.davem@davemloft.net>
	<20120412004507.GF2473@linux.vnet.ibm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 11 Apr 2012 18:08:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 11 Apr 2012 17:45:07 -0700

> If I am confused about the simple function call, and if control is really
> passing via an interrupt or exception, then rcu_irq_enter() should be
> called on entry to the interrupt or exception and rcu_irq_exit() should
> be called on exit.

Hmm, it seems the convention changed such that platforms aren't
supposed to invoke do_softirq() from their trap return trap any more.
It's handled completely by irq_exit().

When did that start happening? :-)

Anyways I bet that's the problem, sparc64 invokes do_softirq() in it's
trap return path if softirqs are pending, and that doesn't do any
of the RCU frobbing you mention.


