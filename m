Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0KJEoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 23:44:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53243 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab0KJEoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 23:44:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=f7ItlIRtYFgB7A2ApWOfqvTwBh55dcnnyMSK4TDi80ExNevAj82Rwwzgb8tiLdbvHh
         uH98SpXia776wnCTAp78b94znR8Aq+9XD028FEaqsddgVm/isgSBp3UlHVK+yLf8Y1NT
         UZNPjv5pK6J9Roa2GK3wb7GQOy8NFxBaQZ1Hc=
MIME-Version: 1.0
Date: Tue, 9 Nov 2010 20:44:14 -0800
Message-ID: <AANLkTim+tJXrTkbMOH2OZ304Sc66wEeNGAwGt88sgDdh@mail.gmail.com>
Subject: drm radeon *ERROR* atombios stuck in loop for more than 5secs aborting
From: Justin Mattock <justinmattock@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: airlied@linux.ie, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with running the latest Head on ubuntu 10.10 x86_64 generic .config
etc.. I seem to be seeing
some messages in dmesg with errors:

dmesg | grep drm

[    8.896877] [drm] Initialized drm 1.1.0 20060810
[   13.721203] [drm] radeon defaulting to kernel modesetting.
[   13.721210] [drm] radeon kernel modesetting enabled.
[   13.724920] [drm] initializing kernel modesetting (RV530 0x1002:0x71C5).
[   13.725118] [drm] register mmio base: 0x50300000
[   13.725122] [drm] register mmio size: 65536
[   13.725490] [drm] Generation 2 PCI interface, using max accessible memory
[   13.725662] [drm] radeon: irq initialized.
[   13.727773] [drm] Detected VRAM RAM=128M, BAR=128M
[   13.727779] [drm] RAM width 128bits DDR
[   13.727979] [drm] radeon: 128M of VRAM memory ready
[   13.727984] [drm] radeon: 512M of GTT memory ready.
[   13.728031] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   13.730215] [drm] radeon: 1 quad pipes, 2 z pipes initialized.
[   13.732011] [drm] PCIE GART of 512M enabled (table at 0x00040000).
[   13.732157] [drm] Loading R500 Microcode
[   13.769032] [drm] radeon: ring at 0x0000000008001000
[   13.769073] [drm] ring test succeeded in 7 usecs
[   13.769345] [drm] radeon: ib pool ready.
[   13.769686] [drm] ib test succeeded in 0 usecs
[   13.771650] [drm] Radeon Display Connectors
[   13.771655] [drm] Connector 0:
[   13.771659] [drm]   LVDS
[   13.771664] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68
0x7e6c 0x7e6c
[   13.771668] [drm]   Encoders:
[   13.771671] [drm]     LCD1: INTERNAL_LVTM1
[   13.771675] [drm] Connector 1:
[   13.771678] [drm]   S-video
[   13.771681] [drm]   Encoders:
[   13.771684] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[   13.771688] [drm] Connector 2:
[   13.771690] [drm]   DVI-I
[   13.771694] [drm]   HPD1
[   13.771698] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48
0x7e4c 0x7e4c
[   13.771702] [drm]   Encoders:
[   13.771705] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[   13.771708] [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
[   13.986293] [drm] fb mappable at 0x400C0000
[   13.986299] [drm] vram apper at 0x40000000
[   13.986302] [drm] size 5300224
[   13.986305] [drm] fb depth is 24
[   13.986308] [drm]    pitch is 5888
[   14.034638] fb0: radeondrmfb frame buffer device
[   14.034642] drm: registered panic notifier
[   14.034658] [drm] Initialized radeon 2.7.0 20080528 for
0000:01:00.0 on minor 0
[  101.611455] [drm] radeon: 1 quad pipes, 2 z pipes initialized.
[  101.616231] [drm] PCIE GART of 512M enabled (table at 0x00040000).
[  101.616326] [drm] radeon: ring at 0x0000000008001000
[  101.616364] [drm] ring test succeeded in 8 usecs
[  101.616380] [drm] ib test succeeded in 0 usecs
[  106.740012] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
more than 5secs aborting
[  106.740020] [drm:atom_execute_table_locked] *ERROR* atombios stuck
executing E606 (len 86, WS 4, PS 0) @ 0xE639
[  106.821701] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[  197.711547] [drm] radeon: 1 quad pipes, 2 z pipes initialized.
[  197.716411] [drm] PCIE GART of 512M enabled (table at 0x00040000).
[  197.716480] [drm] radeon: ring at 0x0000000008001000
[  197.716518] [drm] ring test succeeded in 9 usecs
[  197.716534] [drm] ib test succeeded in 0 usecs
[  202.840011] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
more than 5secs aborting
[  202.840019] [drm:atom_execute_table_locked] *ERROR* atombios stuck
executing E606 (len 86, WS 4, PS 0) @ 0xE639
[  202.924248] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[  244.991495] [drm] radeon: 1 quad pipes, 2 z pipes initialized.
[  244.996446] [drm] PCIE GART of 512M enabled (table at 0x00040000).
[  244.996516] [drm] radeon: ring at 0x0000000008001000
[  244.996554] [drm] ring test succeeded in 9 usecs
[  244.996570] [drm] ib test succeeded in 0 usecs
[  250.120011] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
more than 5secs aborting
[  250.120019] [drm:atom_execute_table_locked] *ERROR* atombios stuck
executing E606 (len 86, WS 4, PS 0) @ 0xE639
[  250.218238] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id

should I be worried about these error messages with drm?

also prior too the above, I also noticed that on a clean reboot, once
gdm started everything went blank
then after a few moments everything starts as normal..(cut from dmesg)


[   27.319156] Bluetooth: RFCOMM ver 1.11
[   30.010095] EXT4-fs (sda3): re-mounted. Opts: errors=remount-ro,commit=0
[   46.110136] radeon 0000:01:00.0: GPU lockup CP stall for more than 10000msec
[   46.110144] ------------[ cut here ]------------
[   46.110182] WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:243
radeon_fence_wait+0x365/0x3d0 [radeon]()
[   46.110187] Hardware name: MacBookPro2,2
[   46.110192] GPU lockup (waiting for 0x00000005 last fence id 0x80000000)
[   46.110196] Modules linked in: binfmt_misc rfcomm sco bnep l2cap
kvm_intel kvm parport_pc ppdev radeon arc4 ath9k mac80211 ath9k_common
ath9k_hw ttm drm_kms_helper drm ath btusb cfg80211 firewire_ohci
bluetooth lp joydev sky2 hid_apple video firewire_core applesmc
parport usbhid output led_class hid appletouch input_polldev crc_itu_t
intel_agp i2c_algo_bit intel_gtt isight_firmware
[   46.110260] Pid: 823, comm: Xorg Not tainted 2.6.36+ #1
[   46.110264] Call Trace:
[   46.110278]  [<ffffffff81061e4f>] warn_slowpath_common+0x7f/0xc0
[   46.110285]  [<ffffffff81061f46>] warn_slowpath_fmt+0x46/0x50
[   46.110315]  [<ffffffffa02c6d65>] radeon_fence_wait+0x365/0x3d0 [radeon]
[   46.110324]  [<ffffffff81083bd0>] ? autoremove_wake_function+0x0/0x40
[   46.110354]  [<ffffffffa02c7571>] radeon_sync_obj_wait+0x11/0x20 [radeon]
[   46.110377]  [<ffffffffa016d253>] ttm_bo_wait+0x103/0x1c0 [ttm]
[   46.110393]  [<ffffffffa02de3f6>]
radeon_gem_wait_idle_ioctl+0x96/0x110 [radeon]
[   46.110408]  [<ffffffffa0139bdb>] drm_ioctl+0x42b/0x4e0 [drm]
[   46.110423]  [<ffffffffa02de360>] ?
radeon_gem_wait_idle_ioctl+0x0/0x110 [radeon]
[   46.110427]  [<ffffffff810162e8>] ? save_i387_xstate+0x1c8/0x230
[   46.110431]  [<ffffffff815f9965>] ? _raw_spin_lock_irq+0x15/0x20
[   46.110435]  [<ffffffff8100b432>] ? do_signal+0x182/0x7d0
[   46.110440]  [<ffffffff81271d71>] ? file_has_perm+0xd1/0xe0
[   46.110445]  [<ffffffff8116be59>] do_vfs_ioctl+0xb9/0x690
[   46.110448]  [<ffffffff8116c4b1>] sys_ioctl+0x81/0xa0
[   46.110451]  [<ffffffff8100c365>] ? int_check_syscall_exit_work+0x34/0x3d
[   46.110454]  [<ffffffff8100c0b2>] system_call_fastpath+0x16/0x1b
[   46.110457] ---[ end trace 693ca408b0e7ec7a ]---
[   46.265234] radeon: wait for empty RBBM fifo failed ! Bad things
might happen.
[   46.420735] Failed to wait GUI idle while programming pipes. Bad
things might happen.
[   46.421820] radeon 0000:01:00.0: (rs600_asic_reset:303)
RBBM_STATUS=0xF0116100
[   46.923913] radeon 0000:01:00.0: (rs600_asic_reset:322)
RBBM_STATUS=0x90010140
[   47.424978] radeon 0000:01:00.0: (rs600_asic_reset:330)
RBBM_STATUS=0x10000140
[   47.925583] radeon 0000:01:00.0: (rs600_asic_reset:338)
RBBM_STATUS=0x10000140
[   47.925607] radeon 0000:01:00.0: restoring config space at offset
0x1 (was 0x100403, writing 0x100407)
[   47.926628] radeon 0000:01:00.0: GPU reset succeed
[   47.926630] radeon 0000:01:00.0: GPU reset succeed
[   47.926635] radeon 0000:01:00.0: ffff880031568a00 unpin not necessary
[   48.011499] [drm] radeon: 1 quad pipes, 2 z pipes initialized.
[   48.012366] [drm] PCIE GART of 512M enabled (table at 0x00040000).
[   48.012371] radeon 0000:01:00.0: WB enabled
[   48.012409] [drm] radeon: ring at 0x0000000008001000
[   48.012444] [drm] ring test succeeded in 10 usecs
[   48.012453] [drm] ib test succeeded in 1 usecs
[   50.209828] EXT4-fs (sda3): re-mounted. Opts: errors=remount-ro,commit=0
[   63.994688] wlan0: authenticate with 00:1e:2a:00:67:f0 (try 1)
[   64.002020] wlan0: authenticated
[   64.002045] wlan0: associate with 00:1e:2a:00:67:f0 (try 1)
[   64.004306] wlan0: RX AssocResp from 00:1e:2a:00:67:f0 (capab=0x431
status=0 aid=2)
[   64.004309] wlan0: associated
[   64.004570] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   74.260051] wlan0: no IPv6 routers present
[  282.260047] CE: hpet increased min_delta_ns to 7500 nsec

keep in mind this was in the middle of the merge window, so this might
be fixed...but am unsure..
(only have seen this one once(if I can reproduce this I will bisect)).


-- 
Justin P. Mattock
