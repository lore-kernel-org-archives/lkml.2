Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0GLVD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:03:59 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43230 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab0GLVD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:03:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FeqHrf8yRBbYJrIi6UuXlprUElLLdBBJdcG8QEM/tIYG86LUJI1rkyBZnBJn1Suam7
         7Y1zpgRXv4UEM+v8NXn9V2rVHdO+Mww7H3ezf9CEkrnMbbm+LviFbigCgrzmxurB8LPC
         GOatQ9tKQ971QdDJ0bBetjR1ulX0cFqUjDJXI=
MIME-Version: 1.0
In-Reply-To: <AANLkTinnlhzSGP8sRQ8Pr4CIuwn4d859rvSe1yO_3TEz@mail.gmail.com>
References: <AANLkTimkNg81yzxSHTcAa1QlTE9SYmvzL4eOTVHApWq3@mail.gmail.com>
	<AANLkTilvbOb0n9l6F3EHwQg3VfNNmYB1BdFbzL2Cwg_P@mail.gmail.com>
	<AANLkTinnlhzSGP8sRQ8Pr4CIuwn4d859rvSe1yO_3TEz@mail.gmail.com>
Date: Mon, 12 Jul 2010 17:03:55 -0400
Message-ID: <AANLkTim5k9YATi-tE5kbHiyzAdt0lYPZn229JyNmHOjJ@mail.gmail.com>
Subject: Re: Regression 2.6.34->2.6.35-rc4: radeaon KMS an RS690 broken
From: Alex Deucher <alexdeucher@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 3:54 PM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> On Mon, Jul 12, 2010 at 5:23 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> On Sun, Jul 11, 2010 at 3:56 PM, Torsten Kaiser
>> <just.for.lkml@googlemail.com> wrote:
>>> I just tried 2.6.35-rc4 to see, if a different bug is fixed, but noted
>>> that this kernel will only boot with radeon.modeset=0.
>>>
>>> If KMS is active the display turns off and the system is completely
>>> dead, not even SysRq+B is working.
>>>
>>> I build a new kernel with the radeon driver as a module and inserted
>>> it by hand via ssh.
>>> The ssh session, I was using has this output:
>>> ariolc drm # insmod ./drm_kms_helper.ko
>>> ariolc drm # insmod ttm/ttm.ko
>>> ariolc drm # insmod radeon/radeon.ko
>>> Segmentation fault
>>> ariolc drm #
>>>
>>> The final insmod segfaulted, the shell was displaying a new prompt,
>>> but not new input was possible.
>>> The system still reacted to ping and trying to create a new ssh
>>> connection resulted in a password prompt, but after entering the
>>> password no shell was provided.
>>> I tried SysRq+S, SysRq+U and SysRq+B, but not visible result. After a
>>> reboot I did not find any additional information in /var/log/messages.
>>> The effect was like the boot time failures with a builtin radeon
>>> driver: The display (attached to the VGA output) just turns off.
>>>
>>> But I had a second ssh connection open, doing tail -f /var/log/messages:
>>> Jul 11 21:30:23 ariolc kernel: [  131.720470] [drm] radeon defaulting
>>> to kernel modesetting.
>>> Jul 11 21:30:23 ariolc kernel: [  131.720477] [drm] radeon kernel
>>> modesetting enabled.
>>> Jul 11 21:30:23 ariolc kernel: [  131.720623] radeon 0000:01:05.0: PCI
>>> INT A -> GSI 18 (level, low) -> IRQ 18
>>> Jul 11 21:30:23 ariolc kernel: [  131.726859] [drm] initializing
>>> kernel modesetting (RS690 0x1002:0x791E).
>>> Jul 11 21:30:23 ariolc kernel: [  131.728607] [drm] register mmio
>>> base: 0xFE9F0000
>>> Jul 11 21:30:23 ariolc kernel: [  131.728613] [drm] register mmio
>>> size: 65536
>>> Jul 11 21:30:23 ariolc kernel: [  131.729591] ATOM BIOS: ATI
>>> Jul 11 21:30:23 ariolc kernel: [  131.729625] radeon 0000:01:05.0:
>>> VRAM: 32M 0xDE000000 - 0xDFFFFFFF (32M used)
>>> Jul 11 21:30:23 ariolc kernel: [  131.729632] radeon 0000:01:05.0:
>>> GTT: 512M 0xBE000000 - 0xDDFFFFFF
>>> Jul 11 21:30:23 ariolc kernel: [  131.729675] [drm] radeon: irq initialized.
>>> Jul 11 21:30:23 ariolc kernel: [  131.729690] mtrr: type mismatch for
>>> fc000000,2000000 old: write-back new: write-combining
>>> Jul 11 21:30:23 ariolc kernel: [  131.729696] [drm] Detected VRAM
>>> RAM=32M, BAR=32M
>>> Jul 11 21:30:23 ariolc kernel: [  131.729701] [drm] RAM width 128bits DDR
>>> Jul 11 21:30:23 ariolc kernel: [  131.729796] [TTM] Zone  kernel:
>>> Available graphics memory: 2010998 kiB.
>>> Jul 11 21:30:23 ariolc kernel: [  131.729802] [TTM] Initializing pool allocator.
>>> Jul 11 21:30:23 ariolc kernel: [  131.729841] [drm] radeon: 32M of
>>> VRAM memory ready
>>> Jul 11 21:30:23 ariolc kernel: [  131.729846] [drm] radeon: 512M of
>>> GTT memory ready.
>>> Jul 11 21:30:23 ariolc kernel: [  131.729857] [drm] GART: num cpu
>>> pages 131072, num gpu pages 131072
>>> Jul 11 21:30:23 ariolc kernel: [  131.736223] [drm] radeon: 1 quad
>>> pipes, 1 z pipes initialized.
>>> Jul 11 21:30:23 ariolc kernel: [  131.752553] [drm] Loading
>>> RS690/RS740 Microcode
>>> Jul 11 21:30:23 ariolc kernel: [  131.911461] [drm] radeon: ring at
>>> 0x00000000BE000000
>>> Jul 11 21:30:23 ariolc kernel: [  132.055912] [drm:r100_ring_test]
>>> *ERROR* radeon: ring test failed (sracth(0x15E4)=0xCAFEDEAD)
>>> Jul 11 21:30:23 ariolc kernel: [  132.055918] [drm:r100_cp_init]
>>> *ERROR* radeon: cp isn't working (-22).
>>> Jul 11 21:30:23 ariolc kernel: [  132.055925] radeon 0000:01:05.0:
>>> failled initializing CP (-22).
>>> Jul 11 21:30:23 ariolc kernel: [  132.055929] radeon 0000:01:05.0:
>>> Disabling GPU acceleration
>>> Jul 11 21:30:23 ariolc kernel: [  132.056174] [drm] radeon: cp finalized
>>> Jul 11 21:30:23 ariolc kernel: [  132.057378] [drm] Default TV standard: NTSC
>>> Jul 11 21:30:23 ariolc kernel: [  132.058671] [drm] Default TV standard: NTSC
>>> Jul 11 21:30:23 ariolc kernel: [  132.059748] [drm] Radeon Display Connectors
>>> Jul 11 21:30:23 ariolc kernel: [  132.059753] [drm] Connector 0:
>>> Jul 11 21:30:23 ariolc kernel: [  132.059756] [drm]   VGA
>>> Jul 11 21:30:23 ariolc kernel: [  132.059763] [drm]   DDC: 0x7e50
>>> 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48 0x7e5c 0x7e4c
>>> Jul 11 21:30:23 ariolc kernel: [  132.059766] [drm]   Encoders:
>>> Jul 11 21:30:23 ariolc kernel: [  132.059770] [drm]     CRT1:
>>> INTERNAL_KLDSCP_DAC1
>>> Jul 11 21:30:23 ariolc kernel: [  132.059773] [drm] Connector 1:
>>> Jul 11 21:30:23 ariolc kernel: [  132.059776] [drm]   S-video
>>> Jul 11 21:30:23 ariolc kernel: [  132.059778] [drm]   Encoders:
>>> Jul 11 21:30:23 ariolc kernel: [  132.059781] [drm]     TV1:
>>> INTERNAL_KLDSCP_DAC1
>>> Jul 11 21:30:23 ariolc kernel: [  132.059784] [drm] Connector 2:
>>> Jul 11 21:30:23 ariolc kernel: [  132.059787] [drm]   HDMI-A
>>> Jul 11 21:30:23 ariolc kernel: [  132.059792] [drm]   DDC: 0x7e40
>>> 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58 0x7e4c 0x7e5c
>>> Jul 11 21:30:23 ariolc kernel: [  132.059795] [drm]   Encoders:
>>> Jul 11 21:30:23 ariolc kernel: [  132.059798] [drm]     DFP3: INTERNAL_LVTM1
>>> Jul 11 21:30:23 ariolc kernel: [  132.253484] [drm] fb mappable at 0xFC040000
>>> Jul 11 21:30:23 ariolc kernel: [  132.253488] [drm] vram apper at 0xFC000000
>>> Jul 11 21:30:23 ariolc kernel: [  132.253489] [drm] size 786432
>>> Jul 11 21:30:23 ariolc kernel: [  132.253491] [drm] fb depth is 8
>>> Jul 11 21:30:23 ariolc kernel: [  132.253492] [drm]    pitch is 1024
>>> Jul 11 21:30:23 ariolc kernel: [  132.253880] fbcon: radeondrmfb (fb0)
>>> is primary device
>>>
>>> Hardware info: (lspci -vv from 2.6.33)
>>> 00:00.0 Host bridge: ATI Technologies Inc RS690 Host Bridge
>>>        Subsystem: ATI Technologies Inc RS690 Host Bridge
>>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
>>>        Latency: 0
>>>
>>> 00:01.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge
>>> (Internal gfx) (prog-if 00 [Normal decode])
>>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 64
>>>        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
>>>        I/O behind bridge: 0000c000-0000cfff
>>>        Memory behind bridge: fe800000-fe9fffff
>>>        Prefetchable memory behind bridge: 00000000fc000000-00000000fdffffff
>>>        Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>>        BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>>>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>        Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
>>>        Capabilities: [b0] Subsystem: ATI Technologies Inc RS690 PCI
>>> to PCI Bridge (Internal gfx)
>>>
>>> 00:07.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI
>>> Express Port 3) (
>>> prog-if 00 [Normal decode])
>>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- S
>>> ERR+ FastB2B- DisINTx+
>>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort
>>> - >SERR- <PERR- INTx-
>>>        Latency: 0, Cache Line Size: 64 bytes
>>>        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>>>        I/O behind bridge: 0000d000-0000dfff
>>>        Memory behind bridge: fea00000-feafffff
>>>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort
>>> - <SERR- <PERR-
>>>        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>>>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>        Capabilities: [50] Power Management version 3
>>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>>> PME(D0+,D1-,D2-,D3hot+,D3col
>>> d+)
>>>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>>        Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00
>>>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
>>> <64ns, L1 <1us
>>>                        ExtTag+ RBE+ FLReset-
>>>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>>> Unsupported-
>>>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
>>> AuxPwr- TransPend-
>>>                LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1,
>>> Latency L0 <64ns, L1 <1us
>>>                        ClockPM- Surprise- LLActRep+ BwNot-
>>>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
>>> SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>>>                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
>>> HotPlug- Surpise-
>>>                        Slot #  6, PowerLimit 25.000000; Interlock- NoCompl-
>>>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
>>> CmdCplt- HPIrq- LinkChg-
>>>                        Control: AttnInd Off, PwrInd Off, Power- Interlock-
>>>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
>>> PresDet+ Interlock-
>>>                        Changed: MRL- PresDet+ LinkState-
>>>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
>>> PMEIntEna- CRSVisible-
>>>                RootCap: CRSVisible-
>>>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>>>                Address: fee0300c  Data: 4149
>>>        Capabilities: [b0] Subsystem: ATI Technologies Inc RS690 PCI
>>> to PCI Bridge
>>>        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
>>>        Capabilities: [100] Virtual Channel <?>
>>>        Kernel driver in use: pcieport
>>>
>>> KMS was working stable on 2.6.33 and seems to work on 2.6.34 (Not
>>> really tested, because 2.6.34 is not working for me, but I'm not sure
>>> if that is KMS related)
>>>
>>> Output from working KMS in 2.6.33:
>>> [    0.385804] [drm] Initialized drm 1.1.0 20060810
>>> [    0.385896] [drm] radeon defaulting to kernel modesetting.
>>> [    0.385955] [drm] radeon kernel modesetting enabled.
>>> [    0.386066] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
>>> [    0.388388] [drm] radeon: Initializing kernel modesetting.
>>> [    0.388534] [drm] register mmio base: 0xFE9F0000
>>> [    0.388593] [drm] register mmio size: 65536
>>> [    0.389106] ATOM BIOS: ATI
>>> [    0.389374] [drm] GPU reset succeed (RBBM_STATUS=0x10000140)
>>> [    0.389436] [drm] radeon: VRAM 32M
>>> [    0.389495] [drm] radeon: VRAM from 0xDE000000 to 0xDFFFFFFF
>>> [    0.389554] [drm] radeon: GTT 512M
>>> [    0.389612] [drm] radeon: GTT from 0x00000000 to 0x1FFFFFFF
>>> [    0.389688] radeon 0000:01:05.0: irq 25 for MSI/MSI-X
>>> [    0.389692] [drm] radeon: using MSI.
>>> [    0.389766] [drm] radeon: irq initialized.
>>> [    0.389828] mtrr: type mismatch for fc000000,2000000 old:
>>> write-back new: write-combining
>>> [    0.389902] [drm] Detected VRAM RAM=32M, BAR=32M
>>> [    0.389960] [drm] RAM width 128bits DDR
>>> [    0.390238] [TTM] Zone  kernel: Available graphics memory: 2010380 kiB.
>>> [    0.390313] [drm] radeon: 32M of VRAM memory ready
>>> [    0.390372] [drm] radeon: 512M of GTT memory ready.
>>> [    0.390431] [drm] GART: num cpu pages 131072, num gpu pages 131072
>>> [    0.393504] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
>>> [    0.393568] [drm] radeon: cp idle (0x10000C03)
>>> [    0.393691] [drm] Loading RS690/RS740 Microcode
>>> [    0.393751] platform radeon_cp.0: firmware: using built-in firmware
>>> radeon/RS690_cp.bin
>>> [    0.393964] [drm] radeon: ring at 0x0000000000000000
>>> [    0.394039] [drm] ring test succeeded in 1 usecs
>>> [    0.394180] [drm] radeon: ib pool ready.
>>> [    0.394249] [drm] ib test succeeded in 0 usecs
>>> [    0.394454] [drm] Default TV standard: NTSC
>>> [    0.394690] [drm] Radeon Display Connectors
>>> [    0.394749] [drm] Connector 0:
>>> [    0.394807] [drm]   VGA
>>> [    0.394865] [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48
>>> 0x7e5c 0x7e4c
>>> [    0.394938] [drm]   Encoders:
>>> [    0.394996] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
>>> [    0.395055] [drm] Connector 1:
>>> [    0.395112] [drm]   S-video
>>> [    0.395169] [drm]   Encoders:
>>> [    0.395227] [drm]     TV1: INTERNAL_KLDSCP_DAC1
>>> [    0.395285] [drm] Connector 2:
>>> [    0.395343] [drm]   HDMI-A
>>> [    0.395401] [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58
>>> 0x7e4c 0x7e5c
>>> [    0.395474] [drm]   Encoders:
>>> [    0.395532] [drm]     DFP3: INTERNAL_LVTM1
>>> [    0.593345] [drm] fb mappable at 0xFC040000
>>> [    0.593404] [drm] vram apper at 0xFC000000
>>> [    0.593462] [drm] size 786432
>>> [    0.593519] [drm] fb depth is 8
>>> [    0.593576] [drm]    pitch is 1024
>>> [    0.615713] Console: switching to colour frame buffer device 128x48
>>> [    0.617300] fb0: radeondrmfb frame buffer device
>>> [    0.617319] registered panic notifier
>>> [    0.617337] [drm] Initialized radeon 2.0.0 20080528 for
>>> 0000:01:05.0 on minor 0
>>>
>>> Please ask, if I should provide more information or test something.
>>
>> Can you bisect to see what commit broke it?
>>
>> Alex
>
> Its you fault. ;-P
>
> 0888e883ea5ff8fac27e813256d6c1eaede5a234 is the first bad commit
> commit 0888e883ea5ff8fac27e813256d6c1eaede5a234
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Sat Jun 12 11:50:13 2010 -0400
>
>    drm/radeon/kms: fix bandwidth calculation when sideport is present
>
>    Fixes fdo bug 27529:
>    https://bugs.freedesktop.org/show_bug.cgi?id=27529
>
>    Reported-by: steckdenis@yahoo.fr
>    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> :040000 040000 2ff9114469e4569e1bebd659c9632c5b59bfc238
> b0eb9a29c698da1eeb8289ba1180b8135a94ecd7 M     drivers
>
> My system does not have any sideport memory.
> The other revisions before this did boot into the correct KMS mode,
> but I did not test X, because I'm using that system as a remote
> desktop server and only sometimes the fb text console to debug
> something that went wrong.
>

Make sure your kernel has this patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f892034a8ce80ed7098f667aae2eb6300e570603

If it's still a problem even with that patch, send me a copy of your
vbios (as root):
cd /sys/bus/pci/devices/<pci bus id>
echo 1 > rom
cat rom > /tmp/rs690.rom
echo 0 > rom

Alex

> Torsten
>
