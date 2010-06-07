Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0FGTIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:08:54 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42163 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0FGTIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:08:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=PGf0KW9/0Fk5hvWD/Gg+OLeGd7RmPVucMeke/rhAnqhM9kZAY0fisqKRrLEDiIw/Re
         9aawA/D8xa6D6e+426E2MLp2+MDBk2HB4iAjt1f/5dNk0lve700dz68phJZLp0kuC+L8
         +oUun+hfewfFXt9S4wYmk2k1FVnPH/dDhIxKM=
MIME-Version: 1.0
Date: Mon, 7 Jun 2010 15:02:58 -0400
Message-ID: <AANLkTim_9zeeOJbg0UTU8Wm7u7yFhFNACZ2hlnL3GMFz@mail.gmail.com>
Subject: 2.6.35-rc2-git1 - BUG: using smp_processor_id() in preemptible 
	[00000000] code: ondemand/4323
From: Miles Lane <miles.lane@gmail.com>
To: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[   90.531089] BUG: using smp_processor_id() in preemptible [00000000]
code: ondemand/4323
[   90.531100] caller is nr_iowait_cpu+0x15/0x2c
[   90.531106] Pid: 4323, comm: ondemand Tainted: G        W
2.6.35-rc2-git1 #8
[   90.531109] Call Trace:
[   90.531118]  [<ffffffff811c6c20>] debug_smp_processor_id+0xc4/0xe0
[   90.531125]  [<ffffffff8102a4c3>] nr_iowait_cpu+0x15/0x2c
[   90.531132]  [<ffffffff81061c1f>] update_ts_time_stats+0x37/0x72
[   90.531140]  [<ffffffff813c8388>] ? mutex_unlock+0x9/0xb
[   90.531146]  [<ffffffff8105d408>] ? ktime_get+0x60/0xb9
[   90.531151]  [<ffffffff81061dec>] get_cpu_idle_time_us+0x44/0x63
[   90.531160]  [<ffffffffa002c478>] get_cpu_idle_time+0x1c/0xa4
[cpufreq_ondemand]
[   90.531168]  [<ffffffffa002cc1c>] cpufreq_governor_dbs+0xcc/0x35c
[cpufreq_ondemand]
[   90.531175]  [<ffffffff8132dfed>] __cpufreq_governor+0x5d/0xa3
[   90.531181]  [<ffffffff8132ed87>] __cpufreq_set_policy+0x1a8/0x222
[   90.531187]  [<ffffffff8132f265>] store_scaling_governor+0x19f/0x1ed
[   90.531194]  [<ffffffff8132f535>] ? handle_update+0x0/0x33
[   90.531201]  [<ffffffff813c8c97>] ? down_write+0x3f/0x62
[   90.531207]  [<ffffffff813c9c00>] ? _raw_spin_trylock+0x39/0x81
[   90.531212]  [<ffffffff8132ebbd>] store+0x56/0x78
[   90.531220]  [<ffffffff81131302>] sysfs_write_file+0x103/0x13f
[   90.531228]  [<ffffffff810d9072>] vfs_write+0xa5/0xe2
[   90.531234]  [<ffffffff810d9e51>] ? fget_light+0x35/0x96
[   90.531240]  [<ffffffff810d9165>] sys_write+0x45/0x69
[   90.531247]  [<ffffffff810022ab>] system_call_fastpath+0x16/0x1b
