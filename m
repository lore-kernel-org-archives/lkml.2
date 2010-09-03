Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab0ICS7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 14:59:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:21522 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0ICS7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 14:59:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,314,1280732400"; 
   d="scan'208";a="603554121"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Tony Jones <tonyj@suse.de>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bphilips@suse.de" <bphilips@suse.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Date: Fri, 3 Sep 2010 11:59:30 -0700
Subject: RE: high latency on 82573L
Thread-Topic: high latency on 82573L
Thread-Index: ActLkJ9tj1nHGymfSTu8NuiEck3KbgABYcAA
Message-ID: <8DD2590731AB5D4C9DBF71A877482A900168EDB454@orsmsx509.amr.corp.intel.com>
References: <20100902033900.GA5283@suse.de>
 <8DD2590731AB5D4C9DBF71A877482A900168E59EFA@orsmsx509.amr.corp.intel.com>
 <20100903175102.GA7767@suse.de>
In-Reply-To: <20100903175102.GA7767@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 03, 2010 10:51 AM, Tony Jones wrote:
> On Thu, Sep 02, 2010 at 11:49:12AM -0700, Allan, Bruce W wrote:
>> Please provide more verbose lspci output and include the PCI config
>> space, i.e. 'lspci -s 2:0.0 -vvv -xxx' after the driver is loaded,
> 
> # lspci -s 2:0.0 -vvv -xxx
> 02:00.0 Ethernet controller: Intel Corporation 82573L Gigabit
> 	Ethernet Controller Subsystem: Lenovo ThinkPad T60
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> 	Stepping- SERR+ FastB2B- DisINTx+ Status: Cap+ 66MHz- UDF- FastB2B-
> 	ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes Interrupt: pin A routed to IRQ
> 	46 Region 0: Memory at ee000000 (32-bit, non-prefetchable)
> 	[size=128K] Region 2: I/O ports at 3000 [size=32]
> 	Capabilities: [c8] Power Management version 2
> 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> 		PME(D0+,D1-,D2-,D3hot+,D3cold+) Status: D0 NoSoftRst- PME-Enable-
> 	DSel=0 DScale=1 PME- Capabilities: [d0] MSI: Enable+ Count=1/1
> 		Maskable- 64bit+ Address: 00000000fee0100c  Data: 41c9
> 	Capabilities: [e0] Express (v1) Endpoint, MSI 00
> 		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1
> 			<64us ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
> 		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
> 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
> 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
> 			<128ns, L1 <64us ClockPM+ Surprise- LLActRep- BwNot-
> 		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
> 			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
> 	BWMgmt- ABWMgmt- Capabilities: [100 v1] Advanced Error Reporting
> 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
> 		MalfTLP- ECRC- UnsupReq+ ACSViol- UEMsk:	DLP- SDES- TLP- FCP-
> 		CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq-
> 		ACSViol- UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> 		RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol- CESta:	RxErr+ BadTLP+
> 		BadDLLP- Rollover- Timeout- NonFatalErr- CEMsk:	RxErr- BadTLP-
> 	BadDLLP- Rollover- Timeout- NonFatalErr- AERCap:	First Error
> 	Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn- Capabilities: [140 v1]
> Device Serial Number 00-1a-6b-ff-ff-6c-7e-a4 Kernel driver in use:
> e1000e 00: 86 80 9a 10 07 05 10 00 00 00 00 02 10 00 00 00 10: 00 00
> 00 ee 00 00 00 00 01 30 00 00 00 00 00 00 20: 00 00 00 00 00 00 00 00
> 00 00 00 00 aa 17 01 20 30: 00 00 00 00 c8 00 00 00 00 00 00 00 0b 01
> 00 00 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 01 d0 22 c8 00 20 00 0f
> d0: 05 e0 81 00 0c 10 e0 fe 00 00 00 00 c9 41 00 00
> e0: 10 00 01 00 c1 0c 00 00 1f 28 1a 00 11 1c 07 00
> f0: 42 01 11 10 00 00 00 00 00 00 00 00 00 00 00 00
> 
>> kernel.  Are there any messages in the system log regarding disabling
>> ASPM L0s and/or L1 on that device?
> 
> It would appear it is being disabled:
> 
> [    0.194271] ACPI FADT declares the system doesn't support PCIe
> ASPM, so disable it [    0.297112] pci 0000:01:00.0: disabling ASPM
> on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force' [  
> 0.298003] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device. 
> You can enable it with 'pcie_aspm=force' [    0.299123] pci
> 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable
> it with 'pcie_aspm=force' [   18.135907] e1000e 0000:02:00.0:
> Disabling ASPM  L1 [   18.137262] e1000e 0000:02:00.0: Disabling ASPM
> L0s   
> 
> but I see the same high ping latencies.
> 
>> I can understand the latency with the OpenSUSE 2.6.34-based kernels
>> assuming commit 19833b5dff is not present, but I do not understand
>> the latency with 2.6.36-rc3.
> 
> The first thing I tried was OpenSUSE 2.6.34 plus 19833b5dff.   This
> led me to 
> think it wasn't related to ASPM so I resorted to a bisect which ended
> up showing 
> it was 6f461f6c7c.
> 
> Anyways, all of the above is from vanilla 2.6.36-rc3 so lets ignore
> OpenSUSE 
> kernels.
> 
> http://ftp.suse.com/pub/people/tonyj/82573L/config  is the config for
> .36-rc3 
> generated using localmodconfig, defaults chosen for all prompts.
> 
> http://ftp.suse.com/pub/people/tonyj/82573L/dmesg  is the full dmesg
> 
> Tony

ASPM L1 must be disabled on this device otherwise the latency described
above will happen.  And even though there are log messages indicating
ASPM L1 is disabled, it really isn't according to the verbose lspci
output and PCI config space for the 2:0.0 device (see LnkCtl above).
Since CONFIG_PCIEASPM is enabled in your kernel config, the driver is
calling the kernel function pci_disable_link_state() to disable ASPM L1
which it fails to do because the variable aspm_disabled=1 (as indicated
by the "ACPI FADT declares the system doesn't support PCIe ASPM, so
disable it" message).

I'm unclear on whether the aspm_disabled variable is meant to indicate
ASPM L0s or both ASPM L0s _and_ L1 are disabled (added PCI maintainer
and linux-pci mail-list).  To resolve this issue, we need to either a)
change e1000e to directly write the PCI config space to disable ASPM L1
as was done before 6f461f6c7c, or b) fix pci_disable_link_state() et. al.
to allow for ASPM L1 to be disabled properly.  I would prefer the latter
option so that other drivers do not have to use the same kludge to write
to the PCI config space.  Any input from the PCI guys?

Alternatively in the meantime, if you disable CONFIG_PCIEASPM the e100e
driver will act how it did before 6f461f6c7c, i.e. it will directly write
the PCI config space to disable ASPM L1.

Thanks,
Bruce.
