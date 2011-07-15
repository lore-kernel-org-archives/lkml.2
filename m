Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750873Ab1GOLVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 07:21:07 -0400
Received: from mxin.ulb.ac.be ([164.15.128.112]:41712 "EHLO mxin.ulb.ac.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab1GOLVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 07:21:05 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jul 2011 07:21:05 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEAH8bIE6kDwpa/2dsb2JhbABUqFjMOw6GLASXWYRrhnc
Date: Fri, 15 Jul 2011 13:11:00 +0200
From: Arnuschky <arnuschky@xylon.de>
To: Michael Witten <mfwitten@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Dropped IRQ disables Radeon 3D
Message-ID: <20110715131100.367bc576@edison>
In-Reply-To: <15f2d51a1ab5412a9d7c327ab67b8166-mfwitten@gmail.com>
References: <d74f405530c34a2f9fdae3d7cf37e0fcmfwitten@gmail.com>
	<0fe54f4a77b64475b9e6041d9ef5772b-mfwitten@gmail.com>
	<1310720984.4968.313.camel@pasglop>
	<15f2d51a1ab5412a9d7c327ab67b8166-mfwitten@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jul 2011 10:53:41 -0000 Michael Witten <mfwitten@gmail.com>
wrote:
> On Fri, 15 Jul 2011 19:09:44 +1000, Benjamin Herrenschmidt wrote:
> >
> > Another problem I noticed is some cards, when not using MSIs, still
> > seem to shoot an MSI with whatever value was last programmed into
> > the MSI configuration space. Can you check with lspci -vv if
> > there's a non-0 value in there ? It -could- be that your get bogus
> > MSIs.
> 
> So, you want me to boot my Linux version that doesn't have MSI support
> and check whether `sudo lspci -vv' says that it is using MSIs?

I thought that you've enabled it now? Anyways, I do have an enabled MSI
kernel (2.6.38 ubuntu 64bit stock):

  # grep MSI /boot/config-2.6.38-8-server 
  CONFIG_ARCH_SUPPORTS_MSI=y
  CONFIG_PCI_MSI=y
  CONFIG_MSI_LAPTOP=m
  CONFIG_MSI_WMI=m

But it does not seem to be enabled/working on my system:

  # dmesg | grep -i msi
  [    0.372534] pci 0000:04:00.0: PXH quirk detected; SHPC device MSI disabled
  [    0.372668] pci 0000:04:00.2: PXH quirk detected; SHPC device MSI disabled
  [    0.373371] pci 0000:0a:00.0: PXH quirk detected; SHPC device MSI disabled
  [    0.373498] pci 0000:0a:00.2: PXH quirk detected; SHPC device MSI disabled
  
although pci -vv does list it for my PCIe bridges (see below). I will
try to run with nomsi as soon as I can reboot the machine...

Cheers,
Arnuschky

  0a:00.2 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge B (rev 09) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=0a, secondary=0c, subordinate=0c, sec-latency=32
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: df500000-df6fffff
	Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [44] Express (v1) PCI/PCI-X Bridge, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [5c] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [6c] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d8] PCI-X bridge device
		Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=conv
		Status: Dev=0a:00.2 64bit- 133MHz- SCD- USC- SCO- SRD-
		Upstream: Capacity=65535 CommitmentLimit=65535
		Downstream: Capacity=65535 CommitmentLimit=65535
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [300 v1] Power Budgeting <?>
	Kernel modules: shpchp


