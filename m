Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab1DFVVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:21:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755465Ab1DFVVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:21:52 -0400
Date: Wed, 6 Apr 2011 17:21:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: GPF in __call_for_each_cic
Message-ID: <20110406212140.GI18777@redhat.com>
References: <20110331223034.GA31371@redhat.com>
 <4D95D630.4010806@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D95D630.4010806@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 03:42:08PM +0200, Jens Axboe wrote:
> On 2011-04-01 00:30, Dave Jones wrote:
> > Just hit this on current git head.
> > 
> > 	Dave
> > 
> >  general protection fault: 0000 [#1] SMP 
> >  last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
> >  CPU 0 
> >  Modules linked in: cmtp kernelcapi can_bcm rfcomm sctp libcrc32c hidp bnep af_802154 ipx p8022 p8023 rds phonet decnet pppoe pppox ppp_generic slhc appletalk psnap llc af_key can rose ax25 irda crc_ccitt atm tun tcp_lp nfs fscache fuse nfsd lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput arc4 iwlagn mac80211 snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_usb_audio snd_hda_codec btusb bluetooth snd_seq uvcvideo snd_pcm dell_wmi cfg80211 sparse_keymap snd_hwdep zaurus snd_usbmidi_lib videodev dell_laptop snd_rawmidi snd_timer cdc_ether dcdbas snd_seq_device usbnet microcode v4l2_compat_ioctl32 mii cdc_acm snd cdc_wdm iTCO_wdt joydev tg3 rfkill i2c_i801 pcspkr iTCO_vendor_support soundcore snd_page_alloc wmi i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
> >  
> >  Pid: 14365, comm: trinity Not tainted 2.6.38-09065-g89078d5-dirty #6 Dell Inc. Adamo 13   /0N70T0
> >  RIP: 0010:[<ffffffff8125703b>]  [<ffffffff8125703b>] __call_for_each_cic+0x32/0x51
> >  RSP: 0018:ffff880007c05e28  EFLAGS: 00010202
> >  RAX: 0000000000000001 RBX: ffff88010e48abd0 RCX: 0000042c0d869707
> >  RDX: 0000000000000246 RSI: ffffffff81a268f0 RDI: 0000000000000246
> >  RBP: ffff880007c05e48 R08: 0000000000000286 R09: 0000000000000001
> >  R10: ffff88010e48abf8 R11: ffffffff8125893b R12: ffffffff8125708a
> >  R13: 6b6b6b6b6b6b6b6b R14: ffff880007c05c08 R15: 0000000000000001
> >  FS:  0000000000000000(0000) GS:ffff88013fa00000(0000) knlGS:0000000000000000
> >  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >  CR2: 000000000157ea88 CR3: 0000000001a03000 CR4: 00000000000406f0
> >  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> >  Process trinity (pid: 14365, threadinfo ffff880007c04000, task ffff88007c99a3b0)
> >  Stack:
> >   ffff880007c05c08 ffff88010e48abd0 ffff88007c99a3b0 ffff88007c99a980
> >   ffff880007c05e58 ffffffff8125706f ffff880007c05e78 ffffffff8124c70c
> >   ffff880007c05e78 ffff88010e48abd0 ffff880007c05ea8 ffffffff8124c798
> >  Call Trace:
> >   [<ffffffff8125706f>] cfq_free_io_context+0x15/0x17
> >   [<ffffffff8124c70c>] put_io_context+0x44/0x61
> >   [<ffffffff8124c798>] exit_io_context+0x6f/0x77
> >   [<ffffffff8105e9c6>] do_exit+0x759/0x780
> >   [<ffffffff814cdaf7>] ? schedule+0x6d9/0x70b
> >   [<ffffffff8105ec67>] do_group_exit+0x88/0xb6
> >   [<ffffffff8105ecac>] sys_exit_group+0x17/0x1b
> >   [<ffffffff814d6bc2>] system_call_fastpath+0x16/0x1b
> >  Code: 54 53 48 83 ec 08 0f 1f 44 00 00 4c 8b af 80 00 00 00 48 89 fb 49 89 f4 e8 e3 db e1 ff 85 c0 74 05 e8 ac ff ff ff 4d 85 ed 74 17 
> >   8b 45 00 49 8d 75 b0 48 89 df 0f 18 08 41 ff d4 4d 8b 6d 00 
> >  RIP  [<ffffffff8125703b>] __call_for_each_cic+0x32/0x51
> >   RSP <ffff880007c05e28>
> >  ---[ end trace 044e02f5767b491a ]---
> >  Fixing recursive fault but reboot is needed!
> 
> This looks like the ellusive cic bug that has never been fixed and
> strikes once in a blue moon. What was the system doing?

Indeed. It looks very similar. One of the previous bugs is here.

https://bugzilla.redhat.com/show_bug.cgi?id=577968

In the past we thought it was some kind of list corruption and first
element of list was fine and problem happend when we tried to go to
second element of list and accessed some freed element.

The difference this time seems to be that RBX is not set to
"6b6b6b6b6b6b6b6b".

CCing Jeff. He has spent lot of time on this issue in the past.

Thanks
Vivek
