Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab1FAXY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 19:24:56 -0400
Received: from trent.utfs.org ([194.246.123.103]:55476 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398Ab1FAXYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 19:24:55 -0400
Date: Wed, 1 Jun 2011 16:24:52 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Connor H <cmdkhh@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32: Attempted to kill the idle task?
In-Reply-To: <BANLkTin8Jb-BWDmZbF_cLTk3rjVU9KQu9A@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1106011623240.21697@trent.utfs.org>
References: <4DE68DD5.4080702@nerdbynature.de> <BANLkTin8Jb-BWDmZbF_cLTk3rjVU9KQu9A@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011 at 15:06, Connor H wrote:
> > we have a Debian/lenny system (Dell R410) with its "latest"
> > 2.6.32+27~bpo50+1 installed. From time to time the system tends to oops.
> > Can someone have a quick look at the following, if this makes sense at
> > all? I suspect the "real" oops message has scrolled away, but this is
> > all we got so far:
> >
> > ------------------------------------
> > [4330423.071859] RSP <ffff88012fffdcb8>
> > [4330423.071926] ---[ end trace b471cad78827bf8a ]--—
> > [4330423.071994] Kernel panic - not syncing: Attempted to kill the idle
> > task? [4330423.072068] rid: 0, comm: swapper Tainted: G D 2.6.32-5-amd64
> > 81 [4330423.072139] Call Trace:
> > [4330423.072206] [afffffff81216ee5>] ? panic+0x86/0x141
> > [4330423.072277] [afffffff812f6fee>1 ? printk+0x4e/0x58
> > [4330423.072349] [afffffff81041c07>] ? do_exit+0x72/0x6b5
> > [4330423.072419] [afffffff8104d011>] ? release_console_sem+0xl7e/0xlaf
> > [4330423.072493] [afffffff812f9c4d>1 ? oops_end+0xaf/0xb4
> > [4330423.072563] [afffffff81012734>] ? do_divide_error+0x85/0x81
> Here is the division fail
> kernel/sched_fair.c #3164
> 
> in find_busiest_group

Thanks for looking into it!

> sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
> 
> kernel/sched_fair.c #2853
> 	sds set from this call
> 	update_sd_lb_stats(sd, this_cpu, idle, cpus, balance, &sds);
> 
> 	which calculates total_pwr by looping all sched_group 's  in
> 	sds->total_pwr += sg->cpu_power;
> 	
> so hopefully Ingo or Peter can shed some light,
> 
> Connor

Christian.
-- 
BOFH excuse #365:

parallel processors running perpendicular today
