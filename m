Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab0FPPgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:36:06 -0400
Received: from fieldses.org ([174.143.236.118]:54022 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122Ab0FPPgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:36:04 -0400
Date: Wed, 16 Jun 2010 11:36:03 -0400
To: Chris Vine <chris@cvine.freeserve.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Layton <jlayton@redhat.com>
Subject: Re: nfsd hang and kernel bug in 2.6.35-rc3
Message-ID: <20100616153603.GH10223@fieldses.org>
References: <20100615175034.1e015fbc@boulder.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615175034.1e015fbc@boulder.homenet>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff, is this one of the problems you saw?

--b.

On Tue, Jun 15, 2010 at 05:50:34PM +0100, Chris Vine wrote:
> Booting up kernel 2.6.35-rc3 on my netbook, with the kernel compiled for
> an Atom N270 processor, hangs when starting nfsd.  If I then end the hang
> by rebooting with Ctrl-Alt-Delete, I get a kernel bug reported.  The only
> one of these that has been logged is as follows, as on other boots the bug
> seems to be reported elsewhere but is not committed to syslog, or no bug
> is reported at all (it just hangs):
> 
> ...
> Jun 15 16:06:18 laptop kernel: NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> Jun 15 16:07:18 laptop kernel: svc: failed to register lockdv3 RPC service (errno 110).
> Jun 15 16:07:18 laptop kernel: lockd_up: makesock failed, error=-110
> [Ctrl-Alt-Delete here]
> Jun 15 16:08:21 laptop kernel: lockd_down: no users! task=(null)
> Jun 15 16:08:21 laptop kernel: ------------[ cut here ]------------
> Jun 15 16:08:21 laptop kernel: kernel BUG at fs/lockd/svc.c:347!
> Jun 15 16:08:21 laptop kernel: invalid opcode: 0000 [#1] SMP 
> Jun 15 16:08:21 laptop kernel: last sysfs file: /sys/module/x_tables/initstate
> Jun 15 16:08:21 laptop kernel: Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs xt_recent xt_tcpudp nf_conntrack_ipv4 nf_defrag_i
> pv4 iptable_filter ip_tables xt_helper xt_conntrack xt_state x_tables nf_conntrack_irc nf_conntrack_ftp nf_conntrack pcmcia pcmcia_core cpufreq_on
> demand speedstep_lib acpi_cpufreq freq_table mperf parport_pc parport fuse snd_hda_codec_realtek i915 snd_hda_intel drm_kms_helper snd_hda_codec d
> rm snd_hwdep tg3 uvcvideo i2c_algo_bit snd_pcm videodev rtc_cmos joydev snd_timer rtc_core intel_agp snd soundcore btusb usbhid bluetooth snd_page
> _alloc video led_class agpgart processor sg rtc_lib output thermal libphy psmouse i2c_i801 rfkill evdev serio_raw thermal_sys ac v4l1_compat batte
> ry wmi button hwmon [last unloaded: pcmcia_core]
> Jun 15 16:08:21 laptop kernel: 
> Jun 15 16:08:21 laptop kernel: Pid: 1852, comm: rpc.nfsd Not tainted 2.6.35-rc3 #1 MoutCook/20021,2959
> Jun 15 16:08:21 laptop kernel: EIP: 0060:[<f90ef780>] EFLAGS: 00010286 CPU: 1
> Jun 15 16:08:21 laptop kernel: EIP is at lockd_down+0x70/0x90 [lockd]
> Jun 15 16:08:21 laptop kernel: EAX: 00000028 EBX: f6a9c400 ECX: f69e5ec4 EDX: f90f6be4
> Jun 15 16:08:21 laptop kernel: ESI: f70e7920 EDI: f70e7928 EBP: f9143a60 ESP: f69e5ec0
> Jun 15 16:08:21 laptop kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Jun 15 16:08:21 laptop kernel: Process rpc.nfsd (pid: 1852, ti=f69e4000 task=f7184a20 task.ti=f69e4000)
> Jun 15 16:08:21 laptop kernel: Stack:
> Jun 15 16:08:21 laptop kernel:  f90f6be4 00000000 f9142995 f70e7900 f70e7900 00000801 f909960b f90ef8f1
> Jun 15 16:08:21 laptop kernel: <0> f90f6c74 ffffff92 00000008 00000801 ffffff92 f914279f 00000801 00000000
> Jun 15 16:08:21 laptop kernel: <0> f697c004 f69e5f22 f9143440 f91434eb f71df400 f6c027f8 00000101 00000000
> Jun 15 16:08:21 laptop kernel: Call Trace:
> Jun 15 16:08:21 laptop kernel:  [<f9142995>] ? nfsd_last_thread+0x25/0x60 [nfsd]
> Jun 15 16:08:21 laptop kernel:  [<f909960b>] ? svc_destroy+0x4b/0x130 [sunrpc]
> Jun 15 16:08:21 laptop kernel:  [<f90ef8f1>] ? lockd_up+0x31/0x1c0 [lockd]
> Jun 15 16:08:21 laptop kernel:  [<f914279f>] ? nfsd_svc+0xcf/0x160 [nfsd]
> Jun 15 16:08:21 laptop kernel:  [<f9143440>] ? write_threads+0x0/0xc0 [nfsd]
> Jun 15 16:08:21 laptop kernel:  [<f91434eb>] ? write_threads+0xab/0xc0 [nfsd]
> Jun 15 16:08:21 laptop kernel:  [<c101fb50>] ? do_page_fault+0x0/0x360
> Jun 15 16:08:21 laptop kernel:  [<c11460e1>] ? _copy_from_user+0x31/0x80
> Jun 15 16:08:21 laptop kernel:  [<c10b395f>] ? simple_transaction_get+0x8f/0xa0
> Jun 15 16:08:21 laptop kernel:  [<f9143ab9>] ? nfsctl_transaction_write+0x59/0x70 [nfsd]
> Jun 15 16:08:21 laptop kernel:  [<c1099a20>] ? vfs_write+0xa0/0x160
> Jun 15 16:08:21 laptop kernel:  [<c1099ba1>] ? sys_write+0x41/0x70
> Jun 15 16:08:21 laptop kernel:  [<c12eefc5>] ? syscall_call+0x7/0xb
> Jun 15 16:08:21 laptop kernel: Code: 05 3c 8e 0f f9 00 00 00 00 b8 c8 7c 0f f9 83 c4 08 e9 15 e3 1f c8 a1 38 8e 0f f9 c7 04 24 e4 6b 0f f9 89 44 24 04 e8 3f d4 1f c8 <0f> 0b eb fe c7 04 24 08 6c 0f f9 e8 2f d4 1f c8 0f 0b eb fe 8d 
> Jun 15 16:08:21 laptop kernel: EIP: [<f90ef780>] lockd_down+0x70/0x90 [lockd] SS:ESP 0068:f69e5ec0
> Jun 15 16:08:21 laptop kernel: ---[ end trace 8ca67da05153a656 ]---
> 
> This particular trace is with NFS v4 compiled in, but I get a similar hang
> with only v2/3 compiled in.
> 
> Chris
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
