Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab1ILOxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:53:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33089 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757494Ab1ILOxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:53:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+FPcQLlyyFDQ3uRme4C7GCHvMoyfYlQ8BPteUQlO
	TIsH/f1FIuH4XD
Subject: Re: [ANNOUNCE] 3.0.4-rt13
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1315835562.6758.3.camel@marge.simson.net>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Sep 2011 16:53:07 +0200
Message-ID: <1315839187.6758.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 15:52 +0200, Mike Galbraith wrote:

> 36717            <...>-6266  [002]   242.543129: sys_semop <-system_call_fastpath
> 36718            <...>-6266  [002]   242.543129: sys_semtimedop <-sys_semop
> 36719            <...>-6266  [002]   242.543131: ipc_lock_check <-sys_semtimedop
> 36720            <...>-6266  [002]   242.543131: ipc_lock <-ipc_lock_check
> 36721            <...>-6266  [002]   242.543132: __rcu_read_lock <-ipc_lock
> 36722            <...>-6266  [002]   242.543133: migrate_disable <-ipc_lock
> 36723            <...>-6266  [002]   242.543134: migrate_disable: migrate_disable: in_atomic:0 p->migrate_disable_atomic:0 p->migrate_disable:0
> 36724            <...>-6266  [002]   242.543134: pin_current_cpu <-migrate_disable
> 36725            <...>-6266  [002]   242.543134: _raw_spin_lock_irqsave <-migrate_disable
> 36726            <...>-6266  [002]   242.543135: _raw_spin_unlock_irqrestore <-migrate_disable
> 36727            <...>-6266  [002]   242.543135: rt_spin_lock <-ipc_lock
> 36728            <...>-6266  [002]   242.543136: ipcperms <-sys_semtimedop
> 36729            <...>-6266  [002]   242.543137: ns_capable <-ipcperms
> 36730            <...>-6266  [002]   242.543138: cap_capable <-ns_capable
> 36731            <...>-6266  [002]   242.543138: pid_vnr <-sys_semtimedop
> 36732            <...>-6266  [002]   242.543139: try_atomic_semop <-sys_semtimedop
> 36733            <...>-6266  [002]   242.543140: do_smart_update <-sys_semtimedop
> 36734            <...>-6266  [002]   242.543140: update_queue <-do_smart_update
> 36735            <...>-6266  [002]   242.543141: try_atomic_semop <-update_queue
> 36736            <...>-6266  [002]   242.543142: update_queue <-do_smart_update
> 36737            <...>-6266  [002]   242.543142: try_atomic_semop <-update_queue
> 36738            <...>-6266  [002]   242.543143: update_queue <-do_smart_update
> 36739            <...>-6266  [002]   242.543143: try_atomic_semop <-update_queue
> 36740            <...>-6266  [002]   242.543144: get_seconds <-do_smart_update
> 36741            <...>-6266  [002]   242.543144: rt_spin_unlock <-sys_semtimedop
> 36742            <...>-6266  [002]   242.543144: migrate_enable <-sys_semtimedop
> 36743            <...>-6266  [002]   242.543145: migrate_enable: migrate_enable: in_atomic:1 p->migrate_disable_atomic:0 p->migrate_disable:1

Hm.  Seems this is home grown a non-preemptive wakeup in the making.

	-Mike


