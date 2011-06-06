Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab1FFPSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:18:14 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:29158 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1FFPSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:18:12 -0400
Subject: Re: [PATCH 2/4 v2] nohz: Split extended quiescent state handling
 from nohz switch
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>
In-Reply-To: <1307330437-15372-1-git-send-email-fweisbec@gmail.com>
References: <1307329858-14999-4-git-send-email-fweisbec@gmail.com>
	 <1307330437-15372-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 06 Jun 2011 17:16:03 +0200
Message-ID: <1307373363.11226.1.camel@hcegtvedt.norway.atmel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2011 15:16:05.0303 (UTC) FILETIME=[A7856470:01CC245C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 05:20 +0200, Frederic Weisbecker wrote:
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
> v2: Remove rcu_exit_nohz() from tick_nohz_restart_sched_tick()
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: David Miller <davem@davemloft.net>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>

<snipp>

>  arch/avr32/kernel/process.c            |    4 +-

For the AVR32 related bits

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

<snipp>

-- 
Hans-Christian Egtvedt

