Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1IURBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 13:01:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:57196 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1IURBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 13:01:32 -0400
Subject: Re: rt14: strace ->  migrate_disable_atomic imbalance
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 21 Sep 2011 19:01:12 +0200
In-Reply-To: <1316600230.6628.6.camel@marge.simson.net>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins>
	 <1315927699.6445.6.camel@marge.simson.net> <1315930430.5977.21.camel@twins>
	 <1316600230.6628.6.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316624472.24750.32.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 12:17 +0200, Mike Galbraith wrote:
> [  144.212272] ------------[ cut here ]------------
> [  144.212280] WARNING: at kernel/sched.c:6152 migrate_disable+0x1b6/0x200()
> [  144.212282] Hardware name: MS-7502
> [  144.212283] Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nfsd lockd parport_pc parport nfs_acl auth_rpcgss sunrpc bridge ipv6 stp cpufreq_conservative microcode cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf nls_iso8859_1 nls_cp437 vfat fat fuse ext3 jbd dm_mod usbmouse usb_storage usbhid snd_hda_codec_realtek usb_libusual uas sr_mod cdrom hid snd_hda_intel e1000e snd_hda_codec kvm_intel snd_hwdep sg snd_pcm kvm i2c_i801 snd_timer snd firewire_ohci firewire_core soundcore snd_page_alloc crc_itu_t button ext4 mbcache jbd2 crc16 uhci_hcd sd_mod ehci_hcd usbcore rtc_cmos ahci libahci libata scsi_mod fan processor thermal
> [  144.212317] Pid: 6215, comm: strace Not tainted 3.0.4-rt14 #2052
> [  144.212319] Call Trace:
> [  144.212323]  [<ffffffff8104662f>] warn_slowpath_common+0x7f/0xc0
> [  144.212326]  [<ffffffff8104668a>] warn_slowpath_null+0x1a/0x20
> [  144.212328]  [<ffffffff8103f606>] migrate_disable+0x1b6/0x200
> [  144.212331]  [<ffffffff8105a2a8>] ptrace_stop+0x128/0x240
> [  144.212334]  [<ffffffff81057b9b>] ? recalc_sigpending+0x1b/0x50
> [  144.212337]  [<ffffffff8105b6f1>] get_signal_to_deliver+0x211/0x530
> [  144.212340]  [<ffffffff81001835>] do_signal+0x75/0x7a0
> [  144.212342]  [<ffffffff8105ae68>] ? kill_pid_info+0x58/0x80
> [  144.212344]  [<ffffffff8105c34c>] ? sys_kill+0xac/0x1e0
> [  144.212347]  [<ffffffff81001fe5>] do_notify_resume+0x65/0x80
> [  144.212350]  [<ffffffff8135978b>] int_signal+0x12/0x17
> [  144.212352] ---[ end trace 0000000000000002 ]---


Right, that's because of 
53da1d9456fe7f87a920a78fdbdcf1225d197cb7, I think we simply want a full
revert of that for -rt.


