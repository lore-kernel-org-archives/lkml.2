Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab1IBFO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 01:14:27 -0400
Received: from mail.agmk.net ([91.192.224.71]:44043 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab1IBFOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 01:14:23 -0400
X-Greylist: delayed 1266 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Sep 2011 01:14:22 EDT
From: =?iso-8859-2?q?Pawe=B3_Sikora?= <pluto@agmk.net>
To: Keith Packard <keithp@keithp.com>
Subject: Re: Linux 3.1-rc4
Date: Fri, 2 Sep 2011 06:52:59 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.8-3; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kamal@canonical.com
References: <2352775.A2sX9R5EWV@pawels> <yun8vqccjlp.fsf@aiko.keithp.com>
In-Reply-To: <yun8vqccjlp.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_rEGYO0wdMzPl0+7"
Message-Id: <201109020652.59327.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_rEGYO0wdMzPl0+7
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8bit

On Monday 29 of August 2011 17:39:46 Keith Packard wrote:
> On Mon, 29 Aug 2011 15:22:10 +0200, Pawel Sikora <pluto@agmk.net> wrote:
> > Aug 29 15:10:55 vmx kernel: [22761.103401] BUG: unable to handle kernel paging request at 000000104a69c2f8
> > Aug 29 15:10:55 vmx kernel: [22761.103403] IP: [<ffffffff81265d02>] fb_flashcursor+0x42/0x150
> 
> I'm assuming this is a regression; can you find a version that it worked
> on without any other changes in the environment? I'm concerned that
> you're loading both vesafb and then switching to the drm fb, which
> always seems fraught with peril to me.
> 
> And, of course, a bisect would be most helpful if possible. I can't
> think of any i915-specific changes that would cause fb mappings to go wrong.

git bisect shows the 695434e1cbd57f404110bf4ab187a5127ffd79bb as a first commit
which prints fb_flashcursor ooops but this commit is imho completely unrelated,
so probably there's a hidden bug exposed by minimal binary code movement.

the testcease is:

$login_as_root_locally
run locally 'service fbset start'
$login_as_root_via_ssh_to_grab_dmesg
run locally 'Xorg -configure'

BR,
Pawe³.

--Boundary-00=_rEGYO0wdMzPl0+7
Content-Type: text/plain;
  charset="iso-8859-2";
  name="NOTES.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="NOTES.txt"

695434e1cbd57f404110bf4ab187a5127ffd79bb is the first bad commit
commit 695434e1cbd57f404110bf4ab187a5127ffd79bb
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Fri Jun 3 20:59:19 2011 -0700

    target: Add transport_handle_cdb_direct optimization

    This patch adds a transport_handle_cdb_direct() optimization for mapping
    and queueing tasks directly from within fabric processing context by calling
    the newly exported transport_generic_new_cmd().  This currently expects to
    be called from process context only, and will fail if called within interrupt
    context.

    This patch also leaves transport_generic_handle_cdb() unmodified for the
    moment to function as expected with existing tcm_fc and ib_srpt fabrics,
    and will be removed once these have been converted and tested with v4.1
    code using transport_handle_cdb_direct().

    Based on Andy's original patch here:

    [PATCH 39/42] target: Call transport_new_cmd instead of adding to cmd queue

    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

:040000 040000 9f09fd83ce55852ccb4f703bb21961164eb8476b 67b288d8264ca6b6b855afd85815adf975284b1c M      drivers
:040000 040000 9a643f652b9ae20a6104825bda4c9332a20861d2 c1e743054644097f8364fdc2b2d1e68d6823d562 M      include


[   45.610251] uvesafb: Intel Corporation, Intel(R)Sandybridge Mobile Graphics Controller, Hardware Version 0.0, OEM: Intel(R)Sandybridge Mobile Graphics Chipset Accelerated VGA BIOS, VBE v3.0
[   45.617877] uvesafb: VBIOS/hardware supports DDC2 transfers
[   45.630268] uvesafb: monitor limits: vf = 60 Hz, hf = 57 kHz, clk = 107 MHz
[   45.630361] uvesafb: scrolling: redraw
[   45.630372] mtrr: type mismatch for b0000000,800000 old: write-back new: write-combining
[   45.630376] mtrr: type mismatch for b0000000,400000 old: write-back new: write-combining
[   45.630380] mtrr: type mismatch for b0000000,200000 old: write-back new: write-combining
[   45.630384] mtrr: type mismatch for b0000000,100000 old: write-back new: write-combining
[   45.630388] mtrr: type mismatch for b0000000,80000 old: write-back new: write-combining
[   45.630391] mtrr: type mismatch for b0000000,40000 old: write-back new: write-combining
[   45.630395] mtrr: type mismatch for b0000000,20000 old: write-back new: write-combining
[   45.630399] mtrr: type mismatch for b0000000,10000 old: write-back new: write-combining
[   45.630402] mtrr: type mismatch for b0000000,8000 old: write-back new: write-combining
[   45.630406] mtrr: type mismatch for b0000000,4000 old: write-back new: write-combining
[   45.630410] mtrr: type mismatch for b0000000,2000 old: write-back new: write-combining
[   45.630413] mtrr: type mismatch for b0000000,1000 old: write-back new: write-combining
[   45.720004] Console: switching to colour frame buffer device 80x30
[   45.720476] uvesafb: framebuffer at 0xb0000000, mapped to 0xffffc90006b00000, using 6144k, total 65472k
[   45.720478] fb0: VESA VGA frame buffer device
[   62.997425] [drm] Initialized drm 1.1.0 20060810
[   63.067327] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   63.067332] i915 0000:00:02.0: setting latency timer to 64
[   63.165994] mtrr: type mismatch for b0000000,10000000 old: write-back new: write-combining
[   63.165998] [drm] MTRR allocation failed.  Graphics performance may suffer.
[   63.167207] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[   63.167214] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   63.167216] [drm] Driver supports precise vblank timestamp query.
[   63.167502] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[   63.167770] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[   63.167833] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   63.167836] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
[   63.404653] fbcon: inteldrmfb (fb1) is primary device
[   63.404656] fbcon: Remapping primary device, fb1, to tty 1-63
[   63.918888] fb1: inteldrmfb frame buffer device
[   63.918890] drm: registered panic notifier
[   63.918943] BUG: unable to handle kernel paging request at 000000104a696098
[   63.918947] IP: [<ffffffff81254522>] fb_flashcursor+0x42/0x150
[   63.918953] PGD 0 
[   63.918955] Oops: 0000 [#1] SMP 
[   63.918958] CPU 2 
[   63.918959] Modules linked in: i915(+) drm_kms_helper drm i2c_algo_bit uvesafb binfmt_misc sch_sfq ext2 raid1 uvcvideo videodev media v4l2_compat_ioctl32 ath3k btusb bluetooth rfkill intel_agp intel_gtt joydev i2c_i801 iTCO_wdt i2c_core iTCO_vendor_support psmouse atl1c xhci_hcd ehci_hcd usbcore wmi evdev serio_raw pcspkr video sr_mod ac processor thermal button battery cdrom sg ext4 mbcache jbd2 crc16 dm_mod sd_mod crc_t10dif raid10 md_mod ahci libahci libata scsi_mod [last unloaded: scsi_wait_scan]
[   63.918982] 
[   63.918985] Pid: 1665, comm: kworker/2:1 Not tainted 3.0.0-00014-g695434e1 #23 ASUSTeK Computer Inc. N73SV/N73SV
[   63.918988] RIP: 0010:[<ffffffff81254522>]  [<ffffffff81254522>] fb_flashcursor+0x42/0x150
[   63.918992] RSP: 0018:ffff88033b0c7db0  EFLAGS: 00010217
[   63.918994] RAX: 0000000219191917 RBX: ffff88033ad86000 RCX: 0000000000000000
[   63.918998] RDX: 0000000000000000 RSI: 0000000000000282 RDI: ffffffff818131b0
[   63.919001] RBP: ffff88033b0c7e00 R08: ffff88033b0c6000 R09: 0000000000000000
[   63.919004] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88034fa4c980
[   63.919007] R13: ffff88033609d338 R14: ffffffff812544e0 R15: ffff8803360c16d0
[   63.919010] FS:  0000000000000000(0000) GS:ffff88034fa40000(0000) knlGS:0000000000000000
[   63.919013] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   63.919016] CR2: 000000104a696098 CR3: 0000000001803000 CR4: 00000000000406e0
[   63.919019] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   63.919022] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   63.919025] Process kworker/2:1 (pid: 1665, threadinfo ffff88033b0c6000, task ffff88033ae24600)
[   63.919028] Stack:
[   63.919030]  ffff88034fa4c980 ffff88034fa54100 ffffffff810f8290 ffff88034fa54105
[   63.919035]  ffff88033b0c7de0 ffff88033ad86000 ffff88034fa4c980 ffff88034fa54100
[   63.919039]  ffffffff812544e0 ffff88034fa54105 ffff88033b0c7e70 ffffffff810619f5
[   63.919044] Call Trace:
[   63.919051]  [<ffffffff810f8290>] ? refresh_cpu_vm_stats+0x160/0x160
[   63.919055]  [<ffffffff812544e0>] ? get_color.isra.15+0x160/0x160
[   63.919061]  [<ffffffff810619f5>] process_one_work+0x105/0x460
[   63.919066]  [<ffffffff8106231f>] worker_thread+0x15f/0x350
[   63.919070]  [<ffffffff810621c0>] ? manage_workers.isra.29+0x220/0x220
[   63.919075]  [<ffffffff81066d27>] kthread+0x87/0x90
[   63.919080]  [<ffffffff81416b94>] kernel_thread_helper+0x4/0x10
[   63.919084]  [<ffffffff81066ca0>] ? kthread_worker_fn+0x190/0x190
[   63.919088]  [<ffffffff81416b90>] ? gs_change+0xb/0xb
[   63.919090] Code: 4c 89 75 f0 4c 89 7d f8 4c 8b bf 38 02 00 00 e8 75 28 df ff 4d 85 ff 74 2b 41 8b 87 98 01 00 00 83 f8 ff 74 1f 48 98 48 8d 04 80 
[   63.919110]  8b 1c c5 e0 97 a0 81 48 85 db 74 0c 48 8b 83 60 02 00 00 48 
[   63.919120] RIP  [<ffffffff81254522>] fb_flashcursor+0x42/0x150
[   63.919124]  RSP <ffff88033b0c7db0>
[   63.919125] CR2: 000000104a696098
[   63.919135] ---[ end trace 7470efece6d02648 ]---
[   63.919157] BUG: unable to handle kernel paging request at fffffffffffffff8
[   63.919161] IP: [<ffffffff81066feb>] kthread_data+0xb/0x20
[   63.919165] PGD 1805067 PUD 1806067 PMD 0 
[   63.919168] Oops: 0000 [#2] SMP 
[   63.919171] CPU 2 
[   63.919172] Modules linked in: i915(+) drm_kms_helper drm i2c_algo_bit uvesafb binfmt_misc sch_sfq ext2 raid1 uvcvideo videodev media v4l2_compat_ioctl32 ath3k btusb bluetooth rfkill intel_agp intel_gtt joydev i2c_i801 iTCO_wdt i2c_core iTCO_vendor_support psmouse atl1c xhci_hcd ehci_hcd usbcore wmi evdev serio_raw pcspkr video sr_mod ac processor thermal button battery cdrom sg ext4 mbcache jbd2 crc16 dm_mod sd_mod crc_t10dif raid10 md_mod ahci libahci libata scsi_mod [last unloaded: scsi_wait_scan]
[   63.919206]
[   63.919208] Pid: 1665, comm: kworker/2:1 Tainted: G      D     3.0.0-00014-g695434e1 #23 ASUSTeK Computer Inc. N73SV/N73SV
[   63.919213] RIP: 0010:[<ffffffff81066feb>]  [<ffffffff81066feb>] kthread_data+0xb/0x20
[   63.919217] RSP: 0018:ffff88033b0c7918  EFLAGS: 00010096
[   63.919219] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000002
[   63.919222] RDX: ffff88034fa50840 RSI: 0000000000000002 RDI: ffff88033ae24600
[   63.919225] RBP: ffff88033b0c7918 R08: 0000000000989680 R09: ffff88033a9a32a8
[   63.919228] R10: 0000000000000400 R11: ffff88033c640158 R12: ffff88033ae248b8
[   63.919230] R13: 0000000000000002 R14: 0000000000000002 R15: ffff88033ae247c0
[   63.919234] FS:  0000000000000000(0000) GS:ffff88034fa40000(0000) knlGS:0000000000000000
[   63.919236] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   63.919239] CR2: fffffffffffffff8 CR3: 0000000001803000 CR4: 00000000000406e0
[   63.919241] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   63.919244] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   63.919247] Process kworker/2:1 (pid: 1665, threadinfo ffff88033b0c6000, task ffff88033ae24600)
[   63.919249] Stack:
[   63.919250]  ffff88033b0c7938 ffffffff810630b0 ffffffff81043def ffff88034fa50840
[   63.919255]  ffff88033b0c7a68 ffffffff8140bf9f ffff88034f0423d8 ffffea000b4d1b00
[   63.919259]  ffff88033b0c7998 ffff88033b0c7fd8 ffff88033b0c7fd8 0000000000004000
[   63.919263] Call Trace:
[   63.919267]  [<ffffffff810630b0>] wq_worker_sleeping+0x10/0xa0
[   63.919272]  [<ffffffff81043def>] ? __cleanup_sighand+0x1f/0x30
[   63.919278]  [<ffffffff8140bf9f>] schedule+0x55f/0xa10
[   63.919284]  [<ffffffff810b44a0>] ? call_rcu_sched+0x10/0x20
[   63.919288]  [<ffffffff81048593>] ? release_task+0x2b3/0x440
[   63.919293]  [<ffffffff8106c15f>] ? switch_task_namespaces+0x1f/0x60
[   63.919298]  [<ffffffff8104a080>] do_exit+0x5d0/0x890
[   63.919301]  [<ffffffff8140f48d>] oops_end+0x9d/0xe0
[   63.919305]  [<ffffffff81406a43>] no_context+0x204/0x213
[   63.919309]  [<ffffffff8140bd48>] ? schedule+0x308/0xa10
[   63.919313]  [<ffffffff81406bd5>] __bad_area_nosemaphore+0x183/0x1a6
[   63.919317]  [<ffffffff812544e0>] ? get_color.isra.15+0x160/0x160
[   63.919321]  [<ffffffff81406c06>] bad_area_nosemaphore+0xe/0x10
[   63.919325]  [<ffffffff81411ab8>] do_page_fault+0x428/0x4e0
[   63.919328]  [<ffffffff812544e0>] ? get_color.isra.15+0x160/0x160
[   63.919333]  [<ffffffff8140ccb5>] ? schedule_timeout+0x295/0x310
[   63.919337]  [<ffffffff8103a7af>] ? dequeue_task_fair+0x1af/0x220
[   63.919341]  [<ffffffff812544e0>] ? get_color.isra.15+0x160/0x160
[   63.919344]  [<ffffffff8140e91f>] page_fault+0x1f/0x30
[   63.919347]  [<ffffffff812544e0>] ? get_color.isra.15+0x160/0x160
[   63.919351]  [<ffffffff81254522>] ? fb_flashcursor+0x42/0x150
[   63.919355]  [<ffffffff810f8290>] ? refresh_cpu_vm_stats+0x160/0x160
[   63.919359]  [<ffffffff812544e0>] ? get_color.isra.15+0x160/0x160
[   63.919363]  [<ffffffff810619f5>] process_one_work+0x105/0x460
[   63.919367]  [<ffffffff8106231f>] worker_thread+0x15f/0x350
[   63.919371]  [<ffffffff810621c0>] ? manage_workers.isra.29+0x220/0x220
[   63.919375]  [<ffffffff81066d27>] kthread+0x87/0x90
[   63.919378]  [<ffffffff81416b94>] kernel_thread_helper+0x4/0x10
[   63.919382]  [<ffffffff81066ca0>] ? kthread_worker_fn+0x190/0x190
[   63.919386]  [<ffffffff81416b90>] ? gs_change+0xb/0xb
[   63.919388] Code: be c9 00 00 00 48 c7 c7 b1 e7 71 81 e8 df f0 fd ff 48 8b 5d f0 4c 8b 65 f8 c9 c3 0f 1f 44 00 00 48 8b 87 60 02 00 00 55 48 89 e5
[   63.919407]  8b 40 f8 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
[   63.919417] RIP  [<ffffffff81066feb>] kthread_data+0xb/0x20
[   63.919420]  RSP <ffff88033b0c7918>
[   63.919422] CR2: fffffffffffffff8
[   63.919424] ---[ end trace 7470efece6d02649 ]---
[   63.919426] Fixing recursive fault but reboot is needed!
[   63.924693] ACPI Warning: _BQC returned an invalid level (20110413/video-473)
[   63.925577] acpi device:4f: registered as cooling_device8
[   63.925835] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:4b/LNXVIDEO:00/input/input7
[   63.926011] ACPI: Video Device [GFX0] (multi-head: yes  rom: yes  post: no)

--Boundary-00=_rEGYO0wdMzPl0+7--
