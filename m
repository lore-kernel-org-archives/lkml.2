Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab0GLViq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:38:46 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59673 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab0GLVip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CI7gYZ4+sOk7BNREm/g5O/HT/Uah6xZgxdKsQobzeKAvfmSEFhzbLqnprXAWYYFPIo
         6dq2UIqaNgRBTXT+IL+kmbWrlpltoiNeuPBDz0xirv6JtFQpperBHIG2ROWrOWROiIVu
         QIjFUF8kqOhn+eWwbTLOmKH2eYUT38QApa0O0=
MIME-Version: 1.0
In-Reply-To: <AANLkTinnlhzSGP8sRQ8Pr4CIuwn4d859rvSe1yO_3TEz@mail.gmail.com>
References: <AANLkTimkNg81yzxSHTcAa1QlTE9SYmvzL4eOTVHApWq3@mail.gmail.com>
	<AANLkTilvbOb0n9l6F3EHwQg3VfNNmYB1BdFbzL2Cwg_P@mail.gmail.com>
	<AANLkTinnlhzSGP8sRQ8Pr4CIuwn4d859rvSe1yO_3TEz@mail.gmail.com>
Date: Mon, 12 Jul 2010 17:38:43 -0400
Message-ID: <AANLkTil58zbo28QL2ncTAXx9iHeQS20W8u0MuDgLaojj@mail.gmail.com>
Subject: Re: Regression 2.6.34->2.6.35-rc4: radeaon KMS an RS690 broken
From: Alex Deucher <alexdeucher@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015174c0e4ca0761e048b3793f2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174c0e4ca0761e048b3793f2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 12, 2010 at 3:54 PM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> On Mon, Jul 12, 2010 at 5:23 PM, Alex Deucher <alexdeucher@gmail.com> wro=
te:
>> On Sun, Jul 11, 2010 at 3:56 PM, Torsten Kaiser
>> <just.for.lkml@googlemail.com> wrote:
>>> I just tried 2.6.35-rc4 to see, if a different bug is fixed, but noted
>>> that this kernel will only boot with radeon.modeset=3D0.
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
>>> But I had a second ssh connection open, doing tail -f /var/log/messages=
:
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.720470] [drm] radeon defaulting
>>> to kernel modesetting.
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.720477] [drm] radeon kernel
>>> modesetting enabled.
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.720623] radeon 0000:01:05.0: PC=
I
>>> INT A -> GSI 18 (level, low) -> IRQ 18
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.726859] [drm] initializing
>>> kernel modesetting (RS690 0x1002:0x791E).
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.728607] [drm] register mmio
>>> base: 0xFE9F0000
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.728613] [drm] register mmio
>>> size: 65536
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.729591] ATOM BIOS: ATI
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.729625] radeon 0000:01:05.0:
>>> VRAM: 32M 0xDE000000 - 0xDFFFFFFF (32M used)
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.729632] radeon 0000:01:05.0:
>>> GTT: 512M 0xBE000000 - 0xDDFFFFFF
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.729675] [drm] radeon: irq initi=
alized.
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.729690] mtrr: type mismatch for
>>> fc000000,2000000 old: write-back new: write-combining
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.729696] [drm] Detected VRAM
>>> RAM=3D32M, BAR=3D32M
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.729701] [drm] RAM width 128bits=
 DDR
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.729796] [TTM] Zone =A0kernel:
>>> Available graphics memory: 2010998 kiB.
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.729802] [TTM] Initializing pool=
 allocator.
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.729841] [drm] radeon: 32M of
>>> VRAM memory ready
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.729846] [drm] radeon: 512M of
>>> GTT memory ready.
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.729857] [drm] GART: num cpu
>>> pages 131072, num gpu pages 131072
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.736223] [drm] radeon: 1 quad
>>> pipes, 1 z pipes initialized.
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.752553] [drm] Loading
>>> RS690/RS740 Microcode
>>> Jul 11 21:30:23 ariolc kernel: [ =A0131.911461] [drm] radeon: ring at
>>> 0x00000000BE000000
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.055912] [drm:r100_ring_test]
>>> *ERROR* radeon: ring test failed (sracth(0x15E4)=3D0xCAFEDEAD)
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.055918] [drm:r100_cp_init]
>>> *ERROR* radeon: cp isn't working (-22).
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.055925] radeon 0000:01:05.0:
>>> failled initializing CP (-22).
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.055929] radeon 0000:01:05.0:
>>> Disabling GPU acceleration
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.056174] [drm] radeon: cp finali=
zed
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.057378] [drm] Default TV standa=
rd: NTSC
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.058671] [drm] Default TV standa=
rd: NTSC
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059748] [drm] Radeon Display Co=
nnectors
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059753] [drm] Connector 0:
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059756] [drm] =A0 VGA
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059763] [drm] =A0 DDC: 0x7e50
>>> 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48 0x7e5c 0x7e4c
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059766] [drm] =A0 Encoders:
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059770] [drm] =A0 =A0 CRT1:
>>> INTERNAL_KLDSCP_DAC1
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059773] [drm] Connector 1:
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059776] [drm] =A0 S-video
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059778] [drm] =A0 Encoders:
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059781] [drm] =A0 =A0 TV1:
>>> INTERNAL_KLDSCP_DAC1
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059784] [drm] Connector 2:
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059787] [drm] =A0 HDMI-A
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059792] [drm] =A0 DDC: 0x7e40
>>> 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58 0x7e4c 0x7e5c
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059795] [drm] =A0 Encoders:
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.059798] [drm] =A0 =A0 DFP3: INT=
ERNAL_LVTM1
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.253484] [drm] fb mappable at 0x=
FC040000
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.253488] [drm] vram apper at 0xF=
C000000
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.253489] [drm] size 786432
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.253491] [drm] fb depth is 8
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.253492] [drm] =A0 =A0pitch is 1=
024
>>> Jul 11 21:30:23 ariolc kernel: [ =A0132.253880] fbcon: radeondrmfb (fb0=
)
>>> is primary device
>>>
>>> Hardware info: (lspci -vv from 2.6.33)
>>> 00:00.0 Host bridge: ATI Technologies Inc RS690 Host Bridge
>>> =A0 =A0 =A0 =A0Subsystem: ATI Technologies Inc RS690 Host Bridge
>>> =A0 =A0 =A0 =A0Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASno=
op-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>> =A0 =A0 =A0 =A0Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmediu=
m
>>>>TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
>>> =A0 =A0 =A0 =A0Latency: 0
>>>
>>> 00:01.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge
>>> (Internal gfx) (prog-if 00 [Normal decode])
>>> =A0 =A0 =A0 =A0Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASno=
op-
>>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>> =A0 =A0 =A0 =A0Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmediu=
m
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>> =A0 =A0 =A0 =A0Latency: 64
>>> =A0 =A0 =A0 =A0Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec=
-latency=3D64
>>> =A0 =A0 =A0 =A0I/O behind bridge: 0000c000-0000cfff
>>> =A0 =A0 =A0 =A0Memory behind bridge: fe800000-fe9fffff
>>> =A0 =A0 =A0 =A0Prefetchable memory behind bridge: 00000000fc000000-0000=
0000fdffffff
>>> =A0 =A0 =A0 =A0Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=3Dmediu=
m
>>>>TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>> =A0 =A0 =A0 =A0BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- Fas=
tB2B-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PriDiscTmr- SecDiscTmr- DiscTmrStat- Dis=
cTmrSERREn-
>>> =A0 =A0 =A0 =A0Capabilities: [44] HyperTransport: MSI Mapping Enable+ F=
ixed+
>>> =A0 =A0 =A0 =A0Capabilities: [b0] Subsystem: ATI Technologies Inc RS690=
 PCI
>>> to PCI Bridge (Internal gfx)
>>>
>>> 00:07.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI
>>> Express Port 3) (
>>> prog-if 00 [Normal decode])
>>> =A0 =A0 =A0 =A0Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASno=
op-
>>> ParErr- Stepping- S
>>> ERR+ FastB2B- DisINTx+
>>> =A0 =A0 =A0 =A0Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast =
>TAbort-
>>> <TAbort- <MAbort
>>> - >SERR- <PERR- INTx-
>>> =A0 =A0 =A0 =A0Latency: 0, Cache Line Size: 64 bytes
>>> =A0 =A0 =A0 =A0Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec=
-latency=3D0
>>> =A0 =A0 =A0 =A0I/O behind bridge: 0000d000-0000dfff
>>> =A0 =A0 =A0 =A0Memory behind bridge: fea00000-feafffff
>>> =A0 =A0 =A0 =A0Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast =
>TAbort-
>>> <TAbort- <MAbort
>>> - <SERR- <PERR-
>>> =A0 =A0 =A0 =A0BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- Fas=
tB2B-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PriDiscTmr- SecDiscTmr- DiscTmrStat- Dis=
cTmrSERREn-
>>> =A0 =A0 =A0 =A0Capabilities: [50] Power Management version 3
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Flags: PMEClk- DSI- D1- D2- AuxCurrent=
=3D0mA
>>> PME(D0+,D1-,D2-,D3hot+,D3col
>>> d+)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Status: D0 NoSoftRst- PME-Enable- DSel=
=3D0 DScale=3D0 PME-
>>> =A0 =A0 =A0 =A0Capabilities: [58] Express (v1) Root Port (Slot+), MSI 0=
0
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0DevCap: MaxPayload 128 bytes, PhantFunc =
0, Latency L0s
>>> <64ns, L1 <1us
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ExtTag+ RBE+ FLReset-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0DevCtl: Report errors: Correctable- Non-=
Fatal- Fatal-
>>> Unsupported-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0RlxdOrd+ ExtTag- PhantFu=
nc- AuxPwr- NoSnoop+
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0MaxPayload 128 bytes, Ma=
xReadReq 128 bytes
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0DevSta: CorrErr- UncorrErr- FatalErr- Un=
suppReq-
>>> AuxPwr- TransPend-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0LnkCap: Port #4, Speed 2.5GT/s, Width x1=
, ASPM L0s L1,
>>> Latency L0 <64ns, L1 <1us
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ClockPM- Surprise- LLAct=
Rep+ BwNot-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0LnkCtl: ASPM Disabled; RCB 64 bytes Disa=
bled- Retrain- CommClk+
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ExtSynch- ClockPM- AutWi=
dDis- BWInt- AutBWInt-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0LnkSta: Speed 2.5GT/s, Width x1, TrErr- =
Train-
>>> SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- =
PwrInd-
>>> HotPlug- Surpise-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Slot # =A06, PowerLimit =
25.000000; Interlock- NoCompl-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SltCtl: Enable: AttnBtn- PwrFlt- MRL- Pr=
esDet-
>>> CmdCplt- HPIrq- LinkChg-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Control: AttnInd Off, Pw=
rInd Off, Power- Interlock-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SltSta: Status: AttnBtn- PowerFlt- MRL- =
CmdCplt-
>>> PresDet+ Interlock-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Changed: MRL- PresDet+ L=
inkState-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0RootCtl: ErrCorrectable- ErrNon-Fatal- E=
rrFatal-
>>> PMEIntEna- CRSVisible-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0RootCap: CRSVisible-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0RootSta: PME ReqID 0000, PMEStatus- PMEP=
ending-
>>> =A0 =A0 =A0 =A0Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64=
bit-
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Address: fee0300c =A0Data: 4149
>>> =A0 =A0 =A0 =A0Capabilities: [b0] Subsystem: ATI Technologies Inc RS690=
 PCI
>>> to PCI Bridge
>>> =A0 =A0 =A0 =A0Capabilities: [b8] HyperTransport: MSI Mapping Enable+ F=
ixed+
>>> =A0 =A0 =A0 =A0Capabilities: [100] Virtual Channel <?>
>>> =A0 =A0 =A0 =A0Kernel driver in use: pcieport
>>>
>>> KMS was working stable on 2.6.33 and seems to work on 2.6.34 (Not
>>> really tested, because 2.6.34 is not working for me, but I'm not sure
>>> if that is KMS related)
>>>
>>> Output from working KMS in 2.6.33:
>>> [ =A0 =A00.385804] [drm] Initialized drm 1.1.0 20060810
>>> [ =A0 =A00.385896] [drm] radeon defaulting to kernel modesetting.
>>> [ =A0 =A00.385955] [drm] radeon kernel modesetting enabled.
>>> [ =A0 =A00.386066] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low=
) -> IRQ 18
>>> [ =A0 =A00.388388] [drm] radeon: Initializing kernel modesetting.
>>> [ =A0 =A00.388534] [drm] register mmio base: 0xFE9F0000
>>> [ =A0 =A00.388593] [drm] register mmio size: 65536
>>> [ =A0 =A00.389106] ATOM BIOS: ATI
>>> [ =A0 =A00.389374] [drm] GPU reset succeed (RBBM_STATUS=3D0x10000140)
>>> [ =A0 =A00.389436] [drm] radeon: VRAM 32M
>>> [ =A0 =A00.389495] [drm] radeon: VRAM from 0xDE000000 to 0xDFFFFFFF
>>> [ =A0 =A00.389554] [drm] radeon: GTT 512M
>>> [ =A0 =A00.389612] [drm] radeon: GTT from 0x00000000 to 0x1FFFFFFF
>>> [ =A0 =A00.389688] radeon 0000:01:05.0: irq 25 for MSI/MSI-X
>>> [ =A0 =A00.389692] [drm] radeon: using MSI.
>>> [ =A0 =A00.389766] [drm] radeon: irq initialized.
>>> [ =A0 =A00.389828] mtrr: type mismatch for fc000000,2000000 old:
>>> write-back new: write-combining
>>> [ =A0 =A00.389902] [drm] Detected VRAM RAM=3D32M, BAR=3D32M
>>> [ =A0 =A00.389960] [drm] RAM width 128bits DDR
>>> [ =A0 =A00.390238] [TTM] Zone =A0kernel: Available graphics memory: 201=
0380 kiB.
>>> [ =A0 =A00.390313] [drm] radeon: 32M of VRAM memory ready
>>> [ =A0 =A00.390372] [drm] radeon: 512M of GTT memory ready.
>>> [ =A0 =A00.390431] [drm] GART: num cpu pages 131072, num gpu pages 1310=
72
>>> [ =A0 =A00.393504] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
>>> [ =A0 =A00.393568] [drm] radeon: cp idle (0x10000C03)
>>> [ =A0 =A00.393691] [drm] Loading RS690/RS740 Microcode
>>> [ =A0 =A00.393751] platform radeon_cp.0: firmware: using built-in firmw=
are
>>> radeon/RS690_cp.bin
>>> [ =A0 =A00.393964] [drm] radeon: ring at 0x0000000000000000
>>> [ =A0 =A00.394039] [drm] ring test succeeded in 1 usecs
>>> [ =A0 =A00.394180] [drm] radeon: ib pool ready.
>>> [ =A0 =A00.394249] [drm] ib test succeeded in 0 usecs
>>> [ =A0 =A00.394454] [drm] Default TV standard: NTSC
>>> [ =A0 =A00.394690] [drm] Radeon Display Connectors
>>> [ =A0 =A00.394749] [drm] Connector 0:
>>> [ =A0 =A00.394807] [drm] =A0 VGA
>>> [ =A0 =A00.394865] [drm] =A0 DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x=
7e48
>>> 0x7e5c 0x7e4c
>>> [ =A0 =A00.394938] [drm] =A0 Encoders:
>>> [ =A0 =A00.394996] [drm] =A0 =A0 CRT1: INTERNAL_KLDSCP_DAC1
>>> [ =A0 =A00.395055] [drm] Connector 1:
>>> [ =A0 =A00.395112] [drm] =A0 S-video
>>> [ =A0 =A00.395169] [drm] =A0 Encoders:
>>> [ =A0 =A00.395227] [drm] =A0 =A0 TV1: INTERNAL_KLDSCP_DAC1
>>> [ =A0 =A00.395285] [drm] Connector 2:
>>> [ =A0 =A00.395343] [drm] =A0 HDMI-A
>>> [ =A0 =A00.395401] [drm] =A0 DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x=
7e58
>>> 0x7e4c 0x7e5c
>>> [ =A0 =A00.395474] [drm] =A0 Encoders:
>>> [ =A0 =A00.395532] [drm] =A0 =A0 DFP3: INTERNAL_LVTM1
>>> [ =A0 =A00.593345] [drm] fb mappable at 0xFC040000
>>> [ =A0 =A00.593404] [drm] vram apper at 0xFC000000
>>> [ =A0 =A00.593462] [drm] size 786432
>>> [ =A0 =A00.593519] [drm] fb depth is 8
>>> [ =A0 =A00.593576] [drm] =A0 =A0pitch is 1024
>>> [ =A0 =A00.615713] Console: switching to colour frame buffer device 128=
x48
>>> [ =A0 =A00.617300] fb0: radeondrmfb frame buffer device
>>> [ =A0 =A00.617319] registered panic notifier
>>> [ =A0 =A00.617337] [drm] Initialized radeon 2.0.0 20080528 for
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
> Date: =A0 Sat Jun 12 11:50:13 2010 -0400
>
> =A0 =A0drm/radeon/kms: fix bandwidth calculation when sideport is present
>
> =A0 =A0Fixes fdo bug 27529:
> =A0 =A0https://bugs.freedesktop.org/show_bug.cgi?id=3D27529
>
> =A0 =A0Reported-by: steckdenis@yahoo.fr
> =A0 =A0Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
> =A0 =A0Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> :040000 040000 2ff9114469e4569e1bebd659c9632c5b59bfc238
> b0eb9a29c698da1eeb8289ba1180b8135a94ecd7 M =A0 =A0 drivers
>
> My system does not have any sideport memory.
> The other revisions before this did boot into the correct KMS mode,
> but I did not test X, because I'm using that system as a remote
> desktop server and only sometimes the fb text console to debug
> something that went wrong.

Does this patch help?

Alex

--0015174c0e4ca0761e048b3793f2
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-fix-possible-mis-detection-of-sidepor.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-fix-possible-mis-detection-of-sidepor.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gbju4k660

RnJvbSA4MWQ2YWJiN2U5ZjcwZTkxZmQ3NGFiOGU1YzBjNWM4YTlhMjM3YmM5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogTW9uLCAxMiBKdWwgMjAxMCAxNzozMzo1MCAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIGRy
bS9yYWRlb24va21zOiBmaXggcG9zc2libGUgbWlzLWRldGVjdGlvbiBvZiBzaWRlcG9ydCBvbiBy
czY5MC9yczc0MAoKQ2hlY2sgdWxCb290VXBNZW1vcnlDbG9jayBvbiBBTUQgSUdQcy4KCkZpeCBy
ZWdyZXNzaW9uIG5vdGljZWQgYnkgVG9yc3RlbiBLYWlzZXIgPGp1c3QuZm9yLmxrbWxAZ29vZ2xl
bWFpbC5jb20+CgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWls
LmNvbT4KQ2M6IHN0YWJsZUBrZXJuZWwub3JnCi0tLQogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9y
YWRlb25fYXRvbWJpb3MuYyB8ICAgMTEgKysrKysrKysrLS0KIDEgZmlsZXMgY2hhbmdlZCwgOSBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2Ry
bS9yYWRlb24vcmFkZW9uX2F0b21iaW9zLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVv
bl9hdG9tYmlvcy5jCmluZGV4IDVkZDg2YjkuLjNmODljOWIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
Z3B1L2RybS9yYWRlb24vcmFkZW9uX2F0b21iaW9zLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3Jh
ZGVvbi9yYWRlb25fYXRvbWJpb3MuYwpAQCAtMTAyOSw4ICsxMDI5LDE1IEBAIGJvb2wgcmFkZW9u
X2F0b21iaW9zX3NpZGVwb3J0X3ByZXNlbnQoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpCiAJ
CQkJICAgICAgZGF0YV9vZmZzZXQpOwogCQlzd2l0Y2ggKGNyZXYpIHsKIAkJY2FzZSAxOgotCQkJ
aWYgKGlncF9pbmZvLT5pbmZvLnVjTWVtb3J5VHlwZSAmIDB4ZjApCi0JCQkJcmV0dXJuIHRydWU7
CisJCQkvKiBBTUQgSUdQUyAqLworCQkJaWYgKChyZGV2LT5mYW1pbHkgPT0gQ0hJUF9SUzY5MCkg
fHwKKwkJCSAgICAocmRldi0+ZmFtaWx5ID09IENISVBfUlM3NDApKSB7CisJCQkJaWYgKGlncF9p
bmZvLT5pbmZvLnVsQm9vdFVwTWVtb3J5Q2xvY2spCisJCQkJCXJldHVybiB0cnVlOworCQkJfSBl
bHNlIHsKKwkJCQlpZiAoaWdwX2luZm8tPmluZm8udWNNZW1vcnlUeXBlICYgMHhmMCkKKwkJCQkJ
cmV0dXJuIHRydWU7CisJCQl9CiAJCQlicmVhazsKIAkJY2FzZSAyOgogCQkJaWYgKGlncF9pbmZv
LT5pbmZvXzIudWNNZW1vcnlUeXBlICYgMHgwZikKLS0gCjEuNy4wLjEKCg==
--0015174c0e4ca0761e048b3793f2--
