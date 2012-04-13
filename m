Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322Ab2DMO4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:56:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49505 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2DMO4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:56:06 -0400
Date: Fri, 13 Apr 2012 10:55:56 -0400 (EDT)
Message-Id: <20120413.105556.73360716787161031.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: mroos@linux.ee, shemminger@vyatta.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: suspicious RCU usage warnings in 3.3.0
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120413133513.GB2457@linux.vnet.ibm.com>
References: <20120412045428.GB2497@linux.vnet.ibm.com>
	<alpine.SOC.1.00.1204131444150.2736@math.ut.ee>
	<20120413133513.GB2457@linux.vnet.ibm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 Apr 2012 07:55:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 06:35:13 -0700

DANGER WILL ROBINSON, McKenney is hacking sparc64 assembler!
:-))))

> My main concern about my patch is my removal of this line:
> 
> 	bne,pn			%icc, __handle_softirq
> 
> It is quite possible that this should instead change to look as follows:
> 
> 	bne,pn			%icc, __handle_preemption
> 

I would say it should not, because the __handle_softirq code path,
if taken, unconditionally branches to the very next instruction
after this branch and it's delay slot.

> Anyway, patch with updated changelog below.

Great work, I'll apply this after I test it out a bit myself.

Thanks a lot Paul!
