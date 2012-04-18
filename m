Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab2DRLtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 07:49:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab2DRLtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 07:49:00 -0400
Date: Wed, 18 Apr 2012 13:48:44 +0200
From: Jan Kara <jack@suse.cz>
To: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG on fs/inode.c:1442 (linux 3.3.1 and 3.3.2)
Message-ID: <20120418114844.GA22295@quack.suse.cz>
References: <20120415215601.GV1927@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20120415215601.GV1927@vicerveza.homeunix.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Sun 15-04-12 23:56:01, Lluís Batlle i Rossell wrote:
> destroying my openvpn client connection (SIGINT to openvp), in linux 3.3.1 and
> now also in 3.3.2, I noticed this BUG in dmesg (attached).
> 
> It's a vanilla 3.3.2, at this shot.
> 
> I know it never happened to me in any 3.2, but I did not try 3.3.0.
> 
> I attach the .config. And I have the debug info for this kernel too, if this
> helps someone find a fix. But I imagine it's easy to reproduce.
  From the first look it would seem as use after free bug but can you
please post disassembly of iput() function from your kernel? I.e. you load
vmlinux in gdb and run 'disass iput'. Thanks.

								Honza
> [39301.878926] ------------[ cut here ]------------
> [39301.878999] kernel BUG at fs/inode.c:1442!
> [39301.879052] invalid opcode: 0000 [#1] 
> [39301.879105] CPU 0 
> [39301.879133] Modules linked in: reiserfs xts gf128mul af_packet bridge stp nls_iso8859_1 nls_cp437 vfat fat usb_storage usb_libusual uas arc4 iwlwifi mac80211 joydev snd_hda_codec_hdmi uvcvideo snd_hda_codec_realtek videobuf2_core cfg80211 psmouse snd_hda_intel snd_hda_codec acer_wmi videodev sparse_keymap i2c_i801 rfkill sg v4l2_compat_ioctl32 videobuf2_vmalloc rtc_cmos videobuf2_memops pcspkr wmi iTCO_wdt thermal snd_hwdep serio_raw battery ac i915 evdev mac_hid fbcon tileblit font bitblit softcursor drm_kms_helper drm intel_agp i2c_algo_bit button intel_gtt agpgart i2c_core video atl1c tun kvm_intel kvm fuse cpufreq_conservative cpufreq_ondemand cpufreq_powersave cpufreq_performance acpi_cpufreq freq_table processor thermal_sys hwmon mperf snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore nfsd lockd nfs_acl auth_rpcgss exportfs loop sunrpc ipv6 usbhid hid power_supply scsi_wait_scan sr_mod cdrom ehci_hcd uhci_hcd usbcore usb_common lzo sd_mod crc_t10dif ata_piix libata scsi_mod cr
> yptd cbc sha256_generic dm_crypt dm_mod aes_x86_64 aes_generic btrfs zlib_deflate crc32c libcrc32c ext4 jbd2 crc16 ext3 jbd ext2 mbcache unix
> [39301.880010] 
> [39301.880010] Pid: 20915, comm: openvpn Not tainted 3.3.2 #1 Acer Aspire 4810T/Aspire 4810T
> [39301.880010] RIP: 0010:[<ffffffff8113b4f7>]  [<ffffffff8113b4f7>] iput+0x1b7/0x1f0
> [39301.880010] RSP: 0018:ffff880058af1dd8  EFLAGS: 00010202
> [39301.880010] RAX: ffff8800b591ffa0 RBX: ffff8800b591ffa0 RCX: 0000000000000000
> [39301.880010] RDX: ffff8800b591f800 RSI: ffff8800b591fba8 RDI: ffff8800b591ffa0
> [39301.880010] RBP: ffff880058af1df8 R08: dead000000100100 R09: dead000000200200
> [39301.880010] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
> [39301.880010] R13: ffff8800b591fb88 R14: ffff8800b3d3f000 R15: ffff880058af1e68
> [39301.880010] FS:  00007f0fe5e99700(0000) GS:ffffffff81620000(0000) knlGS:0000000000000000
> [39301.880010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [39301.880010] CR2: 00007ffd75a23000 CR3: 0000000057f86000 CR4: 00000000000406f0
> [39301.880010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [39301.880010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [39301.880010] Process openvpn (pid: 20915, threadinfo ffff880058af0000, task ffff8800b53a5980)
> [39301.880010] Stack:
> [39301.880010]  0000000000000000 ffff8800b591ff70 0000000000000000 ffff8800b591fb88
> [39301.880010]  ffff880058af1e18 ffffffff812c9a01 ffff880059afd400 ffffffff81686068
> [39301.880010]  ffff880058af1e38 ffffffff812cec2f ffff880058af1e28 ffff8800b591f800
> [39301.880010] Call Trace:
> [39301.880010]  [<ffffffff812c9a01>] sock_release+0x71/0x90
> [39301.880010]  [<ffffffff812cec2f>] sk_release_kernel+0x2f/0x60
> [39301.880010]  [<ffffffffa0627915>] tun_free_netdev+0x15/0x20 [tun]
> [39301.880010]  [<ffffffff812e2b6c>] netdev_run_todo+0x22c/0x360
> [39301.880010]  [<ffffffff812ec37e>] rtnl_unlock+0xe/0x10
> [39301.880010]  [<ffffffffa06286e5>] tun_chr_close+0xb5/0x100 [tun]
> [39301.880010]  [<ffffffff81124c92>] fput+0xd2/0x210
> [39301.880010]  [<ffffffff81121d46>] filp_close+0x66/0x90
> [39301.880010]  [<ffffffff81121de8>] sys_close+0x78/0xb0
> [39301.880010]  [<ffffffff8137f3a7>] system_call_fastpath+0x16/0x1b
> [39301.880010] Code: 89 8b e0 00 00 00 48 8d 8a 00 01 00 00 48 89 8b e8 00 00 00 48 89 82 00 01 00 00 48 8b 43 28 83 80 10 01 00 00 01 e9 8e fe ff ff <0f> 0b be 76 05 00 00 48 c7 c7 fe 3b 55 81 e8 b6 7d f0 ff e9 9f 
> [39301.880010] RIP  [<ffffffff8113b4f7>] iput+0x1b7/0x1f0
> [39301.880010]  RSP <ffff880058af1dd8>
> [39301.901976] ---[ end trace 5ddcafba128ae2ca ]---


