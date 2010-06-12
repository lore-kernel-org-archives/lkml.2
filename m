Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab0FLQey (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 12:34:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813Ab0FLQew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 12:34:52 -0400
Date: Sat, 12 Jun 2010 09:34:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Linux 2.6.35-rc3
Message-Id: <20100612093421.589932c6.akpm@linux-foundation.org>
In-Reply-To: <20100612095903.GA2951@liondog.tnic>
References: <AANLkTimlNGH89Qnt5XcKeawXxp-YEFuPBPARbKuugSf1@mail.gmail.com>
	<20100612095903.GA2951@liondog.tnic>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jun 2010 11:59:03 +0200 Borislav Petkov <bp@alien8.de> wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Fri, Jun 11, 2010 at 08:01:22PM -0700
> 
> > So give it a good testing.
> 
> This one still triggers the warning below. Now there's supposedly a fix
> at least at http://www.spinics.net/lists/cpufreq/msg01631.html
> 
> Can we get it in anytime soon?
> 
> Thanks.
> 
> [   13.120063] BUG: using smp_processor_id() in preemptible [00000000] code: cpufreq-set/1757
> [   13.120310] caller is nr_iowait_cpu+0x1a/0x30
> [   13.120495] Pid: 1757, comm: cpufreq-set Not tainted 2.6.35-rc3 #2
> [   13.120636] Call Trace:
> [   13.120777]  [<ffffffff811ab552>] debug_smp_processor_id+0xc2/0xdc
> [   13.120919]  [<ffffffff81028e1e>] nr_iowait_cpu+0x1a/0x30
> [   13.120921]  [<ffffffff81062a22>] update_ts_time_stats+0x3c/0x77
> [   13.120925]  [<ffffffff8105e390>] ? ktime_get+0x65/0xbe
> [   13.120927]  [<ffffffff81062c03>] get_cpu_idle_time_us+0x49/0x68
> [   13.120932]  [<ffffffffa0047d20>] cpufreq_governor_dbs+0xeb/0x40f [cpufreq_ondemand]
> [   13.120936]  [<ffffffff81348094>] __cpufreq_governor+0x16b/0x1c6
> [   13.120941]  [<ffffffff8134937a>] __cpufreq_set_policy+0x119/0x156
> [   13.120943]  [<ffffffff813497e6>] store_scaling_governor+0x195/0x1cf
> [   13.120946]  [<ffffffff8134a033>] ? handle_update+0x0/0x13
> [   13.120949]  [<ffffffff8134923f>] store+0x5e/0x80
> [   13.120952]  [<ffffffff811320ac>] sysfs_write_file+0x108/0x144
> [   13.120955]  [<ffffffff810dd3d2>] vfs_write+0xb2/0x153
> [   13.120957]  [<ffffffff810dd536>] sys_write+0x4a/0x71
> [   13.120960]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b

Last I heard, Arjan was looking into this.
