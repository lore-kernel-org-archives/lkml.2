Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab2BUXsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 18:48:22 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52833 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2BUXsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 18:48:20 -0500
Date: Tue, 21 Feb 2012 15:47:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: detected stall on CPU 1 (t=0 jiffies) - huh?
Message-ID: <20120221234744.GV2375@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F3FAC6E.4020001@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4F3FAC6E.4020001@imap.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022123-1976-0000-0000-00000ACD7D45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 02:49:34PM +0100, Tilman Schmidt wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Last night my working machine produced the attached kernel messages.
> The machine was completely idle at the time. If I understand
> Documentation/RCU/stallwarn.txt and kernel/linux/kernel/rcutree.c
> correctly, "t=0 jiffies" is somewhat nonsensical.

Strange indeed!  This is actually possible in the case where the grace
period ends just as the stall-warning code notices that the previous
grace period was too long, but the odds against this are quite high.

> uname -a says:
> Linux xenon 3.2.2-capigig #1 SMP PREEMPT Sat Jan 28 01:59:16 CET 2012
> x86_64 x86_64 x86_64 GNU/Linux
> 
> The processor is a dual core Intel Pentium D. The taint is from the
> VirtualBox modules, in case it matters.
> 
> Should I just ignore that message?

Could you please send your .config?

							Thanx, Paul

> - -- 
> Tilman Schmidt                    E-Mail: tilman@imap.cc
> Bonn, Germany
> Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
> Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.16 (GNU/Linux)
> Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/
> 
> iEYEARECAAYFAk8/rG4ACgkQQ3+did9BuFv8dwCfSSaVbbxc4twuBL7SwHTWxCAY
> eF0An0zXGf7dDmu4wVu48yu8e9y25Y5Z
> =N9Xg
> -----END PGP SIGNATURE-----

> [1389988.051712] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on tmds encoder (output 3)
> [1396398.635011] INFO: rcu_bh detected stall on CPU 1 (t=0 jiffies)
> [1396398.635011] sending NMI to all CPUs:
> [1396398.635011] NMI backtrace for cpu 1
> [1396398.635011] CPU 1 
> [1396398.635011] Modules linked in: nls_utf8 sha256_generic ansi_cprng krng eseqiv rng cryptd crypto_wq aes_x86_64 aes_generic cbc cryptomgr aead pcompress dm_crypt crypto_hash crypto_blkcipher crypto_algapi nls_iso8859_1 nls_cp437 vfat fat ip6t_LOG xt_pkttype ipt_LOG xt_limit xt_tcpudp vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) fuse af_packet edd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables snd_pcm_oss snd_mixer_oss cpufreq_conservative cpufreq_userspace snd_seq cpufreq_powersave snd_seq_device acpi_cpufreq mperf capi usblp bas_gigaset gigaset kernelcapi crc_ccitt snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm osst snd_timer e1000e sg st ppdev sr_mod cdrom firewire_ohci firewire_core snd iTCO_wdt crc_itu_t i2c_i801 snd_page_alloc pcspkr iTCO_vendor_support parport_pc tpm_tis parport tpm tpm_bios ext4 jbd2 crc16 linear raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid10 raid1 raid0 nouveau ttm drm_kms_helper drm i2c_algo_bit mxm_wmi wmi video intel_agp button intel_gtt dm_snapshot dm_mod fan processor thermal thermal_sys aic7xxx scsi_transport_spi ata_generic pata_marvell
> [1396398.635011] 
> [1396398.635011] Pid: 14294, comm: firefox-bin Tainted: G        W  O 3.2.2-capigig #1                  /DQ965GF
> [1396398.635011] RIP: 0010:[<ffffffff811d7118>]  [<ffffffff811d7118>] __sw_hweight64+0x67/0x67
> [1396398.635011] RSP: 0000:ffff8801a7c83da0  EFLAGS: 00000006
> [1396398.635011] RAX: ffff88019aca5fd8 RBX: 0000000000002710 RCX: 00000000ffffffff
> [1396398.635011] RDX: 0000000000000000 RSI: 0000000000000c00 RDI: 0000000000000001
> [1396398.635011] RBP: ffff8801a7c83dd8 R08: 0000000000000002 R09: 0000000000000000
> [1396398.635011] R10: ffffffff81a170c0 R11: 0000000000000000 R12: 000000000030c762
> [1396398.635011] R13: ffffffff81a1ff00 R14: 0000000000000000 R15: 7fffffffffffffff
> [1396398.635011] FS:  00007f218b7c6720(0000) GS:ffff8801a7c80000(0000) knlGS:0000000000000000
> [1396398.635011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [1396398.635011] CR2: 00007f217eb02000 CR3: 000000010b499000 CR4: 00000000000006e0
> [1396398.635011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [1396398.635011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [1396398.635011] Process firefox-bin (pid: 14294, threadinfo ffff88019aca4000, task ffff88000bdd5dc0)
> [1396398.635011] Stack:
> [1396398.635011]  ffffffff811c6284 ffff8801a7c83dd8 0000000000002710 ffff8801a7c8d940
> [1396398.635011]  ffffffff81a1ff00 0000000000000000 7fffffffffffffff ffff8801a7c83de8
> [1396398.635011]  ffffffff811c6204 ffff8801a7c83df8 ffffffff811c622d ffff8801a7c83e18
> [1396398.635011] Call Trace:
> [1396398.635011]  <IRQ> 
> [1396398.635011]  [<ffffffff811c6284>] ? delay_tsc+0x23/0xd5
> [1396398.635011]  [<ffffffff811c6204>] __delay+0xa/0xc
> [1396398.635011]  [<ffffffff811c622d>] __const_udelay+0x27/0x29
> [1396398.635011]  [<ffffffff81019e74>] arch_trigger_all_cpu_backtrace+0x62/0x72
> [1396398.635011]  [<ffffffff8109f9fe>] __rcu_pending+0x86/0x3b8
> [1396398.635011]  [<ffffffff81062b6c>] ? tick_nohz_handler+0xd6/0xd6
> [1396398.635011]  [<ffffffff810a02e3>] rcu_check_callbacks+0xe2/0x113
> [1396398.635011]  [<ffffffff81048a0d>] update_process_times+0x3c/0x73
> [1396398.635011]  [<ffffffff81062bdb>] tick_sched_timer+0x6f/0x8f
> [1396398.635011]  [<ffffffff81058910>] __run_hrtimer+0x75/0xeb
> [1396398.635011]  [<ffffffff8105908e>] hrtimer_interrupt+0xdf/0x1b2
> [1396398.635011]  [<ffffffff813f8403>] ? add_preempt_count+0xa9/0xad
> [1396398.635011]  [<ffffffff81019352>] smp_apic_timer_interrupt+0x71/0x84
> [1396398.635011]  [<ffffffff813fac70>] apic_timer_interrupt+0x70/0x80
> [1396398.635011]  <EOI> 
> [1396398.635011]  [<ffffffff813f5a8e>] ? retint_swapgs+0xe/0x13
> [1396398.635011] Code: 48 c1 ea 04 48 8d 04 02 48 ba 0f 0f 0f 0f 0f 0f 0f 0f 48 21 d0 48 ba 01 01 01 01 01 01 01 01 48 0f af c2 48 c1 e8 38 5a 5f 5d c3 <55> 48 89 e5 41 55 41 54 53 48 83 ec 08 65 4c 8b 24 25 88 b6 00 
> [1396398.635011] Call Trace:
> [1396398.635011]  <IRQ>  [<ffffffff811c6284>] ? delay_tsc+0x23/0xd5
> [1396398.635011]  [<ffffffff811c6204>] __delay+0xa/0xc
> [1396398.635011]  [<ffffffff811c622d>] __const_udelay+0x27/0x29
> [1396398.635011]  [<ffffffff81019e74>] arch_trigger_all_cpu_backtrace+0x62/0x72
> [1396398.635011]  [<ffffffff8109f9fe>] __rcu_pending+0x86/0x3b8
> [1396398.635011]  [<ffffffff81062b6c>] ? tick_nohz_handler+0xd6/0xd6
> [1396398.635011]  [<ffffffff810a02e3>] rcu_check_callbacks+0xe2/0x113
> [1396398.635011]  [<ffffffff81048a0d>] update_process_times+0x3c/0x73
> [1396398.635011]  [<ffffffff81062bdb>] tick_sched_timer+0x6f/0x8f
> [1396398.635011]  [<ffffffff81058910>] __run_hrtimer+0x75/0xeb
> [1396398.635011]  [<ffffffff8105908e>] hrtimer_interrupt+0xdf/0x1b2
> [1396398.635011]  [<ffffffff813f8403>] ? add_preempt_count+0xa9/0xad
> [1396398.635011]  [<ffffffff81019352>] smp_apic_timer_interrupt+0x71/0x84
> [1396398.635011]  [<ffffffff813fac70>] apic_timer_interrupt+0x70/0x80
> [1396398.635011]  <EOI>  [<ffffffff813f5a8e>] ? retint_swapgs+0xe/0x13
> [1396398.635670] NMI backtrace for cpu 0
> [1396398.635677] CPU 0 
> [1396398.635681] Modules linked in: nls_utf8 sha256_generic ansi_cprng krng eseqiv rng cryptd crypto_wq aes_x86_64 aes_generic cbc cryptomgr aead pcompress dm_crypt crypto_hash crypto_blkcipher crypto_algapi nls_iso8859_1 nls_cp437 vfat fat ip6t_LOG xt_pkttype ipt_LOG xt_limit xt_tcpudp vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) fuse af_packet edd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables snd_pcm_oss snd_mixer_oss cpufreq_conservative cpufreq_userspace snd_seq cpufreq_powersave snd_seq_device acpi_cpufreq mperf capi usblp bas_gigaset gigaset kernelcapi crc_ccitt snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm osst snd_timer e1000e sg st ppdev sr_mod cdrom firewire_ohci firewire_core snd iTCO_wdt crc_itu_t i2c_i801 snd_page_alloc pcspkr iTCO_vendor_support parport_pc tpm_tis parport tpm tpm_bios ext4 jbd2 crc16 linear raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid10 raid1 raid0 nouveau ttm drm_kms_helper drm i2c_algo_bit mxm_wmi wmi video intel_agp button intel_gtt dm_snapshot dm_mod fan processor thermal thermal_sys aic7xxx scsi_transport_spi ata_generic pata_marvell
> [1396398.635935] 
> [1396398.635941] Pid: 0, comm: swapper/0 Tainted: G        W  O 3.2.2-capigig #1                  /DQ965GF
> [1396398.635952] RIP: 0010:[<ffffffff81008b77>]  [<ffffffff81008b77>] mwait_idle+0x6c/0x88
> [1396398.635966] RSP: 0018:ffffffff81a01ef8  EFLAGS: 00000246
> [1396398.635972] RAX: 0000000000000000 RBX: ffffffff81a00000 RCX: 0000000000000000
> [1396398.635977] RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffffffff81008b6e
> [1396398.635981] RBP: ffffffff81a01ef8 R08: 0000000000000000 R09: 0000000000000001
> [1396398.635987] R10: ffffffff00000002 R11: ffffffff81a87418 R12: ffffffff81a87418
> [1396398.635992] R13: ffff8801a7f21e00 R14: ffffffffffffffff R15: 0000000000000000
> [1396398.635998] FS:  0000000000000000(0000) GS:ffff8801a7c00000(0000) knlGS:0000000000000000
> [1396398.636004] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [1396398.636004] CR2: 00007f696455b000 CR3: 000000019a12a000 CR4: 00000000000006f0
> [1396398.636004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [1396398.636004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [1396398.636004] Process swapper/0 (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a0d020)
> [1396398.636004] Stack:
> [1396398.636004]  ffffffff81a01f28 ffffffff810012b1 ffffffff81a01f28 84c8034076647dfc
> [1396398.636004]  0000000000000002 ffffffff81ae3380 ffffffff81a01f58 ffffffff813de7fc
> [1396398.636004]  ffffffff813de76c ffffffff81ae3380 ffffffff81a01f58 0000000000000000
> [1396398.636004] Call Trace:
> [1396398.636004]  [<ffffffff810012b1>] cpu_idle+0xaf/0xe5
> [1396398.636004]  [<ffffffff813de7fc>] rest_init+0xd0/0xd7
> [1396398.636004]  [<ffffffff813de76c>] ? rest_init+0x40/0xd7
> [1396398.636004]  [<ffffffff81aa1b49>] start_kernel+0x3b7/0x3c2
> [1396398.636004]  [<ffffffff81aa12a6>] x86_64_start_reservations+0xb6/0xba
> [1396398.636004]  [<ffffffff81aa139c>] x86_64_start_kernel+0xf2/0xf9
> [1396398.636004] Code: b6 00 00 48 2d c8 1f 00 00 31 d2 48 89 d1 0f 01 c8 0f ae f0 e8 51 ff ff ff 85 c0 75 10 e8 38 f0 05 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 28 f0 05 00 fb e8 94 e5 1c 00 e8 8f e5 1c 00 eb 06 e8 
> [1396398.636004] Call Trace:
> [1396398.636004]  [<ffffffff810012b1>] cpu_idle+0xaf/0xe5
> [1396398.636004]  [<ffffffff813de7fc>] rest_init+0xd0/0xd7
> [1396398.636004]  [<ffffffff813de76c>] ? rest_init+0x40/0xd7
> [1396398.636004]  [<ffffffff81aa1b49>] start_kernel+0x3b7/0x3c2
> [1396398.636004]  [<ffffffff81aa12a6>] x86_64_start_reservations+0xb6/0xba
> [1396398.636004]  [<ffffffff81aa139c>] x86_64_start_kernel+0xf2/0xf9
> [1433053.535519] bas_gigaset 6-2:1.0: cause code 0523 in connection state 0.

