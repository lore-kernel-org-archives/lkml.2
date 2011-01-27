Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1A0KVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:21:32 -0500
Received: from skl2.ukl.uni-freiburg.de ([193.196.199.2]:54699 "EHLO
	relay2.uniklinik-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923Ab1A0KVa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:21:30 -0500
Subject: Re: Linux 2.6.37 x86 ncpfs regression: kernel BUG at
 include/linux/dcache.h:340 with >1366 files in directory
From: "Dr. Bernd Feige" <bernd.feige@uniklinik-freiburg.de>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        david@fromorbit.com, npiggin@gmail.com
In-Reply-To: <1296116547.19078.22.camel@pst15.ukl.uni-freiburg.de>
References: <1296053700.2684.19.camel@pst15.ukl.uni-freiburg.de>
	 <20110126163203.GP22723@ZenIV.linux.org.uk>
	 <1296061412.2684.59.camel@pst15.ukl.uni-freiburg.de>
	 <1296062778.2674.2.camel@pst15.ukl.uni-freiburg.de>
	 <alpine.DEB.2.01.1101261457480.7903@trent.utfs.org>
	 <1296116547.19078.22.camel@pst15.ukl.uni-freiburg.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 11:21:23 +0100
Message-ID: <1296123683.2697.9.camel@pst15.ukl.uni-freiburg.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
X-NAI-Spam-Flag: NO
X-NAI-Spam-Level: *
X-NAI-Spam-Threshold: 5
X-NAI-Spam-Score: 1.2
X-NAI-Spam-Report: 3 Rules triggered
	*  1 -- FROM_ALIAS_QUOTES_EVOL_2
	*  0.2 -- RCVD_FROM_BY_ENVFRM_1_AT_2
	*  0 -- RV3749
X-NAI-Spam-Version: 2.2.0.9286 : core <3749> : streams <589696> : uri
 <788811>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier I wrote...
> So I'm of course glad Nick's patch made it
> into the tree now and would vote for its inclusion in 2.6.37-1.

Now I thought it would be a good idea to check this with 2.6.38-rc2. The
result is a similar crash but no longer confined to large ncpfs
directories. It is also not temporally related to the ls command, but ls
completes, only to give the following seconds later:

kernel: kernel BUG at fs/dcache.c:2102!
kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
kernel: last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq
kernel: Modules linked in: nls_cp437 nls_iso8859_1 ncpfs coretemp cpufreq_ondemand nfs lockd nfs_acl auth_rpcgss sunrpc ipv6 autofs4 snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ext3 jbd mbcache ext2 dm_crypt dm_mod crypto_hash crypto_blkcipher crypto_algapi fuse usb_storage uas usbhid snd_hda_codec_analog fbcon font bitblit softcursor uhci_hcd dcdbas ehci_hcd sr_mod cdrom radeon snd_hda_intel snd_hda_codec ttm snd_pcm drm_kms_helper snd_timer drm snd i2c_algo_bit sg usbcore cfbcopyarea cfbimgblt parport_pc parport psmouse soundcore cfbfillrect snd_page_alloc i2c_i801
kernel: 
kernel: Pid: 2572, comm: bash Not tainted 2.6.38-rc2 #1 0GM819/OptiPlex 755                 
kernel: EIP: 0060:[<c109f13c>] EFLAGS: 00010246 CPU: 1
kernel: EIP is at dentry_update_name_case+0x12/0x46
kernel: EAX: 00000000 EBX: f20f1f00 ECX: ffffffff EDX: f1c59d28
kernel: ESI: f1c59d28 EDI: f1c59d28 EBP: f1c59f34 ESP: f1c59bb8
kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
kernel: Process bash (pid: 2572, ti=f1c58000 task=f283c390 task.ti=f1c58000)
kernel: Stack:
kernel: f20f1f00 f1c59d28 00000001 f1c59f34 f814a7b1 00000000 f3eb2400 f3fae4b8
kernel: 00000000 f1e0fd00 00000004 ff89b000 00000000 00000001 00000002 f1c59f90
kernel: c109d030 625f3231 6f765f66 72657672 65627261 6e757469 70702e67 f5440074
kernel: Call Trace:
kernel: [<f814a7b1>] ? ncp_fill_cache+0x19c/0x3c2 [ncpfs]
kernel: [<c109d030>] ? filldir64+0x0/0xcb
kernel: [<c1001a1c>] ? __switch_to+0x160/0x199
kernel: [<c1021101>] ? finish_task_switch+0x36/0x94
kernel: [<c1254267>] ? schedule+0x67b/0x70b
kernel: [<c1031295>] ? lock_timer_base.clone.25+0x18/0x32
kernel: [<c10316ab>] ? mod_timer+0x12d/0x13e
kernel: [<c1031cf4>] ? recalc_sigpending+0xf/0x2e
kernel: [<f8150746>] ? ncp_do_request+0x341/0x34b [ncpfs]
kernel: [<c103b208>] ? autoremove_wake_function+0x0/0x29
kernel: [<f814ab8b>] ? ncp_do_readdir+0x108/0x152 [ncpfs]
kernel: [<c109d030>] ? filldir64+0x0/0xcb
kernel: [<c106bae7>] ? get_page_from_freelist+0x309/0x373
kernel: [<c106bd58>] ? __alloc_pages_nodemask+0xd0/0x554
kernel: [<c1078e53>] ? do_wp_page+0x278/0x57c
kernel: [<c1077708>] ? page_address+0x8c/0xaa
kernel: [<f814b8ba>] ? ncp_readdir+0x557/0x55c [ncpfs]
kernel: [<c109d030>] ? filldir64+0x0/0xcb
kernel: [<c109d030>] ? filldir64+0x0/0xcb
kernel: [<c109d2c1>] ? vfs_readdir+0x56/0x7a
kernel: [<c109d437>] ? sys_getdents64+0x66/0xa7
kernel: [<c100274c>] ? sysenter_do_call+0x12/0x22
kernel: Code: 89 50 18 eb 0c 8b 48 18 8b 5a 18 89 58 18 89 4a 18 83 c4 04 5b 5e 5f 5d c3 55 57 56 53 fc 89 c3 89 d7 8b 40 20 8b 40 1c 48 75 02 <0f> 0b 8b 42 04 39 43 18 74 02 0f 0b 8d 6b 4c 89 e8 e8 66 64 1b 
kernel: EIP: [<c109f13c>] dentry_update_name_case+0x12/0x46 SS:ESP 0068:f1c59bb8
kernel: ---[ end trace 24c91ac4506eb552 ]---

As far as I can see, 2.6.38-rc1 has the same dcache.c so I didn't try
that.

Best regards,
Bernd
