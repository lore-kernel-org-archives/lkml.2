Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab2KLWZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 17:25:24 -0500
Received: from rrcs-24-173-105-85.sw.biz.rr.com ([24.173.105.85]:40822 "EHLO
	mx1.mthode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab2KLWZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 17:25:20 -0500
Message-ID: <50A1775D.70207@gentoo.org>
Date: Mon, 12 Nov 2012 16:25:33 -0600
From: Matthew Thode <prometheanfire@gentoo.org>
Reply-To: prometheanfire@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121030 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Don Dutile <ddutile@redhat.com>, Doug Goldstein <cardoe@gentoo.org>,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org, mthode@mthode.org,
        iommu@lists.linux-foundation.org
Subject: Re: [BUG 3.7-rc5] NULL pointer deref when using a pcie-pci bridged
 pci device and intel-iommu
References: <50A03281.6040206@gentoo.org>  <CAFWqQMQgmsFNqLS02Go3de-OZoxoPRbGuSmcj8ntic52C8AVpw@mail.gmail.com>  <50A1549C.7020404@redhat.com> <1352758750.2853.1.camel@ul30vt.home>
In-Reply-To: <1352758750.2853.1.camel@ul30vt.home>
X-Enigmail-Version: 1.5a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig938020C18A4283F4C835DD94"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig938020C18A4283F4C835DD94
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/12/2012 04:19 PM, Alex Williamson wrote:
> On Mon, 2012-11-12 at 14:57 -0500, Don Dutile wrote:
>> On 11/12/2012 04:26 AM, Doug Goldstein wrote:
>>> On Sun, Nov 11, 2012 at 5:19 PM, Matthew Thode
>>> <prometheanfire@gentoo.org>  wrote:
>>>> System boots with vt-d disabled in bios. Otherwise I get the errors =
in
>>>> the attached log.  I can do whatever testing you need as this system=
 is
>>>> not in production yet.  gonna paste the important part here.  Let me=

>>>> know if you want anything else.
>>>>
>>>> Please CC me directly as I am not subscribed to the LKML.
>>>>
>>>>
>>>> Trying to unpack rootfs image as initramfs...
>>>> Freeing initrd memory: 5124k freed
>>>> IOMMU 0 0xfbffe000: using Queued invalidation
>>>> IOMMU: Setting RMRR:
>>>> IOMMU: Setting identity map for device 0000:00:1d.0 [0xbf7ec000 -
>>>> 0xbf7fffff]
>>>> IOMMU: Setting identity map for device 0000:00:1d.1 [0xbf7ec000 -
>>>> 0xbf7fffff]
>>>> IOMMU: Setting identity map for device 0000:00:1d.2 [0xbf7ec000 -
>>>> 0xbf7fffff]
>>>> IOMMU: Setting identity map for device 0000:00:1d.7 [0xbf7ec000 -
>>>> 0xbf7fffff]
>>>> IOMMU: Setting identity map for device 0000:00:1a.0 [0xbf7ec000 -
>>>> 0xbf7fffff]
>>>> IOMMU: Setting identity map for device 0000:00:1a.1 [0xbf7ec000 -
>>>> 0xbf7fffff]
>>>> IOMMU: Setting identity map for device 0000:00:1a.2 [0xbf7ec000 -
>>>> 0xbf7fffff]
>>>> IOMMU: Setting identity map for device 0000:00:1a.7 [0xbf7ec000 -
>>>> 0xbf7fffff]
>>>> IOMMU: Setting identity map for device 0000:00:1d.0 [0xec000 - 0xeff=
ff]
>>>> IOMMU: Setting identity map for device 0000:00:1d.1 [0xec000 - 0xeff=
ff]
>>>> IOMMU: Setting identity map for device 0000:00:1d.2 [0xec000 - 0xeff=
ff]
>>>> IOMMU: Setting identity map for device 0000:00:1d.7 [0xec000 - 0xeff=
ff]
>>>> IOMMU: Setting identity map for device 0000:00:1a.0 [0xec000 - 0xeff=
ff]
>>>> IOMMU: Setting identity map for device 0000:00:1a.1 [0xec000 - 0xeff=
ff]
>>>> IOMMU: Setting identity map for device 0000:00:1a.2 [0xec000 - 0xeff=
ff]
>>>> IOMMU: Setting identity map for device 0000:00:1a.7 [0xec000 - 0xeff=
ff]
>>>> IOMMU: Prepare 0-16MiB unity mapping for LPC
>>>> IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]=

>>>> PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
>>>> BUG: unable to handle kernel NULL pointer dereference at 00000000000=
0003c
>>>> IP: [<ffffffff813bd796>] pci_get_dma_source+0xf/0x41
>>>> PGD 0
>>>> Oops: 0000 [#1] SMP
>>>> Modules linked in:
>>>> CPU 7
>>>> Pid: 1, comm: swapper/0 Not tainted 3.7.0-rc5 #1 Penguin Computing
>>>> Relion 1751/X8DTU
>>>> RIP: 0010:[<ffffffff813bd796>]  [<ffffffff813bd796>]
>>>> pci_get_dma_source+0xf/0x41
>>>> RSP: 0000:ffff8806264d1d88  EFLAGS: 00010282
>>>> RAX: ffffffff813bd3a8 RBX: ffff8806261d1000 RCX: 00000000e8221180
>>>> RDX: ffffffff818624f0 RSI: ffff88062635b0c0 RDI: 0000000000000000
>>>> RBP: ffff8806264d1d88 R08: ffff8806263d6000 R09: 00000000ffffffff
>>>> R10: ffff8806264d1ca8 R11: 0000000000000005 R12: 0000000000000000
>>>> R13: ffff8806261d1098 R14: 0000000000000000 R15: 0000000000000000
>>>> FS:  0000000000000000(0000) GS:ffff88063f2e0000(0000) knlGS:00000000=
00000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>> CR2: 000000000000003c CR3: 0000000001c0b000 CR4: 00000000000007e0
>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>>> Process swapper/0 (pid: 1, threadinfo ffff8806264d0000, task
>>>> ffff8806264cf910)
>>>> Stack:
>>>>   ffff8806264d1dc8 ffffffff815d02c9 0000000000000000 ffff88060000000=
0
>>>>   ffff8806264d1dd8 ffffffff81c64b00 ffff8806261d1098 ffff8806264d1df=
8
>>>>   ffff8806264d1de8 ffffffff815cd5a4 ffffffff81c64b00 ffffffff815cd56=
a
>>>> Call Trace:
>>>>   [<ffffffff815d02c9>] intel_iommu_add_device+0x95/0x167
>>>>   [<ffffffff815cd5a4>] add_iommu_group+0x3a/0x41
>>>>   [<ffffffff815cd56a>] ? bus_set_iommu+0x44/0x44
>>>>   [<ffffffff8145eca1>] bus_for_each_dev+0x54/0x81
>>>>   [<ffffffff815cd563>] bus_set_iommu+0x3d/0x44
>>>>   [<ffffffff81cd3fa3>] intel_iommu_init+0xae5/0xb5e
>>>>   [<ffffffff81ca0277>] ? free_initrd+0x9e/0x9e
>>>>   [<ffffffff81ca4248>] ? memblock_find_dma_reserve+0x13f/0x13f
>>>>   [<ffffffff81ca425e>] pci_iommu_init+0x16/0x41
>>>>   [<ffffffff81cc4140>] ? pci_proc_init+0x6b/0x6b
>>>>   [<ffffffff81000231>] do_one_initcall+0x7a/0x129
>>>>   [<ffffffff816dac14>] kernel_init+0x139/0x2a2
>>>>   [<ffffffff81c9d4c7>] ? loglevel+0x31/0x31
>>>>   [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
>>>>   [<ffffffff816f66ac>] ret_from_fork+0x7c/0xb0
>>>>   [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
>>>> Code: ff c1 75 04 ff d0 eb 12 48 83 c2 10 48 8b 42 08 48 85 c0 75 d3=
 b8
>>>> e7 ff ff ff c9 c3 55 48 c7 c2 f0 24 86 81 48 89 e5 eb 24 8b 0a<66>  =
3b
>>>> 4f 3c 74 05 66 ff c1 75 13 66 8b 4a 02 66 3b 4f 3e 74 05
>>>> RIP  [<ffffffff813bd796>] pci_get_dma_source+0xf/0x41
>>>>   RSP<ffff8806264d1d88>
>>>> CR2: 000000000000003c
>>>> ---[ end trace 5c5a2ceca067e0ec ]---
>>>> Kernel panic - not syncing: Attempted to kill init! exitcode=3D0x000=
00009
>>>>
>>>> ------------[ cut here ]------------
>>>> WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x2=
5/0x51()
>>>> Hardware name: Relion 1751
>>>> Modules linked in:
>>>> Pid: 1, comm: swapper/0 Tainted: G      D      3.7.0-rc5 #1
>>>> Call Trace:
>>>>   <IRQ>   [<ffffffff810968ee>] warn_slowpath_common+0x80/0x98
>>>>   [<ffffffff8109691b>] warn_slowpath_null+0x15/0x17
>>>>   [<ffffffff8104e1a3>] native_smp_send_reschedule+0x25/0x51
>>>>   [<ffffffff810bc81b>] trigger_load_balance+0x1e8/0x214
>>>>   [<ffffffff810b731f>] scheduler_tick+0xd8/0xe1
>>>>   [<ffffffff810a132f>] update_process_times+0x62/0x73
>>>>   [<ffffffff810cb78b>] tick_sched_timer+0x7c/0x9b
>>>>   [<ffffffff810b0f83>] __run_hrtimer.clone.24+0x4e/0xc1
>>>>   [<ffffffff810b15b0>] hrtimer_interrupt+0xc7/0x1ac
>>>>   [<ffffffff8104ef01>] smp_apic_timer_interrupt+0x81/0x94
>>>>   [<ffffffff816f71ca>] apic_timer_interrupt+0x6a/0x70
>>>>   <EOI>   [<ffffffff81097ffc>] ? console_unlock+0x2c2/0x2ed
>>>>   [<ffffffff816f32fc>] ? panic+0x189/0x1c5
>>>>   [<ffffffff816f3261>] ? panic+0xee/0x1c5
>>>>   [<ffffffff8109ab6b>] do_exit+0x357/0x7b2
>>>>   [<ffffffff810371b8>] oops_end+0xb2/0xba
>>>>   [<ffffffff8105841d>] no_context+0x266/0x275
>>>>   [<ffffffff810585e7>] __bad_area_nosemaphore+0x1bb/0x1db
>>>>   [<ffffffff8118de46>] ? sysfs_addrm_finish+0x2f/0xa6
>>>>   [<ffffffff81058615>] bad_area_nosemaphore+0xe/0x10
>>>>   [<ffffffff81058bdb>] __do_page_fault+0x360/0x39f
>>>>   [<ffffffff81394afa>] ? ida_get_new_above+0xf9/0x19e
>>>>   [<ffffffff8112a077>] ? slab_node+0x59/0xa2
>>>>   [<ffffffff816f3ffd>] ? mutex_unlock+0x9/0xb
>>>>   [<ffffffff816da653>] ? klist_put+0x4c/0x70
>>>>   [<ffffffff816da581>] ? klist_next+0x30/0xb6
>>>>   [<ffffffff813b8cf9>] ? pci_do_find_bus+0x49/0x49
>>>>   [<ffffffff81058c42>] do_page_fault+0x9/0xb
>>>>   [<ffffffff816f6232>] page_fault+0x22/0x30
>>>>   [<ffffffff813bd3a8>] ? nv_msi_ht_cap_quirk_all+0x10/0x10
>>>>   [<ffffffff813bd796>] ? pci_get_dma_source+0xf/0x41
>>>>   [<ffffffff815d02c9>] intel_iommu_add_device+0x95/0x167
>>>>   [<ffffffff815cd5a4>] add_iommu_group+0x3a/0x41
>>>>   [<ffffffff815cd56a>] ? bus_set_iommu+0x44/0x44
>>>>   [<ffffffff8145eca1>] bus_for_each_dev+0x54/0x81
>>>>   [<ffffffff815cd563>] bus_set_iommu+0x3d/0x44
>>>>   [<ffffffff81cd3fa3>] intel_iommu_init+0xae5/0xb5e
>>>>   [<ffffffff81ca0277>] ? free_initrd+0x9e/0x9e
>>>>   [<ffffffff81ca4248>] ? memblock_find_dma_reserve+0x13f/0x13f
>>>>   [<ffffffff81ca425e>] pci_iommu_init+0x16/0x41
>>>>   [<ffffffff81cc4140>] ? pci_proc_init+0x6b/0x6b
>>>>   [<ffffffff81000231>] do_one_initcall+0x7a/0x129
>>>>   [<ffffffff816dac14>] kernel_init+0x139/0x2a2
>>>>   [<ffffffff81c9d4c7>] ? loglevel+0x31/0x31
>>>>   [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
>>>>   [<ffffffff816f66ac>] ret_from_fork+0x7c/0xb0
>>>>   [<ffffffff816daadb>] ? rest_init+0x6f/0x6f
>>>> ---[ end trace 5c5a2ceca067e0ed ]---
>>>>
>>>> --
>>>> -- Matthew Thode (prometheanfire)
>>>
>>> The root cause of Matt's issue is that intel_iommu_add_device() calls=

>>> pci_get_domain_bus_and_slot() which is returning NULL. Which is not a=
n
>>> expected value. The reason NULL is being returned is that Matt has a
>>> card with a TI XIO2000A/XIO2200A PCIe-PCI bridge (VID: 104C, DID:
>>> 8231) on it. This device already has a quirk setup for disabling fast=

>>> back to back transfers on its secondary bus. If we cause it to use th=
e
>>> primary bus, that appears to resolve the issue. I'm not sure exactly
>>> how to proceed from here due to relative lack of knowledge of PCI. Do=

>>> all PCIe-PCI bridges with secondary buses need their DMA parent to be=

>>> the primary bus or is that just something that should be done for the=

>>> TI XIO2000A due to the existing quirk?
>>>
>> DMA from a (legacy) PCI device does not have a SRC-ID in the transacti=
on,
>> so the source of the device generating the DMA is unknown.  When bridg=
ing
>> to a PCIe device, the Parent PPB's dev-id is inserted on the PCIe as t=
he source
>> of a transaction -- in this case, DMA read/write transaction.
>> This (sw) mapping should have happened by default, unless a recent cha=
nge from VFIO
>> broke this mapping.... or the TI bridge didn't report itself correctly=

>> as a PCIe-PCI bridge.
>> Alex ?
>=20
> Please post the full lspci -vvv log, I'm not quite sure I understand th=
e
> topology yet.  Thanks,
>=20
> Alex
>=20
ok, this is with the device passed though to a VM now, so the driver for
it is now pci-stub, but that should be it I think.

00:00.0 Host bridge: Intel Corporation 5520 I/O Hub to ESI Port (rev 22)
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Capabilities: [60] MSI: Enable- Count=3D1/2 Maskable+ 64bit-
		Address: 00000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0
<512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
	Capabilities: [160 v0] Vendor Specific Information: ID=3D0002 Rev=3D0
Len=3D00c <?>

00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express
Root Port 1 (rev 22) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fbb00000-fbbfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Super Micro Computer Inc Device 0600
	Capabilities: [60] MSI: Enable+ Count=3D1/2 Maskable+ 64bit-
		Address: fee00358  Data: 0000
		Masking: 00000002  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 256 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0
<512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
	Capabilities: [160 v0] Vendor Specific Information: ID=3D0002 Rev=3D0
Len=3D00c <?>
	Kernel driver in use: pcieport

00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express
Root Port 3 (rev 22) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Super Micro Computer Inc Device 0600
	Capabilities: [60] MSI: Enable+ Count=3D1/2 Maskable+ 64bit-
		Address: fee00378  Data: 0000
		Masking: 00000002  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0
<512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #3, PowerLimit 25.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
	Capabilities: [160 v0] Vendor Specific Information: ID=3D0002 Rev=3D0
Len=3D00c <?>
	Kernel driver in use: pcieport

00:05.0 PCI bridge: Intel Corporation 5520/X58 I/O Hub PCI Express Root
Port 5 (rev 22) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Super Micro Computer Inc Device 0600
	Capabilities: [60] MSI: Enable+ Count=3D1/2 Maskable+ 64bit-
		Address: fee00398  Data: 0000
		Masking: 00000002  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0
<512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #2, PowerLimit 25.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
	Kernel driver in use: pcieport

00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express
Root Port 7 (rev 22) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=3D00, secondary=3D04, subordinate=3D05, sec-latency=3D0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fbc00000-fbcfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Super Micro Computer Inc Device 0600
	Capabilities: [60] MSI: Enable+ Count=3D1/2 Maskable+ 64bit-
		Address: fee003b8  Data: 0000
		Masking: 00000002  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 256 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0
<512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #1, PowerLimit 10.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
	Capabilities: [160 v0] Vendor Specific Information: ID=3D0002 Rev=3D0
Len=3D00c <?>
	Kernel driver in use: pcieport

00:09.0 PCI bridge: Intel Corporation 7500/5520/5500/X58 I/O Hub PCI
Express Root Port 9 (rev 22) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=3D00, secondary=3D06, subordinate=3D06, sec-latency=3D0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fbd00000-fbdfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Super Micro Computer Inc Device 0600
	Capabilities: [60] MSI: Enable+ Count=3D1/2 Maskable+ 64bit-
		Address: fee003d8  Data: 0000
		Masking: 00000002  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 256 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0
<512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #1, PowerLimit 10.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
	Kernel driver in use: pcieport

00:13.0 PIC: Intel Corporation 7500/5520/5500/X58 I/O Hub I/OxAPIC
Interrupt Controller (rev 22) (prog-if 20 [IO(X)-APIC])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at fec8a000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [6c] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-

00:14.0 PIC: Intel Corporation 7500/5520/5500/X58 I/O Hub System
Management Registers (rev 22) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0
unlimited, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

00:14.1 PIC: Intel Corporation 7500/5520/5500/X58 I/O Hub GPIO and
Scratch Pad Registers (rev 22) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0
unlimited, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

00:14.2 PIC: Intel Corporation 7500/5520/5500/X58 I/O Hub Control Status
and RAS Registers (rev 22) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0
unlimited, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

00:14.3 PIC: Intel Corporation 7500/5520/5500/X58 I/O Hub Throttle
Registers (rev 22) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-

00:16.0 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at fbef8000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [80] MSI-X: Enable+ Count=3D1 Masked-
		Vector table: BAR=3D0 offset=3D00002000
		PBA: BAR=3D0 offset=3D00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: ioatdma

00:16.1 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin B routed to IRQ 44
	Region 0: Memory at fbef4000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [80] MSI-X: Enable+ Count=3D1 Masked-
		Vector table: BAR=3D0 offset=3D00002000
		PBA: BAR=3D0 offset=3D00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: ioatdma

00:16.2 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin C routed to IRQ 45
	Region 0: Memory at fbef0000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [80] MSI-X: Enable+ Count=3D1 Masked-
		Vector table: BAR=3D0 offset=3D00002000
		PBA: BAR=3D0 offset=3D00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: ioatdma

00:16.3 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin D routed to IRQ 46
	Region 0: Memory at fbeec000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [80] MSI-X: Enable+ Count=3D1 Masked-
		Vector table: BAR=3D0 offset=3D00002000
		PBA: BAR=3D0 offset=3D00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: ioatdma

00:16.4 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at fbee8000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [80] MSI-X: Enable+ Count=3D1 Masked-
		Vector table: BAR=3D0 offset=3D00002000
		PBA: BAR=3D0 offset=3D00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: ioatdma

00:16.5 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin B routed to IRQ 44
	Region 0: Memory at fbee4000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [80] MSI-X: Enable+ Count=3D1 Masked-
		Vector table: BAR=3D0 offset=3D00002000
		PBA: BAR=3D0 offset=3D00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: ioatdma

00:16.6 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin C routed to IRQ 45
	Region 0: Memory at fbee0000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [80] MSI-X: Enable+ Count=3D1 Masked-
		Vector table: BAR=3D0 offset=3D00002000
		PBA: BAR=3D0 offset=3D00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: ioatdma

00:16.7 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin D routed to IRQ 46
	Region 0: Memory at fbedc000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [80] MSI-X: Enable+ Count=3D1 Masked-
		Vector table: BAR=3D0 offset=3D00002000
		PBA: BAR=3D0 offset=3D00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: ioatdma

00:1a.0 USB controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #4 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at bc00 [size=3D32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1a.1 USB controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #5 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at b880 [size=3D32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1a.2 USB controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #6 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 4: I/O ports at b800 [size=3D32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1a.7 USB controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #2 (prog-if 20 [EHCI])
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fbeda000 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1d.0 USB controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #1 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at b480 [size=3D32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #2 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at b400 [size=3D32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #3 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at b080 [size=3D32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #1 (prog-if 20 [EHCI])
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fbed8000 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90) (prog-if
01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=3D00, secondary=3D07, subordinate=3D07, sec-latency=3D32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: faf00000-fb7fffff
	Prefetchable memory behind bridge: 00000000f9000000-00000000f9ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Super Micro Computer Inc Device 0600

00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface
Controller
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=3D0c <?>

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA
AHCI Controller (prog-if 01 [AHCI 1.0])
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 78
	Region 0: I/O ports at a480 [size=3D8]
	Region 1: I/O ports at b000 [size=3D4]
	Region 2: I/O ports at ac00 [size=3D8]
	Region 3: I/O ports at a880 [size=3D4]
	Region 4: I/O ports at a800 [size=3D32]
	Region 5: Memory at fbed6000 (32-bit, non-prefetchable) [size=3D2K]
	Capabilities: [80] MSI: Enable+ Count=3D1/16 Maskable- 64bit-
		Address: fee00578  Data: 0000
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D3c=
old-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=3D00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fbed4000 (64-bit, non-prefetchable) [size=3D256]
	Region 4: I/O ports at 0400 [size=3D32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801

01:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network
Connection (rev 01)
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 28
	Region 0: Memory at fbbe0000 (32-bit, non-prefetchable) [size=3D128K]
	Region 1: Memory at fbbc0000 (32-bit, non-prefetchable) [size=3D128K]
	Region 2: I/O ports at cc00 [size=3D32]
	Region 3: Memory at fbb9c000 (32-bit, non-prefetchable) [size=3D16K]
	Expansion ROM at fbba0000 [disabled] [size=3D128K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] MSI-X: Enable+ Count=3D10 Masked-
		Vector table: BAR=3D3 offset=3D00000000
		PBA: BAR=3D3 offset=3D00002000
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us=

			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0
<4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not
Supported
		DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-25-90-ff-ff-0c-d8-ea
	Kernel driver in use: igb

01:00.1 Ethernet controller: Intel Corporation 82576 Gigabit Network
Connection (rev 01)
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin B routed to IRQ 40
	Region 0: Memory at fbb60000 (32-bit, non-prefetchable) [size=3D128K]
	Region 1: Memory at fbb40000 (32-bit, non-prefetchable) [size=3D128K]
	Region 2: I/O ports at c880 [size=3D32]
	Region 3: Memory at fbb1c000 (32-bit, non-prefetchable) [size=3D16K]
	Expansion ROM at fbb20000 [disabled] [size=3D128K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] MSI-X: Enable+ Count=3D10 Masked-
		Vector table: BAR=3D3 offset=3D00000000
		PBA: BAR=3D3 offset=3D00002000
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us=

			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0
<4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not
Supported
		DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-25-90-ff-ff-0c-d8-ea
	Kernel driver in use: igb

04:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200A PCI
Express-to-PCI Bridge (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=3D04, secondary=3D05, subordinate=3D05, sec-latency=3D64
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fbc00000-fbcfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
		Bridge: PM- B3+
	Capabilities: [60] MSI: Enable- Count=3D1/16 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [80] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0=
000
	Capabilities: [90] Express (v1) PCI/PCI-X Bridge, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ BrConfRtry-
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <16us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s Enabled; Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-

05:08.0 Ethernet controller: Digium, Inc. Wildcard AEX410 4-port analog
card (PCI-Express) (rev 11)
	Subsystem: Digium, Inc. Wildcard AEX410 4-port analog card (PCI-Express)=

	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 30
	Region 0: I/O ports at d800 [size=3D256]
	Region 1: Memory at fbcde000 (32-bit, non-prefetchable) [size=3D1K]
	Expansion ROM at fbce0000 [size=3D128K]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3c=
old-)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: pci-stub

06:00.0 Ethernet controller: Intel Corporation 82572EI Gigabit Ethernet
Controller (Copper) (rev 06)
	Subsystem: Intel Corporation PRO/1000 PT Desktop Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 79
	Region 0: Memory at fbde0000 (32-bit, non-prefetchable) [size=3D128K]
	Region 1: Memory at fbdc0000 (32-bit, non-prefetchable) [size=3D128K]
	Region 2: I/O ports at ec00 [size=3D32]
	Expansion ROM at fbda0000 [disabled] [size=3D128K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [d0] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
		Address: 00000000fee005b8  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us=

			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <4us,
L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-15-17-ff-ff-1e-24-ca
	Kernel driver in use: e1000e

07:01.0 VGA compatible controller: Matrox Electronics Systems Ltd. MGA
G200eW WPCM450 (rev 0a) (prog-if 00 [VGA controller])
	Subsystem: Super Micro Computer Inc Device 0600
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (4000ns min, 8000ns max), Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f9000000 (32-bit, prefetchable) [size=3D16M]
	Region 1: Memory at faffc000 (32-bit, non-prefetchable) [size=3D16K]
	Region 2: Memory at fb000000 (32-bit, non-prefetchable) [size=3D8M]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-

ff:00.0 Host bridge: Intel Corporation Xeon 5500/Core i7 QuickPath
Architecture Generic Non-Core Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:00.1 Host bridge: Intel Corporation Xeon 5500/Core i7 QuickPath
Architecture System Address Decoder (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.0 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Link 0 (rev =
05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.1 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Physical 0
(rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.4 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Link 1 (rev =
05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.5 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Physical 1
(rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:03.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:03.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller Target Address Decoder (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:03.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller RAS Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:03.4 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller Test Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller Channel 0 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller Channel 0 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller Channel 0 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller Channel 0 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller Channel 1 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller Channel 1 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller Channel 1 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller Channel 1 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:06.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller Channel 2 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:06.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller Channel 2 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:06.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller Channel 2 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:06.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated
Memory Controller Channel 2 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

>>> The failing call with arguments was pci_get_domain_bus_and_slot(0, 5,=

>>> 0), while pci_get_domain_bus_and_slot(0, 4, 0) resulted in a system
>>> that didn't panic and a device that worked.
>>>
>>> $ lspci -tvn
>>> -+-[0000:ff]-+-00.0  8086:2c40
>>>   |           +-00.1  8086:2c01
>>>   |           +-02.0  8086:2c10
>>>   |           +-02.1  8086:2c11
>>>   |           +-02.4  8086:2c14
>>>   |           +-02.5  8086:2c15
>>>   |           +-03.0  8086:2c18
>>>   |           +-03.1  8086:2c19
>>>   |           +-03.2  8086:2c1a
>>>   |           +-03.4  8086:2c1c
>>>   |           +-04.0  8086:2c20
>>>   |           +-04.1  8086:2c21
>>>   |           +-04.2  8086:2c22
>>>   |           +-04.3  8086:2c23
>>>   |           +-05.0  8086:2c28
>>>   |           +-05.1  8086:2c29
>>>   |           +-05.2  8086:2c2a
>>>   |           +-05.3  8086:2c2b
>>>   |           +-06.0  8086:2c30
>>>   |           +-06.1  8086:2c31
>>>   |           +-06.2  8086:2c32
>>>   |           \-06.3  8086:2c33
>>>   \-[0000:00]-+-00.0  8086:3406
>>>               +-01.0-[01]--+-00.0  8086:10c9
>>>               |            \-00.1  8086:10c9
>>>               +-03.0-[02]--
>>>               +-05.0-[03]--
>>>               +-07.0-[04-05]----00.0-[05]----08.0  d161:8006
>>>               +-09.0-[06]----00.0  8086:10b9
>>>               +-13.0  8086:342d
>>>               +-14.0  8086:342e
>>>               +-14.1  8086:3422
>>>               +-14.2  8086:3423
>>>               +-14.3  8086:3438
>>>               +-16.0  8086:3430
>>>               +-16.1  8086:3431
>>>               +-16.2  8086:3432
>>>               +-16.3  8086:3433
>>>               +-16.4  8086:3429
>>>               +-16.5  8086:342a
>>>               +-16.6  8086:342b
>>>               +-16.7  8086:342c
>>>               +-1a.0  8086:3a37
>>>               +-1a.1  8086:3a38
>>>               +-1a.2  8086:3a39
>>>               +-1a.7  8086:3a3c
>>>               +-1d.0  8086:3a34
>>>               +-1d.1  8086:3a35
>>>               +-1d.2  8086:3a36
>>>               +-1d.7  8086:3a3a
>>>               +-1e.0-[07]----01.0  102b:0532
>>>               +-1f.0  8086:3a16
>>>               +-1f.2  8086:3a22
>>>               \-1f.3  8086:3a30
>>>
>>> If someone can craft the correct patch that'd be great or answer the
>>> above question and I'll gladly craft it.
>>>
>>> Thanks.
>>
>=20
>=20
>=20


--=20
-- Matthew Thode (prometheanfire)


--------------enig938020C18A4283F4C835DD94
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQoXdjAAoJECRx6z5ArFrDIa4QAKNnVd9ewacMWb33kSbQOxS3
Y4+3nVQMqRChECjkJG8vLPLt4JhppNBKH0a6TfSHWfuiBPnH/VenwIEcXZEqgXWi
1oPwpJD4M+5i0HsIjmC30IGCtWc3YWTXzmKBoEzRLXA/Rn9z69Lz+L/Sb11Ne9xq
n198nG26c605o+wT/+SiKaJdpFMjoQrv2fAZ35ONbw2ky0RNfIqbRYWoDI1ZCEZe
tIOZDoJ5k16QHgBmVwBAgBwDXbAtcb5U/0PEYuHy0DpUAMnM9PGLPfarY1/IPc1W
lVnL03tppHcpQQ7CzlBgxej9c2metPXjndnpujXCCk8YK/6V6/IiE9ZbGEcUvKIu
l+bNK8gyofZvhEeMO7LqbR7MXorZ6vt03IH/DmmTnLWNtUWdTmeWSd3DNIORC4Qa
id9vhlCkZ5eDZ6brZ81JprFFW1YQ3Zc9aN92XbZG3N4VkC/0Bl1NLKO5gqys4wbq
/o1nyCSlyRZV8DHdSy5bbrUDKXcCiykYH77GiVm5o7TuKVjglJ7JVLxofio6y7pR
cCNoc8YgZWFfPEsjNjW5BWXF3wB4ICWN2xdDr6G2nueQUJJTFCtImKLEHciNbY7n
oFVfe1B5Y3mS3SKkuTGclhdXco7opNdkjp9/9Z4Uvtu72SNx/UFjt1vKpl6QSr8L
78+HsR/VaGiv1m1wkWOB
=vDGS
-----END PGP SIGNATURE-----

--------------enig938020C18A4283F4C835DD94--
