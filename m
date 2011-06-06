Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab1FFUaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:30:04 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:30428 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab1FFUaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:30:03 -0400
Message-ID: <4DED38C9.1080401@tilera.com>
Date: Mon, 6 Jun 2011 16:30:01 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 2/4 v2] nohz: Split extended quiescent state handling
 from nohz switch
References: <1307329858-14999-4-git-send-email-fweisbec@gmail.com> <1307330437-15372-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1307330437-15372-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/2011 11:20 PM, Frederic Weisbecker wrote:
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
> [...]
>  arch/tile/kernel/process.c             |    4 +-

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


