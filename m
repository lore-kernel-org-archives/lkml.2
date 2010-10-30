Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0J3VRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:17:47 -0400
Received: from frost.carfax.org.uk ([212.13.194.111]:4597 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab0J3VRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:17:41 -0400
X-Greylist: delayed 2854 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Oct 2010 17:17:40 EDT
Date: Sat, 30 Oct 2010 21:30:02 +0100
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: linux-kernel@vger.kernel.org
Subject: NETDEV WATCHDOG breaking network drivers
Message-ID: <20101030203002.GA2393@selene>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.20 (2009-06-14)
X-frost.carfax.org.uk-Spam-Score: -0.0 (/)
X-frost.carfax.org.uk-Spam-Report: Spam detection software, running on the system "spamd0.lon.bitfolk.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Hi, I've been getting these NETDEV WATCHDOG errors at infrequent
	intervals (typically every few weeks; sometimes far more often, as has happened
	this week), but usually at inconvenient times -- making a TV recording over
	NFS, for example. It's usually at some point when the network and disk subsystem
	are stressed together. [...] 
	Content analysis details:   (-0.0 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-0.0 T_RP_MATCHES_RCVD      Envelope sender domain matches handover relay
	domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi,

   I've been getting these NETDEV WATCHDOG errors at infrequent
intervals (typically every few weeks; sometimes far more often, as has
happened this week), but usually at inconvenient times -- making a TV
recording over NFS, for example. It's usually at some point when the
network and disk subsystem are stressed together.

   The network doesn't come back, even if I remove and reinsert the
network card driver. I even bought a new network card with a different
chip, and saw a precisely similar problem from that (I've included
that trace below, too).

   These have happened on a range of kernels since at least 2.6.31.  I
include a selection of kernel logs, including one from the other
network card. I've seen it on distribution kernels (Debian),
kernel.org kernels, and the btrfs dev kernel (that's the
2.6.34-81023-g2ebc346 version).

   Can anyone help me diagnose and fix the problem?

   Hugo.


Oct 30 19:57:09 vlad kernel: ------------[ cut here ]------------
Oct 30 19:57:09 vlad kernel: WARNING: at net/sched/sch_generic.c:258 dev_watchdog+0x104/0x188()
Oct 30 19:57:09 vlad kernel: Hardware name: System Product Name
Oct 30 19:57:09 vlad kernel: NETDEV WATCHDOG: eth2 (via-rhine): transmit queue 0 timed out
Oct 30 19:57:09 vlad kernel: Modules linked in: loop cpufreq_userspace nfsd nfs lockd nfs_acl auth_rpcgss sunrpc bridge stp llc ipv6 xfs exportfs btrfs zlib_deflate hwmon_vid powernow_k8 mperf sr_mod sbp2 ieee1394 ide_generic ide_gd_mod ide_cd_mod cdrom pl2303 usbserial k8temp i2c_viapro hwmon 8250_pnp evdev i2c_core 8250 serial_core pcspkr usbhid processor button dm_mirror dm_region_hash dm_log dm_snapshot dm_mod usb_storage usb_libusual raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 md_mod ehci_hcd via_rhine uhci_hcd mii usbcore via82cxxx sd_mod ide_pci_generic ide_core floppy thermal fan unix [last unloaded: scsi_wait_scan]
Oct 30 19:57:09 vlad kernel: Pid: 10565, comm: btrfs Not tainted 2.6.36 #1
Oct 30 19:57:09 vlad kernel: Call Trace:
Oct 30 19:57:09 vlad kernel: <IRQ>  [<ffffffff811e9bb9>] ? dev_watchdog+0x104/0x188
Oct 30 19:57:09 vlad kernel: [<ffffffff811e9bb9>] ? dev_watchdog+0x104/0x188
Oct 30 19:57:09 vlad kernel: [<ffffffff810234d0>] ? warn_slowpath_common+0x78/0x8d
Oct 30 19:57:09 vlad kernel: [<ffffffff811e9ab5>] ? dev_watchdog+0x0/0x188
Oct 30 19:57:09 vlad kernel: [<ffffffff810235a4>] ? warn_slowpath_fmt+0x56/0x5e
Oct 30 19:57:09 vlad kernel: [<ffffffff811219bd>] ? __blk_run_queue+0x45/0x72
Oct 30 19:57:09 vlad kernel: [<ffffffff81199db2>] ? scsi_run_queue+0x1fc/0x254
Oct 30 19:57:09 vlad kernel: [<ffffffff811d80c0>] ? netdev_drivername+0x3b/0x40
Oct 30 19:57:09 vlad kernel: [<ffffffff811e9bb9>] ? dev_watchdog+0x104/0x188
Oct 30 19:57:09 vlad kernel: [<ffffffff81190065>] ? print_cpus_offline+0x13/0xdd
Oct 30 19:57:09 vlad kernel: [<ffffffff8102bd5b>] ? run_timer_softirq+0x14e/0x1c8
Oct 30 19:57:09 vlad kernel: [<ffffffff810275cb>] ? __do_softirq+0x6b/0xe4
Oct 30 19:57:09 vlad kernel: [<ffffffff8103f3ba>] ? tick_dev_program_event+0x2d/0xe9
Oct 30 19:57:09 vlad kernel: [<ffffffff810029ea>] ? call_softirq+0x1a/0x24
Oct 30 19:57:09 vlad kernel: [<ffffffff81003e17>] ? do_softirq+0x2f/0x61
Oct 30 19:57:09 vlad kernel: [<ffffffff81027344>] ? irq_exit+0x34/0x71
Oct 30 19:57:09 vlad kernel: [<ffffffff81013b19>] ? smp_apic_timer_interrupt+0x71/0x7b
Oct 30 19:57:09 vlad kernel: [<ffffffff81002613>] ? apic_timer_interrupt+0x13/0x20
Oct 30 19:57:09 vlad kernel: <EOI>  [<ffffffff81127fe8>] ? cfq_queue_empty+0x0/0x16
Oct 30 19:57:09 vlad kernel: [<ffffffff81120f5a>] ? generic_make_request+0x24d/0x290
Oct 30 19:57:09 vlad kernel: [<ffffffff81120f3c>] ? generic_make_request+0x22f/0x290
Oct 30 19:57:09 vlad kernel: [<ffffffffa031663e>] ? __btrfs_map_block+0x3fa/0x40b [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffff8112103a>] ? submit_bio+0x9d/0xa4
Oct 30 19:57:09 vlad kernel: [<ffffffffa0317113>] ? btrfs_map_bio+0x177/0x1cf [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffffa0310b12>] ? submit_one_bio+0x6a/0x92 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffffa0310c57>] ? submit_extent_page+0x11d/0x205 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffffa0313c28>] ? end_bio_extent_readpage+0x0/0x1d5 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffffa03137a1>] ? __extent_read_full_page+0x538/0x5a4 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffffa0313c28>] ? end_bio_extent_readpage+0x0/0x1d5 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffff81059704>] ? __alloc_pages_nodemask+0x2a0/0x5c0
Oct 30 19:57:09 vlad kernel: [<ffffffffa02fe908>] ? btrfs_get_extent+0x0/0x753 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffffa02fe908>] ? btrfs_get_extent+0x0/0x753 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffffa0313ba1>] ? extent_readpages+0x9f/0xe1 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffff8105acf1>] ? __do_page_cache_readahead+0x121/0x1b9
Oct 30 19:57:09 vlad kernel: [<ffffffff8105ada5>] ? ra_submit+0x1c/0x20
Oct 30 19:57:09 vlad kernel: [<ffffffffa032bf6b>] ? relocate_file_extent_cluster+0x143/0x321 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffffa032d287>] ? relocate_block_group+0x344/0x4c3 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffffa02f7bfa>] ? btrfs_clean_old_snapshots+0x7b/0x133 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffffa032d4f7>] ? btrfs_relocate_block_group+0xf1/0x21e [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffffa0317a4b>] ? btrfs_relocate_chunk+0x60/0x450 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffffa0307e64>] ? btrfs_dev_extent_chunk_offset+0xb6/0xc2 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffffa031803a>] ? btrfs_shrink_device+0x1ff/0x32c [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffff8101fc76>] ? dequeue_task_fair+0x2c/0x195
Oct 30 19:57:09 vlad kernel: [<ffffffffa031c0fd>] ? btrfs_ioctl_resize+0x1fb/0x230 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffffa031db0d>] ? btrfs_ioctl+0x5c0/0x873 [btrfs]
Oct 30 19:57:09 vlad kernel: [<ffffffff8102df2e>] ? ptrace_stop+0x100/0x105
Oct 30 19:57:09 vlad kernel: [<ffffffff8102e360>] ? ptrace_notify+0x68/0x72
Oct 30 19:57:09 vlad kernel: [<ffffffff81082c56>] ? do_vfs_ioctl+0x41b/0x45c
Oct 30 19:57:09 vlad kernel: [<ffffffff81082cd4>] ? sys_ioctl+0x3d/0x5c
Oct 30 19:57:09 vlad kernel: [<ffffffff81001ee7>] ? tracesys+0xcf/0xd4
Oct 30 19:57:09 vlad kernel: ---[ end trace 9befef6a80bf1095 ]---
Oct 30 19:57:09 vlad kernel: eth2: Transmit timed out, status 0003, PHY status 786d, resetting...
Oct 30 19:57:09 vlad kernel: eth2: link up, 100Mbps, full-duplex, lpa 0xCDE1
Oct 30 19:58:07 vlad kernel: eth2: Transmit timed out, status 0003, PHY status 786d, resetting...
Oct 30 19:58:07 vlad kernel: eth2: link up, 100Mbps, full-duplex, lpa 0xCDE1


Oct 24 19:34:41 vlad kernel: ------------[ cut here ]------------
Oct 24 19:34:41 vlad kernel: WARNING: at net/sched/sch_generic.c:258 dev_watchdog+0x104/0x188()
Oct 24 19:34:41 vlad kernel: Hardware name: System Product Name
Oct 24 19:34:41 vlad kernel: NETDEV WATCHDOG: eth3 (r8169): transmit queue 0 timed out
Oct 24 19:34:41 vlad kernel: Modules linked in: cpufreq_userspace nfsd nfs lockd nfs_acl auth_rpcgss sunrpc bridge stp llc ipv6 xfs exportfs btrfs zlib_deflate hwmon_vid powernow_k8 mperf sr_mod sbp2 ieee1394 ide_generic ide_gd_mod ide_cd_mod cdrom evdev pcspkr k8temp hwmon i2c_viapro pl2303 i2c_core usbserial usbhid 8250_pnp 8250 serial_core processor button dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 md_mod usb_storage usb_libusual r8169 ehci_hcd via_rhine uhci_hcd mii usbcore via82cxxx ide_pci_generic sd_mod ide_core floppy thermal fan unix [last unloaded: scsi_wait_scan]
Oct 24 19:34:41 vlad kernel: Pid: 0, comm: swapper Not tainted 2.6.36 #1
Oct 24 19:34:41 vlad kernel: Call Trace:
Oct 24 19:34:41 vlad kernel: <IRQ>  [<ffffffff811e9bb9>] ? dev_watchdog+0x104/0x188
Oct 24 19:34:41 vlad kernel: [<ffffffff811e9bb9>] ? dev_watchdog+0x104/0x188
Oct 24 19:34:41 vlad kernel: [<ffffffff810234d0>] ? warn_slowpath_common+0x78/0x8d
Oct 24 19:34:41 vlad kernel: [<ffffffff811e9ab5>] ? dev_watchdog+0x0/0x188
Oct 24 19:34:41 vlad kernel: [<ffffffff810235a4>] ? warn_slowpath_fmt+0x56/0x5e
Oct 24 19:34:41 vlad kernel: [<ffffffff811c5c39>] ? hid_input_report+0x1bc/0x1d9
Oct 24 19:34:41 vlad kernel: [<ffffffff811d80c0>] ? netdev_drivername+0x3b/0x40
Oct 24 19:34:41 vlad kernel: [<ffffffff811e9bb9>] ? dev_watchdog+0x104/0x188
Oct 24 19:34:41 vlad kernel: [<ffffffff81033425>] ? wq_worker_waking_up+0x8/0x27
Oct 24 19:34:41 vlad kernel: [<ffffffff8102bd5b>] ? run_timer_softirq+0x14e/0x1c8
Oct 24 19:34:41 vlad kernel: [<ffffffff810275cb>] ? __do_softirq+0x6b/0xe4
Oct 24 19:34:41 vlad kernel: [<ffffffff8103f3ba>] ? tick_dev_program_event+0x2d/0xe9
Oct 24 19:34:41 vlad kernel: [<ffffffff810029ea>] ? call_softirq+0x1a/0x24
Oct 24 19:34:41 vlad kernel: [<ffffffff81003e17>] ? do_softirq+0x2f/0x61
Oct 24 19:34:41 vlad kernel: [<ffffffff81027344>] ? irq_exit+0x34/0x71
Oct 24 19:34:41 vlad kernel: [<ffffffff81013b19>] ? smp_apic_timer_interrupt+0x71/0x7b
Oct 24 19:34:41 vlad kernel: [<ffffffff81002613>] ? apic_timer_interrupt+0x13/0x20
Oct 24 19:34:41 vlad kernel: <EOI>  [<ffffffff81007a0e>] ? default_idle+0x1c/0x2f
Oct 24 19:34:41 vlad kernel: [<ffffffff810011ac>] ? cpu_idle+0x32/0x67
Oct 24 19:34:41 vlad kernel: [<ffffffff81375af3>] ? start_kernel+0x301/0x30d
Oct 24 19:34:41 vlad kernel: [<ffffffff81386e1e>] ? __reserve_early+0xa4/0xba
Oct 24 19:34:41 vlad kernel: [<ffffffff81375388>] ? x86_64_start_kernel+0xe8/0xee
Oct 24 19:34:41 vlad kernel: ---[ end trace 97448884c23863b0 ]---


Oct 22 21:10:50 vlad kernel: ------------[ cut here ]------------
Oct 22 21:10:50 vlad kernel: WARNING: at net/sched/sch_generic.c:256 dev_watchdog+0xfa/0x18a()
Oct 22 21:10:50 vlad kernel: Hardware name: System Product Name
Oct 22 21:10:50 vlad kernel: NETDEV WATCHDOG: eth2 (via-rhine): transmit queue 0 timed out
Oct 22 21:10:50 vlad kernel: Modules linked in: tcp_diag inet_diag loop cpufreq_userspace nfsd nfs lockd nfs_acl auth_rpcgss sunrpc bridge stp llc ipv6 xfs exportfs btrfs zlib_deflate hwmon_vid powernow_k8 sbp2 ieee1394 ide_generic ide_gd_mod ide_cd_mod evdev pcspkr i2c_viapro k8temp i2c_core hwmon pl2303 usbhid usbserial 8250_pnp 8250 serial_core button processor dm_mirror dm_region_hash dm_log dm_snapshot dm_mod usb_storage usb_libusual raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 md_mod sg sr_mod cdrom ehci_hcd via82cxxx via_rhine uhci_hcd mii sd_mod usbcore pata_via ide_pci_generic ide_core floppy thermal fan unix [last unloaded: scsi_wait_scan]
Oct 22 21:10:50 vlad kernel: Pid: 0, comm: swapper Not tainted 2.6.34-81023-g2ebc346 #1
Oct 22 21:10:50 vlad kernel: Call Trace:
Oct 22 21:10:50 vlad kernel: <IRQ>  [<ffffffff811dcb92>] ? dev_watchdog+0xfa/0x18a
Oct 22 21:10:50 vlad kernel: [<ffffffff811dcb92>] ? dev_watchdog+0xfa/0x18a
Oct 22 21:10:50 vlad kernel: [<ffffffff810222ed>] ? warn_slowpath_common+0x77/0xa3
Oct 22 21:10:50 vlad kernel: [<ffffffff811dca98>] ? dev_watchdog+0x0/0x18a
Oct 22 21:10:50 vlad kernel: [<ffffffff81022375>] ? warn_slowpath_fmt+0x51/0x59
Oct 22 21:10:50 vlad kernel: [<ffffffff8101d67c>] ? activate_task+0x41/0x50
Oct 22 21:10:50 vlad kernel: [<ffffffff811cb90d>] ? netdev_drivername+0x3b/0x40
Oct 22 21:10:50 vlad kernel: [<ffffffff811dcb92>] ? dev_watchdog+0xfa/0x18a
Oct 22 21:10:50 vlad kernel: [<ffffffff8102f866>] ? delayed_work_timer_fn+0x0/0x13
Oct 22 21:10:50 vlad kernel: [<ffffffff8102a550>] ? run_timer_softirq+0x146/0x19c
Oct 22 21:10:50 vlad kernel: [<ffffffff810263cf>] ? __do_softirq+0x6b/0xe4
Oct 22 21:10:50 vlad kernel: [<ffffffff8103b8b2>] ? tick_dev_program_event+0x2d/0xe9
Oct 22 21:10:50 vlad kernel: [<ffffffff810029ea>] ? call_softirq+0x1a/0x24
Oct 22 21:10:50 vlad kernel: [<ffffffff81003f0b>] ? do_softirq+0x2f/0x61
Oct 22 21:10:50 vlad kernel: [<ffffffff8102614a>] ? irq_exit+0x34/0x6f
Oct 22 21:10:50 vlad kernel: [<ffffffff81012861>] ? smp_apic_timer_interrupt+0x71/0x7b
Oct 22 21:10:50 vlad kernel: [<ffffffff81002613>] ? apic_timer_interrupt+0x13/0x20
Oct 22 21:10:50 vlad kernel: <EOI>  [<ffffffff81007c2c>] ? default_idle+0x1a/0x2d
Oct 22 21:10:50 vlad kernel: [<ffffffff810011c4>] ? cpu_idle+0x2e/0x65
Oct 22 21:10:50 vlad kernel: [<ffffffff8135faf2>] ? start_kernel+0x30b/0x317
Oct 22 21:10:50 vlad kernel: [<ffffffff8137029b>] ? __reserve_early+0xa4/0xba
Oct 22 21:10:50 vlad kernel: [<ffffffff8135f385>] ? x86_64_start_kernel+0xe5/0xeb
Oct 22 21:10:50 vlad kernel: ---[ end trace 0dea117d671a2125 ]---
Oct 22 21:10:50 vlad kernel: eth2: Transmit timed out, status 0003, PHY status 786d, resetting...
Oct 22 21:10:50 vlad kernel: eth2: link up, 100Mbps, full-duplex, lpa 0xCDE1
Oct 22 21:10:54 vlad kernel: eth2: Transmit timed out, status 0003, PHY status 786d, resetting...
Oct 22 21:10:54 vlad kernel: eth2: link up, 100Mbps, full-duplex, lpa 0xCDE1


Oct 21 21:35:40 vlad kernel: ------------[ cut here ]------------
Oct 21 21:35:40 vlad kernel: WARNING: at net/sched/sch_generic.c:256 dev_watchdog+0xfa/0x18a()
Oct 21 21:35:40 vlad kernel: Hardware name: System Product Name
Oct 21 21:35:40 vlad kernel: NETDEV WATCHDOG: eth2 (via-rhine): transmit queue 0 timed out
Oct 21 21:35:40 vlad kernel: Modules linked in: tcp_diag inet_diag loop cpufreq_userspace nfsd nfs lockd nfs_acl auth_rpcgss sunrpc bridge stp llc ipv6 xfs exportfs btrfs zlib_deflate hwmon_vid powernow_k8 sbp2 ieee1394 ide_generic ide_gd_mod ide_cd_mod evdev pcspkr k8temp hwmon i2c_viapro pl2303 i2c_core usbserial usbhid 8250_pnp 8250 serial_core processor button dm_mirror dm_region_hash dm_log dm_snapshot dm_mod usb_storage usb_libusual raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 md_mod sg sr_mod cdrom ehci_hcd via82cxxx uhci_hcd via_rhine ide_pci_generic mii usbcore pata_via sd_mod ide_core floppy thermal fan unix [last unloaded: scsi_wait_scan]
Oct 21 21:35:40 vlad kernel: Pid: 0, comm: swapper Not tainted 2.6.34-81023-g2ebc346 #1
Oct 21 21:35:40 vlad kernel: Call Trace:
Oct 21 21:35:40 vlad kernel: <IRQ>  [<ffffffff811dcb92>] ? dev_watchdog+0xfa/0x18a
Oct 21 21:35:40 vlad kernel: [<ffffffff811dcb92>] ? dev_watchdog+0xfa/0x18a
Oct 21 21:35:40 vlad kernel: [<ffffffff810222ed>] ? warn_slowpath_common+0x77/0xa3
Oct 21 21:35:40 vlad kernel: [<ffffffff811dca98>] ? dev_watchdog+0x0/0x18a
Oct 21 21:35:40 vlad kernel: [<ffffffff81022375>] ? warn_slowpath_fmt+0x51/0x59
Oct 21 21:35:40 vlad kernel: [<ffffffff8101d67c>] ? activate_task+0x41/0x50
Oct 21 21:35:40 vlad kernel: [<ffffffffa03f9ac2>] ? br_transmit_config+0x129/0x130 [bridge]
Oct 21 21:35:40 vlad kernel: [<ffffffff811cb90d>] ? netdev_drivername+0x3b/0x40
Oct 21 21:35:40 vlad kernel: [<ffffffff811dcb92>] ? dev_watchdog+0xfa/0x18a
Oct 21 21:35:40 vlad kernel: [<ffffffffa03f9b6e>] ? br_config_bpdu_generation+0x41/0x5e [bridge]
Oct 21 21:35:40 vlad kernel: [<ffffffff8102a550>] ? run_timer_softirq+0x146/0x19c
Oct 21 21:35:40 vlad kernel: [<ffffffff810263cf>] ? __do_softirq+0x6b/0xe4
Oct 21 21:35:40 vlad kernel: [<ffffffff8103b8b2>] ? tick_dev_program_event+0x2d/0xe9
Oct 21 21:35:40 vlad kernel: [<ffffffff810029ea>] ? call_softirq+0x1a/0x24
Oct 21 21:35:40 vlad kernel: [<ffffffff81003f0b>] ? do_softirq+0x2f/0x61
Oct 21 21:35:40 vlad kernel: [<ffffffff8102614a>] ? irq_exit+0x34/0x6f
Oct 21 21:35:40 vlad kernel: [<ffffffff81012861>] ? smp_apic_timer_interrupt+0x71/0x7b
Oct 21 21:35:40 vlad kernel: [<ffffffff81002613>] ? apic_timer_interrupt+0x13/0x20
Oct 21 21:35:40 vlad kernel: <EOI>  [<ffffffff81007c2c>] ? default_idle+0x1a/0x2d
Oct 21 21:35:40 vlad kernel: [<ffffffff810011c4>] ? cpu_idle+0x2e/0x65
Oct 21 21:35:40 vlad kernel: [<ffffffff8135faf2>] ? start_kernel+0x30b/0x317
Oct 21 21:35:40 vlad kernel: [<ffffffff8137029b>] ? __reserve_early+0xa4/0xba
Oct 21 21:35:40 vlad kernel: [<ffffffff8135f385>] ? x86_64_start_kernel+0xe5/0xeb
Oct 21 21:35:40 vlad kernel: ---[ end trace cd249e97d2f719b2 ]---
Oct 21 21:35:40 vlad kernel: eth2: Transmit timed out, status 0003, PHY status 786d, resetting...
Oct 21 21:35:40 vlad kernel: eth2: link up, 100Mbps, full-duplex, lpa 0xCDE1


hrm@vlad:~ $ cat /proc/interrupts 
           CPU0       
  0:         26   IO-APIC-edge      timer
  1:          2   IO-APIC-edge      i8042
  6:        291   IO-APIC-edge      floppy
  7:          1   IO-APIC-edge    
  9:          0   IO-APIC-fasteoi   acpi
 12:          3   IO-APIC-edge      i8042
 14:          0   IO-APIC-edge      ide0
 15:          0   IO-APIC-edge      ide1
 20:         40   IO-APIC-fasteoi   uhci_hcd:usb1
 21:      46347   IO-APIC-fasteoi   ahci, uhci_hcd:usb3
 22:       3245   IO-APIC-fasteoi   uhci_hcd:usb2, ehci_hcd:usb5
 23:   19459767   IO-APIC-fasteoi   uhci_hcd:usb4, eth2
 28:    1838365   IO-APIC-fasteoi   ahci
NMI:          0   Non-maskable interrupts
LOC:     426837   Local timer interrupts
SPU:          0   Spurious interrupts
PMI:          0   Performance monitoring interrupts
PND:          0   Performance pending work
THR:          0   Threshold APIC interrupts
MCE:          0   Machine check exceptions
MCP:         13   Machine check polls
ERR:          1
MIS:          0


-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Python is executable pseudocode; perl ---              
                        is executable line-noise.                        

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFMzIBJIKyzvlFcI40RAkl2AJkBAOlBIKn74RmK7f5UvReiT0iaoQCgkrjJ
w3ZZn/jcusJU7CCHjJ76rC4=
=IpZM
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
