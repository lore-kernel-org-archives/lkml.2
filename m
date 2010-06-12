Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab0FLJ7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 05:59:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56012 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab0FLJ7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 05:59:23 -0400
Date: Sat, 12 Jun 2010 11:59:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org
Subject: Re: Linux 2.6.35-rc3
Message-ID: <20100612095903.GA2951@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org
References: <AANLkTimlNGH89Qnt5XcKeawXxp-YEFuPBPARbKuugSf1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTimlNGH89Qnt5XcKeawXxp-YEFuPBPARbKuugSf1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, Jun 11, 2010 at 08:01:22PM -0700

> So give it a good testing.

This one still triggers the warning below. Now there's supposedly a fix
at least at http://www.spinics.net/lists/cpufreq/msg01631.html

Can we get it in anytime soon?

Thanks.

[   13.120063] BUG: using smp_processor_id() in preemptible [00000000] code: cpufreq-set/1757
[   13.120310] caller is nr_iowait_cpu+0x1a/0x30
[   13.120495] Pid: 1757, comm: cpufreq-set Not tainted 2.6.35-rc3 #2
[   13.120636] Call Trace:
[   13.120777]  [<ffffffff811ab552>] debug_smp_processor_id+0xc2/0xdc
[   13.120919]  [<ffffffff81028e1e>] nr_iowait_cpu+0x1a/0x30
[   13.120921]  [<ffffffff81062a22>] update_ts_time_stats+0x3c/0x77
[   13.120925]  [<ffffffff8105e390>] ? ktime_get+0x65/0xbe
[   13.120927]  [<ffffffff81062c03>] get_cpu_idle_time_us+0x49/0x68
[   13.120932]  [<ffffffffa0047d20>] cpufreq_governor_dbs+0xeb/0x40f [cpufreq_ondemand]
[   13.120936]  [<ffffffff81348094>] __cpufreq_governor+0x16b/0x1c6
[   13.120941]  [<ffffffff8134937a>] __cpufreq_set_policy+0x119/0x156
[   13.120943]  [<ffffffff813497e6>] store_scaling_governor+0x195/0x1cf
[   13.120946]  [<ffffffff8134a033>] ? handle_update+0x0/0x13
[   13.120949]  [<ffffffff8134923f>] store+0x5e/0x80
[   13.120952]  [<ffffffff811320ac>] sysfs_write_file+0x108/0x144
[   13.120955]  [<ffffffff810dd3d2>] vfs_write+0xb2/0x153
[   13.120957]  [<ffffffff810dd536>] sys_write+0x4a/0x71
[   13.120960]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b
[   13.124899] BUG: using smp_processor_id() in preemptible [00000000] code: cpufreq-set/1776
[   13.124903] caller is nr_iowait_cpu+0x1a/0x30
[   13.124905] Pid: 1776, comm: cpufreq-set Not tainted 2.6.35-rc3 #2
[   13.124907] Call Trace:
[   13.124911]  [<ffffffff811ab552>] debug_smp_processor_id+0xc2/0xdc
[   13.124913]  [<ffffffff81028e1e>] nr_iowait_cpu+0x1a/0x30
[   13.124916]  [<ffffffff81062a22>] update_ts_time_stats+0x3c/0x77
[   13.124918]  [<ffffffff8105e390>] ? ktime_get+0x65/0xbe
[   13.124920]  [<ffffffff81062c03>] get_cpu_idle_time_us+0x49/0x68
[   13.124924]  [<ffffffffa0047d20>] cpufreq_governor_dbs+0xeb/0x40f [cpufreq_ondemand]
[   13.124928]  [<ffffffff81348094>] __cpufreq_governor+0x16b/0x1c6
[   13.124930]  [<ffffffff8134937a>] __cpufreq_set_policy+0x119/0x156
[   13.124932]  [<ffffffff813497e6>] store_scaling_governor+0x195/0x1cf
[   13.124935]  [<ffffffff8134a033>] ? handle_update+0x0/0x13
[   13.124938]  [<ffffffff8134923f>] store+0x5e/0x80
[   13.124940]  [<ffffffff811320ac>] sysfs_write_file+0x108/0x144
[   13.124943]  [<ffffffff810dd3d2>] vfs_write+0xb2/0x153
[   13.124945]  [<ffffffff810dd536>] sys_write+0x4a/0x71
[   13.124947]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b
[   13.126743] BUG: using smp_processor_id() in preemptible [00000000] code: cpufreq-set/1777
[   13.126746] caller is nr_iowait_cpu+0x1a/0x30
[   13.126748] Pid: 1777, comm: cpufreq-set Not tainted 2.6.35-rc3 #2
[   13.126750] Call Trace:
[   13.126754]  [<ffffffff811ab552>] debug_smp_processor_id+0xc2/0xdc
[   13.126756]  [<ffffffff81028e1e>] nr_iowait_cpu+0x1a/0x30
[   13.126758]  [<ffffffff81062a22>] update_ts_time_stats+0x3c/0x77
[   13.126761]  [<ffffffff8105e390>] ? ktime_get+0x65/0xbe
[   13.126763]  [<ffffffff81062c03>] get_cpu_idle_time_us+0x49/0x68
[   13.126767]  [<ffffffffa0047d20>] cpufreq_governor_dbs+0xeb/0x40f [cpufreq_ondemand]
[   13.126771]  [<ffffffff81348094>] __cpufreq_governor+0x16b/0x1c6
[   13.126773]  [<ffffffff8134937a>] __cpufreq_set_policy+0x119/0x156
[   13.126775]  [<ffffffff813497e6>] store_scaling_governor+0x195/0x1cf
[   13.126778]  [<ffffffff8134a033>] ? handle_update+0x0/0x13
[   13.126781]  [<ffffffff8134923f>] store+0x5e/0x80
[   13.126784]  [<ffffffff811320ac>] sysfs_write_file+0x108/0x144
[   13.126786]  [<ffffffff810dd3d2>] vfs_write+0xb2/0x153
[   13.126788]  [<ffffffff810dd536>] sys_write+0x4a/0x71
[   13.126791]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b

-- 
Regards/Gruss,
    Boris.
