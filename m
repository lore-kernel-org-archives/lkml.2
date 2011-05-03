Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab1ECQyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:54:04 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:53571 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1ECQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:53:59 -0400
X-WSS-ID: 0LKMPLX-0B-6ZK-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Message-ID: <4DC0330F.6050906@sandia.gov>
Date: Tue, 3 May 2011 10:53:35 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Thunderbird 2.0.0.24 (X11/20110128)
MIME-Version: 1.0
To: James.Bottomley@suse.de
cc: linux-kernel@vger.kernel.org
Subject: 2.6.39-rc5+ BUG at scsi_run_queue+0x24/0xe3
X-Originating-IP: [134.253.95.179]
X-PMX-Version: 5.6.0.2009776, Antispam-Engine: 2.7.2.376379,
 Antispam-Data: 2011.5.3.164220
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report=' SUPERLONG_LINE
 0.05, DATE_TZ_NA 0, WEBMAIL_SOURCE 0, WEBMAIL_XOIP 0, WEBMAIL_X_IP_HDR
 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_XOIP 0,
 __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0,
 __RATWARE_X_MAILER_CS_B 0, __SANE_MSGID 0, __TO_MALFORMED_2 0,
 __TO_NO_NAME 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS ,
 __USER_AGENT 0'
X-TMWD-Spam-Summary: TS=20110503165343; ID=1; SEV=2.3.1;
 DFV=B2011050316; IFV=NA; AIF=B2011050316; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230372E34444330333331372E303036393A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2011050316_5.03.0010
X-WSS-ID: 61DEEC9C2TS2744336-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting this BUG on ~20% of boots with 2.6.39-rc5+:

[   22.607020] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   22.608004] IP: [<ffffffffa019b8c5>] scsi_run_queue+0x24/0xe3 [scsi_mod]
[   22.608004] PGD 22564b067 PUD 222e93067 PMD 0
[   22.608004] Oops: 0000 [#1] SMP
[   22.608004] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb1/usb_device/usbdev1.1/dev
[   22.608004] CPU 0
[   22.608004] Modules linked in: megaraid_sas ide_cd_mod ib_mthca(+) cdrom ib_mad qla2xxx(+) ib_core button scsi_transport_fc scsi_tgt serio_raw ata_piix i5k_amb tpm_tis libata hwmon tpm i5000_edac floppy(+) tpm_bios scsi_mod dcdbas edac_core pcspkr uhci_hcd ehci_hcd iTCO_wdt iTCO_vendor_support rtc nfs nfs_acl auth_rpcgss fscache lockd sunrpc tg3 bnx2 e1000
[   22.608004]
[   22.608004] Pid: 1820, comm: path_id Not tainted 2.6.39-rc5-00139-g9fbc674 #23 Dell Inc. PowerEdge 1950/0DT097
[   22.608004] RIP: 0010:[<ffffffffa019b8c5>]  [<ffffffffa019b8c5>] scsi_run_queue+0x24/0xe3 [scsi_mod]
[   22.608004] RSP: 0000:ffff88022fc03d10  EFLAGS: 00010282
[   22.608004] RAX: ffff8802240ece00 RBX: ffff88022fc03d20 RCX: ffff88022f002900
[   22.608004] RDX: 0000000000000000 RSI: 0000000000000037 RDI: 0000000000000000
[   22.608004] RBP: ffff88022fc03d60 R08: 0000000000000286 R09: ffffea00077e33a0
[   22.608004] R10: ffff88022f002900 R11: ffff88022fc03cf0 R12: ffff880223977740
[   22.608004] R13: ffff8802254b2938 R14: 0000000000000000 R15: ffff880223977740
[   22.608004] FS:  00007f2e084d26e0(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
[   22.608004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.608004] CR2: 0000000000000000 CR3: 0000000222e03000 CR4: 00000000000006f0
[   22.608004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   22.608004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   22.608004] Process path_id (pid: 1820, threadinfo ffff8802236a8000, task ffff8802234d1690)
[   22.608004] Stack:
[   22.608004]  0000000000000282 ffff8802254b2800 0000000000000000 ffff880223977740
[   22.608004]  ffff88022fc03d60 ffff8802240ece00 ffff880223977740 ffff8802254b2938
[   22.608004]  0000000000000000 ffff880223977740 ffff88022fc03d90 ffffffffa019c205
[   22.608004] Call Trace:
[   22.608004]  <IRQ>
[   22.608004]  [<ffffffffa019c205>] scsi_next_command+0x3b/0x4c [scsi_mod]
[   22.608004]  [<ffffffffa019c84a>] scsi_end_request+0x83/0x94 [scsi_mod]
[   22.608004]  [<ffffffffa019cbea>] scsi_io_completion+0x1b0/0x3fb [scsi_mod]
[   22.608004]  [<ffffffffa019b635>] ? spin_unlock_irqrestore+0xe/0x10 [scsi_mod]
[   22.608004]  [<ffffffffa0195159>] scsi_finish_command+0xeb/0xf4 [scsi_mod]
[   22.608004]  [<ffffffffa019d9df>] scsi_softirq_done+0x112/0x11b [scsi_mod]
[   22.608004]  [<ffffffff811c727e>] blk_done_softirq+0x4b/0x61
[   22.608004]  [<ffffffff8104f74c>] __do_softirq+0xbf/0x16e
[   22.608004]  [<ffffffff813b354c>] call_softirq+0x1c/0x30
[   22.608004]  [<ffffffff810041a3>] do_softirq+0x3d/0x86
[   22.608004]  [<ffffffff8104f44a>] invoke_softirq+0x17/0x20
[   22.608004]  [<ffffffff8104fa19>] irq_exit+0x57/0x98
[   22.608004]  [<ffffffff813b3c81>] do_IRQ+0x91/0xa8
[   22.608004]  [<ffffffff813abc53>] common_interrupt+0x13/0x13
[   22.608004]  <EOI>
[   22.608004]  [<ffffffff813abc9a>] ? retint_swapgs+0xe/0x13
[   22.608004] Code: ff ff 5b 41 5c c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 28 0f 1f 44 00 00 49 89 ff 48 8b bf 40 03 00 00 48 8d 5d c0 <4c> 8b 37 48 89 5d c0 48 89 5d c8 48 8b 87 38 01 00 00 f6 80 a4
[   22.608004] RIP  [<ffffffffa019b8c5>] scsi_run_queue+0x24/0xe3 [scsi_mod]
[   22.608004]  RSP <ffff88022fc03d10>
[   22.608004] CR2: 0000000000000000
[   22.929460] ---[ end trace f9ecaaa16661ec4a ]---
[   22.934070] Kernel panic - not syncing: Fatal exception in interrupt
[   22.940410] Pid: 1820, comm: path_id Tainted: G      D     2.6.39-rc5-00139-g9fbc674 #23
[   22.948483] Call Trace:
[   22.950923]  <IRQ>  [<ffffffff8104953e>] ? panic+0xbc/0x1c3
[   22.953064] qla2xxx 0000:0e:00.0: Allocated (64 KB) for EFT...
[   22.953217] qla2xxx 0000:0e:00.0: Allocated (1285 KB) for firmware dump...
[   22.969169]  [<ffffffff813aba57>] ? _raw_spin_unlock_irqrestore+0xe/0x10
[   22.970176] scsi0 : qla2xxx
[   22.970505] qla2xxx 0000:0e:00.0:
[   22.970506]  QLogic Fibre Channel HBA Driver: 8.03.07.00
[   22.970507]   QLogic QLE2462 - PCI-Express Dual Channel 4Gb Fibre Channel HBA
[   22.970508]   ISP2432: PCIe (2.5GT/s x4) @ 0000:0e:00.0 hdma+, host#=0, fw=5.03.13 (496)
[   22.970540] qla2xxx 0000:0e:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   23.009538]  [<ffffffff81049a32>] ? spin_unlock_irqrestore+0xe/0x10
[   23.009544] qla2xxx 0000:0e:00.1: Found an ISP2432, irq 17, iobase 0xffffc9001178c000
[   23.009787] qla2xxx 0000:0e:00.1: irq 107 for MSI/MSI-X
[   23.009856] qla2xxx 0000:0e:00.1: Configuring PCI space...
[   23.009862] qla2xxx 0000:0e:00.1: setting latency timer to 64
[   23.040006]  [<ffffffff8104ada0>] ? kmsg_dump+0x4f/0xe6
[   23.040531] qla2xxx 0000:0e:00.1: Configure NVRAM parameters...
[   23.051121]  [<ffffffff813aca70>] ? oops_end+0xaf/0xbf
[   23.056249]  [<ffffffff8102b04c>] ? no_context+0xea/0xf6
[   23.061550]  [<ffffffff8102b227>] ? __bad_area_nosemaphore+0x107/0x114
[   23.068063]  [<ffffffff8102b2be>] ? bad_area_nosemaphore+0x13/0x15
[   23.074231]  [<ffffffff813aeb28>] ? do_page_fault+0x192/0x331
[   23.076259] qla2xxx 0000:0e:00.1: Verifying loaded RISC code...
[   23.085867]  [<ffffffff8101c7eb>] ? apic_write+0x16/0x18
[   23.086060] qla2xxx 0000:0e:00.1: FW: Loading via request-firmware...
[   23.097590]  [<ffffffff8101ca74>] ? lapic_next_event+0x15/0x19
[   23.103413]  [<ffffffff81072fa9>] ? clockevents_program_event+0x78/0x81
[   23.110014]  [<ffffffff81074428>] ? tick_dev_program_event+0x2f/0x8e
[   23.116357]  [<ffffffff810adeae>] ? trace_hardirqs_off_caller+0x11/0x25
[   23.122959]  [<ffffffff8106bb66>] ? sched_clock_local+0x11/0x76
[   23.128867]  [<ffffffff811dd81a>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[   23.135381]  [<ffffffff813abe8f>] ? page_fault+0x1f/0x30
[   23.140692]  [<ffffffffa019b8c5>] ? scsi_run_queue+0x24/0xe3 [scsi_mod]
[   23.147300]  [<ffffffffa019c205>] ? scsi_next_command+0x3b/0x4c [scsi_mod]
[   23.154166]  [<ffffffffa019c84a>] ? scsi_end_request+0x83/0x94 [scsi_mod]
[   23.160946]  [<ffffffffa019cbea>] ? scsi_io_completion+0x1b0/0x3fb [scsi_mod]
[   23.168072]  [<ffffffffa019b635>] ? spin_unlock_irqrestore+0xe/0x10 [scsi_mod]
[   23.175283]  [<ffffffffa0195159>] ? scsi_finish_command+0xeb/0xf4 [scsi_mod]
[   23.182329]  [<ffffffffa019d9df>] ? scsi_softirq_done+0x112/0x11b [scsi_mod]
[   23.189363]  [<ffffffff811c727e>] ? blk_done_softirq+0x4b/0x61
[   23.195185]  [<ffffffff8104f74c>] ? __do_softirq+0xbf/0x16e
[   23.200745]  [<ffffffff813b354c>] ? call_softirq+0x1c/0x30
[   23.206219]  [<ffffffff810041a3>] ? do_softirq+0x3d/0x86
[   23.211519]  [<ffffffff8104f44a>] ? invoke_softirq+0x17/0x20
[   23.217167]  [<ffffffff8104fa19>] ? irq_exit+0x57/0x98
[   23.222293]  [<ffffffff813b3c81>] ? do_IRQ+0x91/0xa8
[   23.227247]  [<ffffffff813abc53>] ? common_interrupt+0x13/0x13
[   23.233067]  <EOI>  [<ffffffff813abc9a>] ? retint_

I get no BUGs in dozens of boots if I revert commit 86cbfb5607d:

     [SCSI] put stricter guards on queue dead checks

     SCSI uses request_queue->queuedata == NULL as a signal that the queue
     is dying.  We set this state in the sdev release function.  However,
     this allows a small window where we release the last reference but
     haven't quite got to this stage yet and so something will try to take
     a reference in scsi_request_fn and oops.  It's very rare, but we had a
     report here, so we're pushing this as a bug fix

     The actual fix is to set request_queue->queuedata to NULL in
     scsi_remove_device() before we drop the reference.  This causes
     correct automatic rejects from scsi_request_fn as people who hold
     additional references try to submit work and prevents anything from
     getting a new reference to the sdev that way.

     Cc: stable@kernel.org
     Signed-off-by: James Bottomley <James.Bottomley@suse.de>

Please let me know if what further information you need, or if there is
anything I can do, to help resolve this.

Thanks -- Jim

