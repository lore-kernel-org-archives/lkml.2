Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1FFEBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 00:01:32 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37757 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1FFEBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 00:01:31 -0400
Date: Sun, 05 Jun 2011 20:58:23 -0700 (PDT)
Message-Id: <20110605.205823.1793483713624949908.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, hpa@zytor.com,
        linux@arm.linux.org.uk, hans-christian.egtvedt@atmel.com,
        vapier@gentoo.org, ralf@linux-mips.org, paulus@samba.org,
        heiko.carstens@de.ibm.com, lethal@linux-sh.org, cmetcalf@tilera.com,
        gxt@mprc.pku.edu.cn
Subject: Re: [PATCH 2/4] nohz: Split extended quiescent state handling from
 nohz switch
From: David Miller <davem@davemloft.net>
In-Reply-To: <1307329858-14999-4-git-send-email-fweisbec@gmail.com>
References: <1307329858-14999-1-git-send-email-fweisbec@gmail.com>
	<1307329858-14999-4-git-send-email-fweisbec@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 05 Jun 2011 20:58:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon,  6 Jun 2011 05:10:56 +0200

> It is assumed that rcu won't be used once we switch to tickless
> mode and until we restart the tick. However this is not always
> true, as in x86-64 where we dereference the idle notifiers after
> the tick is stopped.
> 
> To prepare for fixing this, split the tickless mode switching and
> RCU extended quiescent state logics.
> Make tick_nohz_stop/restart_sched_tick() RCU agnostic but provide
> a new pair of APIs tick_nohz_enter/exit_idle() that keep the
> old behaviour by handling both the nohz mode and RCU extended
> quiescent states, then convert every archs to use these.
> 
> Archs that want to switch to extended QS to some custom points
> can do it later by using tick_nohz_stop_sched_tick() and
> rcu_enter_nohz() seperately.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
