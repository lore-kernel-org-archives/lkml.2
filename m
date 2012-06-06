Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2FFBIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 21:08:13 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3859 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab2FFBIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 21:08:12 -0400
X-Server-Uuid: 72204117-5C29-4314-8910-60DB108979CB
Date: Tue, 5 Jun 2012 18:02:55 -0700
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Christian Kujau" <lists@nerdbynature.de>
cc: LKML <linux-kernel@vger.kernel.org>, mcarlson@broadcom.com
Subject: Re: tg3: transmit timed out, resetting
Message-ID: <20120606010255.GA9991@mcarlson.broadcom.com>
References: <alpine.DEB.2.01.1206041546070.5568@trent.utfs.org>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1206041546070.5568@trent.utfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-WSS-ID: 63D072263IK67016-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm attempting to reproduce this in our lab.  In the meantime, 
the latest revisions of the driver output a register dump and some
additional information when transmit timeouts happen.  It would be
useful to see that data.  Would it be possible to try a the latest
kernels and get this information?

On Mon, Jun 04, 2012 at 04:14:30PM -0700, Christian Kujau wrote:
> Hi,
> 
> on this Ideapad S10 the onboard Broadcom BCM5906M prints the warning 
> below, once. From then on, the "transmit timed out, resetting" message 
> repeats, every now and then.
> 
> This laptop is mounting 2 readonly NFS shares from a box in the same LAN 
> and when scanning lots of files on these NFS shares, the transmit timeouts 
> occur more often, I think. When there's sequential traffic (i.e. reading 
> larger files from the NFS shares), fewer warnings occur. But this is just 
> manual observation, I haven't been able to reproduce this reliably. 
> However, there's constant traffic on the device (maybe ~700KB/s both tx 
> and rx), so the messages occur pretty regularly.
> 
> I have reported the error against the Fedora 17 kernel [0] but it happens 
> with a vanilla 3.4.0 too[1] - check out for full dmesg, .config and more.
> 
> I had a similar issue a while ago[2] and almost forgot about them. The 
> laptop ran Ubuntu 10.04 (2.6.32) since then and the problem was gone, so 
> I'd say 2.6.32 fixed it. Now the same laptop switched to Fedora, kernel 
> 3.3.4 and the problem seems to be back again.
> 
> I'll try running with sg=off, as Matt suggested in [3] and report back.
> 
> Thanks,
> Christian.
> 
> [0] https://bugzilla.redhat.com/show_bug.cgi?id=825123
> [1] http://nerdbynature.de/bits/3.4.0/tg3/
> [2] http://lkml.indiana.edu/hypermail/linux/kernel/0906.1/00004.html
> [3] http://lkml.indiana.edu/hypermail/linux/kernel/0906.1/00317.html
> 
> ------------[ cut here ]------------
> WARNING: at /opt/home/chrisk/dev/linux-2.6-git/net/sched/sch_generic.c:255 
> dev_watchdog+0x1cc/0x1e0()
> Hardware name: Lenovo          
> NETDEV WATCHDOG: p2p1 (tg3): transmit queue 0 timed out
> Modules linked in: acpi_cpufreq mperf freq_table nfs lockd sunrpc b43 
> mac80211 cfg80211 ssb coretemp hwmon usb_storage [last unloaded: scsi_wait_scan]
> Pid: 685, comm: FahCore_78 Not tainted 3.4.0-10151-g4fc3acf #8
> Call Trace:
>  [<c102b299>] ? warn_slowpath_common+0x79/0xb0
>  [<c12d54ec>] ? dev_watchdog+0x1cc/0x1e0
>  [<c12d54ec>] ? dev_watchdog+0x1cc/0x1e0
>  [<c102b374>] ? warn_slowpath_fmt+0x34/0x40
>  [<c12d54ec>] ? dev_watchdog+0x1cc/0x1e0
>  [<c12d5320>] ? pfifo_fast_dequeue+0xe0/0xe0
>  [<c1035cf1>] ? run_timer_softirq+0xd1/0x1d0
>  [<c1031615>] ? __do_softirq+0x75/0x100
>  [<c10315a0>] ? remote_softirq_receive+0x20/0x20
>  <IRQ>  [<c10318a6>] ? irq_exit+0x66/0x90
>  [<c101b8d9>] ? smp_apic_timer_interrupt+0x59/0x90
>  [<c1360b35>] ? apic_timer_interrupt+0x31/0x38
>  [<c1360000>] ? rt_mutex_trylock+0x70/0x70
> ---[ end trace 9de668a859ee5d6c ]---
> tg3 0000:02:00.0: p2p1: transmit timed out, resetting
> 
> 
> -- 
> BOFH excuse #438:
> 
> sticky bit has come loose
> 

