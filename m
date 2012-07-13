Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab2GMSJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:09:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757Ab2GMSJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:09:02 -0400
Date: Fri, 13 Jul 2012 14:08:23 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: 3.5-rc6 futex_wait_requeue_pi oops.
Message-ID: <20120713180823.GA24972@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Rusty Russell <rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like calling futex() with garbage makes things unhappy.

	Dave


[  673.054286] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[  673.055292] IP: [<ffffffff810d665e>] __lock_acquire+0x5e/0x1ae0
[  673.056225] PGD 1107c8067 PUD 11079c067 PMD 0 
[  673.057224] Oops: 0000 [#1] SMP 
[  673.058248] CPU 3 
[  673.058263] Modules linked in:<4>[  673.069440]  ebt_snat<4>[  673.088955]  xt_cluster<4>[  673.095505]  nls_cp874 nls_cp850 nls_cp869 nls_iso8859_1 nls_iso8859_6 romfs ufs nfs_layout_nfsv41_files blocklayoutdriver nfs ecryptfs cachefiles binfmt_misc udf sysv hfsplus msdos vfat fat cuse fuse cramfs 9p 9pnet ceph libceph hfs befs cifs fscache ncpfs coda affs btrfs squashfs minix hwpoison_inject encrypted_keys tgr192 lzo ansi_cprng rmd128 khazad authencesn ccm salsa20_generic serpent_generic anubis tea blowfish_generic cast6 rmd320 des_generic sha256_generic fcrypt crypto_user ghash_generic camellia_generic md4 twofish_generic crypto_null sha512_generic zlib vmac blowfish_common lrw wp512 gcm cts deflate twofish_common pcrypt rmd160 cast5 authenc xts gf128mul pcbc raid6test michael_mic rmd256 seed xcbc crc8 cpu_notifier_error_inject ts_fsm crc7 ts_bm cordic crc_itu_t ts_kmp lpc_sch mfd_core i2c_dev i2c_pca_platform i2c_diolan_u2c i2c_simtec i2c_isch i2c_scmi i2c_tiny_usb i2c_piix4 i2c_algo_pca i2c_smbus acpi_pad ec_sys sbs sbshc custom_method asus_atk0110 acpi_power_meter pmbus_core cpufreq_stats softdog ioatdma pch_dma usb_storage nosy bonding ixgb e100 ixgbe e1000 ixgbevf igb igbvf team_mode_activebackup team_mode_roundrobin team eql can_dev netconsole ppp_async crc_ccitt pppoe pptp gre ppp_synctty pppox ppp_deflate zlib_deflate arc4 ppp_mppe bsd_comp ppp_generic catc kaweth pegasus rtl8150 ipheth veth slhc dummy mii lxt vitesse mdio_bitbang davicom marvell cicada national ste10Xp broadcom icplus et1011c micrel realtek smsc qsemi mdio vhost_net tun macvtap macvlan cryptoloop brd rtc_max6900 rtc_em3027 rtc_bq32k rtc_ds1286 rtc_m48t59 rtc_ds1511 rtc_ds1672 rtc_rx8025 rtc_isl12022 rtc_ds1374 rtc_stk17ta8 rtc_x1205 rtc_v3020 rtc_rs5c372 rtc_ds3232 rtc_bq4802 rtc_pcf8563 rtc_rx8581 rtc_rv3029c2 rtc_ds1307 rtc_m48t35 rtc_ds1553 rtc_pcf8583 rtc_ds1742 rtc_isl1208 rtc_m41t80 rtc_fm3130 scsi_transport_fc scsi_transport_spi ch scsi_wait_scan raid_class scsi_tgt libsas scsi_transport_sas uio_aec uio_sercos3 uio_cif uio_pci_generic uio timeriomem_rng hangcheck_timer dca pps_ldisc pps_gpio dm_queue_length multipath dm_crypt dm_service_time faulty dm_round_robin dm_log_userspace linear dm_thin_pool dm_persistent_data libcrc32c dm_bufio dm_flakey dm_multipath raid0 dm_raid raid456 raid1 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid10 shpchp fakephp aer_inject ptp pps_core target_core_file target_core_iblock target_core_pscsi tcm_loop target_core_mod vga16fb sysimgblt fb_sys_fops syscopyarea vgastate output platform_lcd lcd sysfillrect n_r3964 n_gsm nozomi jsm serio_raw altera_ps2 input_polldev sparse_keymap uinput ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode usb_debug pcspkr i2c_i801 e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
[  673.095668] 
[  673.095669] Pid: 22872, comm: trinity-child3 Not tainted 3.5.0-rc6+ #107
[  673.095673] RIP: 0010:[<ffffffff810d665e>]  [<ffffffff810d665e>] __lock_acquire+0x5e/0x1ae0
[  673.095679] RSP: 0000:ffff8801107c7a48  EFLAGS: 00010046
[  673.095679] RAX: 0000000000000082 RBX: 0000000000000000 RCX: 0000000000000000
[  673.095680] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000028
[  673.095681] RBP: ffff8801107c7b38 R08: 0000000000000002 R09: 0000000000000000
[  673.095682] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000002
[  673.095683] R13: ffff8800a9144d20 R14: 0000000000000002 R15: 0000000000000028
[  673.095684] FS:  00007f4343491740(0000) GS:ffff880148200000(0000) knlGS:0000000000000000
[  673.095685] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  673.095686] CR2: 0000000000000028 CR3: 000000012d9ba000 CR4: 00000000001407e0
[  673.095687] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  673.095688] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  673.095690] Process trinity-child3 (pid: 22872, threadinfo ffff8801107c6000, task ffff8800a9144d20)
[  673.095690] Stack:
[  673.095691]  ffff8801107c7a58 ffff8800a91455e0 0000000000000002 ffff8800a9144d20
[  673.095695]  000000000000029f ffffffff82959908 ffff8801107c7b78 0000000000000082
[  673.095699]  ffff8801107c7aa8 ffffffff816884f0 ffff8800a9144d20 ffff88013f748000
[  673.095702] Call Trace:
[  673.095703]  [<ffffffff816884f0>] ? _raw_spin_unlock_irq+0x30/0x60
[  673.095708]  [<ffffffff810d941d>] ? trace_hardirqs_on_caller+0x15d/0x1e0
[  673.095710]  [<ffffffff810d94ad>] ? trace_hardirqs_on+0xd/0x10
[  673.095713]  [<ffffffff810d87ed>] lock_acquire+0xad/0x220
[  673.095715]  [<ffffffff810e0104>] ? rt_mutex_finish_proxy_lock+0x34/0xd0
[  673.095717]  [<ffffffff810d3958>] ? trace_hardirqs_off_caller+0x28/0xd0
[  673.095720]  [<ffffffff81687de6>] _raw_spin_lock+0x46/0x80
[  673.095722]  [<ffffffff810e0104>] ? rt_mutex_finish_proxy_lock+0x34/0xd0
[  673.095725]  [<ffffffff810e0104>] rt_mutex_finish_proxy_lock+0x34/0xd0
[  673.095726]  [<ffffffff810ddbd2>] futex_wait_requeue_pi.constprop.20+0x2d2/0x3d0
[  673.095730]  [<ffffffff81097ff0>] ? update_rmtp+0x70/0x70
[  673.095733]  [<ffffffff810993c4>] ? hrtimer_start_range_ns+0x14/0x20
[  673.095736]  [<ffffffff810de42a>] do_futex+0xea/0xa20
[  673.095738]  [<ffffffff810ad759>] ? local_clock+0x99/0xc0
[  673.095741]  [<ffffffff81189443>] ? might_fault+0x53/0xb0
[  673.095746]  [<ffffffff810dee67>] sys_futex+0x107/0x1a0
[  673.095749]  [<ffffffff810d9400>] ? trace_hardirqs_on_caller+0x140/0x1e0
[  673.095751]  [<ffffffff81691b6d>] system_call_fastpath+0x1a/0x1f
[  673.095755] Code: d8 45 0f 45 e0 4c 89 75 f0 4c 89 7d f8 85 c0 0f 84 f8 00 00 00 8b 05 e2 af fa 00 49 89 ff 89 f3 41 89 d2 85 c0 0f 84 02 01 00 00 <49> 8b 07 ba 01 00 00 00 48 3d 20 c4 0c 82 44 0f 44 e2 83 fb 01 
[  673.095789] RIP  [<ffffffff810d665e>] __lock_acquire+0x5e/0x1ae0
[  673.095791]  RSP <ffff8801107c7a48>
[  673.095792] CR2: 0000000000000028
[  673.095793] ---[ end trace c26f1bd418342e06 ]---

