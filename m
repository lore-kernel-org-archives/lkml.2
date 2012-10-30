Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab2J3IcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:32:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34969 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2J3IcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:32:18 -0400
Message-ID: <508F90A0.1030503@gmail.com>
Date: Tue, 30 Oct 2012 16:32:32 +0800
From: Charles Wang <0oo0.hust@gmail.com>
Reply-To: muming.wq@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: Re: [PATCH 01/32] nohz: Move nohz load balancer selection into idle
 logic
References: <20121029202711.062749374@goodmis.org> <20121029203846.797007049@goodmis.org>
In-Reply-To: <20121029203846.797007049@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

calc_load_exit_idle depends on updated jiffies, so you shouldn't move 
this before tick_do_update_jiffies64.

And why should we do nohz_balance_enter_idle in tick_nohz_idle_exit? 
It's nohz_balance_exit_idle here.

Regards,
Charles

On 10/30/2012 04:27 AM, Steven Rostedt wrote:
［snipped］
 > @@ -573,7 +573,6 @@ static void tick_nohz_restart_sched_tick(struct 
tick_sched *ts, ktime_t now)
 >  	tick_do_update_jiffies64(now);
 >  	update_cpu_load_nohz();
 >
 > -	calc_load_exit_idle();
 >  	touch_softlockup_watchdog();
 >  	/*
 >  	 * Cancel the scheduled timer and restore the tick
 > @@ -628,6 +627,8 @@ void tick_nohz_idle_exit(void)
 >  		tick_nohz_stop_idle(cpu, now);
 >
 >  	if (ts->tick_stopped) {
 > +		nohz_balance_enter_idle(cpu);
 > +		calc_load_exit_idle();
 >  		tick_nohz_restart_sched_tick(ts, now);
 >  		tick_nohz_account_idle_ticks(ts);
 >  	}
