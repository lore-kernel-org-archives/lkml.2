Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab2AUTDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 14:03:40 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:35500 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829Ab2AUTDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 14:03:38 -0500
MIME-Version: 1.0
Date: Sat, 21 Jan 2012 20:03:37 +0100
Message-ID: <CAPVoSvSXMvRb=1itu9DjF+s=6zfAChvUxS-x=b8EV9kOZinNpA@mail.gmail.com>
Subject: [3.3-rc1]radeon 0000:07:00.0: GPU lockup CP stall for more than 10000msec
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After updating to kernel 3.3-rc1 I have experienced a lockup of my GPU.
I left my KDE desktop running until the screensaver turned off the
monitors. But on key presses it would not turn back on. Ctrl+Alt+F1 to
switch to another virtual console also did not work.
Alt+SysRq magic still worked, so I was able to force the syslog to
disk and restart the system.

>From the log:
Jan 21 19:30:01 thoregon cron[3960]: (root) CMD (test -x
/usr/sbin/run-crons && /usr/sbin/run-crons)
Jan 21 19:39:41 thoregon kernel: [ 6364.620131] radeon 0000:07:00.0:
GPU lockup CP stall for more than 10000msec
Jan 21 19:39:41 thoregon kernel: [ 6364.620139] GPU lockup (waiting
for 0x0003F1F2 last fence id 0x0003F1F1)
Jan 21 19:39:41 thoregon kernel: [ 6364.636341] radeon 0000:07:00.0:
GPU softreset
Jan 21 19:39:41 thoregon kernel: [ 6364.636348] radeon 0000:07:00.0:
R_008010_GRBM_STATUS=0xA0003028
Jan 21 19:39:41 thoregon kernel: [ 6364.636354] radeon 0000:07:00.0:
R_008014_GRBM_STATUS2=0x00000002
Jan 21 19:39:41 thoregon kernel: [ 6364.620131] radeon 0000:07:00.0:
GPU lockup CP stall for more than 10000msec
Jan 21 19:39:41 thoregon kernel: [ 6364.620139] GPU lockup (waiting
for 0x0003F1F2 last fence id 0x0003F1F1)
Jan 21 19:39:41 thoregon kernel: [ 6364.636341] radeon 0000:07:00.0:
GPU softreset
Jan 21 19:39:41 thoregon kernel: [ 6364.636348] radeon 0000:07:00.0:
R_008010_GRBM_STATUS=0xA0003028
Jan 21 19:39:41 thoregon kernel: [ 6364.636354] radeon 0000:07:00.0:
R_008014_GRBM_STATUS2=0x00000002
Jan 21 19:39:41 thoregon kernel: [ 6364.636359] radeon 0000:07:00.0:
R_000E50_SRBM_STATUS=0x200000C0
Jan 21 19:39:41 thoregon kernel: [ 6364.636370] radeon 0000:07:00.0:
R_008020_GRBM_SOFT_RESET=0x00007FEE
Jan 21 19:39:41 thoregon kernel: [ 6364.651219] radeon 0000:07:00.0:
R_008020_GRBM_SOFT_RESET=0x00000001
Jan 21 19:39:41 thoregon kernel: [ 6364.667212] radeon 0000:07:00.0:
R_008010_GRBM_STATUS=0x00003028
Jan 21 19:39:41 thoregon kernel: [ 6364.667217] radeon 0000:07:00.0:
R_008014_GRBM_STATUS2=0x00000002
Jan 21 19:39:41 thoregon kernel: [ 6364.667223] radeon 0000:07:00.0:
R_000E50_SRBM_STATUS=0x200000C0
Jan 21 19:39:41 thoregon kernel: [ 6364.668226] radeon 0000:07:00.0:
GPU reset succeed
Jan 21 19:39:41 thoregon kernel: [ 6364.673142] [drm] PCIE GART of
512M enabled (table at 0x0000000000040000).
Jan 21 19:39:41 thoregon kernel: [ 6364.673177] radeon 0000:07:00.0: WB enabled
Jan 21 19:39:41 thoregon kernel: [ 6364.673184] [drm] fence driver on
ring 0 use gpu addr 0x20000c00 and cpu addr 0xffff880328636c00
Jan 21 19:39:41 thoregon kernel: [ 6364.719445] [drm] ring test on 0
succeeded in 1 usecs
Jan 21 19:40:01 thoregon cron[3975]: (root) CMD (test -x
/usr/sbin/run-crons && /usr/sbin/run-crons)
Jan 21 19:43:37 thoregon kernel: [ 6600.390150] INFO: task X:3098
blocked for more than 120 seconds.
Jan 21 19:43:37 thoregon kernel: [ 6600.390157] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 21 19:43:37 thoregon kernel: [ 6600.390163] X               D
ffff880337d50a00     0  3098   3077 0x00400000
Jan 21 19:43:37 thoregon kernel: [ 6600.390174]  ffff88031df15080
0000000000000086 ffff8802f5087300 0000000000010a00
Jan 21 19:43:37 thoregon kernel: [ 6600.390185]  ffff88031bf79fd8
0000000000010a00 ffff88031bf78000 ffff88031bf79fd8
Jan 21 19:43:37 thoregon kernel: [ 6600.390194]  0000000000010a00
ffff88031df15080 0000000000010a00 0000000000010a00
Jan 21 19:43:37 thoregon kernel: [ 6600.390203] Call Trace:
Jan 21 19:43:37 thoregon kernel: [ 6600.390219]  [<ffffffff815eee58>]
? __mutex_lock_slowpath+0xc8/0x140
Jan 21 19:43:37 thoregon kernel: [ 6600.390230]  [<ffffffff815eeb4a>]
? mutex_lock+0x1a/0x40
Jan 21 19:43:37 thoregon kernel: [ 6600.390239]  [<ffffffff81352be2>]
? radeon_ib_get+0x52/0x230
Jan 21 19:43:37 thoregon kernel: [ 6600.390249]  [<ffffffff8136e86a>]
? r600_ib_test+0x5a/0x300
Jan 21 19:43:37 thoregon kernel: [ 6600.390258]  [<ffffffff8137246e>]
? rv770_startup+0xf7e/0x1590
Jan 21 19:43:37 thoregon kernel: [ 6600.390267]  [<ffffffff81372d5c>]
? rv770_resume+0x2c/0x90
Jan 21 19:43:37 thoregon kernel: [ 6600.390275]  [<ffffffff8132bd8e>]
? radeon_gpu_reset+0x11e/0x160
Jan 21 19:43:37 thoregon kernel: [ 6600.390284]  [<ffffffff8133ef43>]
? radeon_fence_wait+0x363/0x3b0
Jan 21 19:43:37 thoregon kernel: [ 6600.390293]  [<ffffffff8104f340>]
? wake_up_bit+0x40/0x40
Jan 21 19:43:37 thoregon kernel: [ 6600.390301]  [<ffffffff81352d77>]
? radeon_ib_get+0x1e7/0x230
Jan 21 19:43:37 thoregon kernel: [ 6600.390310]  [<ffffffff81354b4a>]
? radeon_cs_ioctl+0x27a/0x4d0
Jan 21 19:43:37 thoregon kernel: [ 6600.390319]  [<ffffffff812f42d4>]
? drm_ioctl+0x3e4/0x490
Jan 21 19:43:37 thoregon kernel: [ 6600.390327]  [<ffffffff813548d0>]
? radeon_cs_finish_pages+0xa0/0xa0
Jan 21 19:43:37 thoregon kernel: [ 6600.390336]  [<ffffffff81024769>]
? do_page_fault+0x199/0x420
Jan 21 19:43:37 thoregon kernel: [ 6600.390344]  [<ffffffff810af30c>]
? mmap_region+0x1dc/0x570
Jan 21 19:43:37 thoregon kernel: [ 6600.390352]  [<ffffffff810de446>]
? do_vfs_ioctl+0x96/0x4e0
Jan 21 19:43:37 thoregon kernel: [ 6600.390359]  [<ffffffff815efd0c>]
? __schedule+0x28c/0x630
Jan 21 19:43:37 thoregon kernel: [ 6600.390366]  [<ffffffff810de8d9>]
? sys_ioctl+0x49/0x90
Jan 21 19:43:37 thoregon kernel: [ 6600.390375]  [<ffffffff815f16e2>]
? system_call_fastpath+0x16/0x1b
Jan 21 19:45:08 thoregon kernel: [ 6691.864440] SysRq : Emergency Sync
Jan 21 19:45:08 thoregon kernel: [ 6691.864838] Emergency Sync complete
Jan 21 19:45:14 thoregon kernel: [ 6697.476112] SysRq : Emergency Remount R/O
Jan 21 19:46:33 thoregon kernel: [    0.000000] Linux version
3.3.0-rc1 (root@thoregon) (gcc version 4.5.3 (Gentoo 4.5.3-r2 p1.0,
pie-0.4.6) ) #1 SMP Fri Jan 20 09:54:26 CET 2012

I did not have any trouble with 3.2 or earlier kernel, so it looks
like an regression in 3.3-rc1.

Info from my card:
thoregon ~ # lspci -vvs 07:00.0
07:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
ATI RV730 PRO [Radeon HD 4650] (prog-if 00 [VGA controller])
        Subsystem: Hightech Information System Ltd. Device 2269
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 78
        Region 0: Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Region 2: Memory at fe9e0000 (64-bit, non-prefetchable) [size=64K]
        Region 4: I/O ports at e000 [size=256]
        Expansion ROM at fe9c0000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s
L1, Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee3f00c  Data: 4189
        Capabilities: [100 v1] Vendor Specific Information: ID=0001
Rev=1 Len=010 <?>
        Kernel driver in use: radeon

Please ask, if you need any other information, I will try to provide it.

Torsten
