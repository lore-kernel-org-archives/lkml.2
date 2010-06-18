Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0FRVTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 17:19:00 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:64150 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab0FRVS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 17:18:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bCJJdcB+d+oQ6qFdP4mRI8LIzY0sO5k2MPYH2Slp6z+3tos/luqldIS0RaUdH0resX
         6dSbHdMvZzIKPkgcGENOtzjcVBv2fzkez83kugp9bruqfQD7qyikiQLgZ7TogewmMjBr
         OtnlxBXSSJVdfVzX5Fmw/duEPCFJfiiYkm84I=
MIME-Version: 1.0
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
Date: Fri, 18 Jun 2010 14:18:57 -0700
X-Google-Sender-Auth: iJEd-GUoBHEyJxSaZ7dqhJ4uWeU
Message-ID: <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
Subject: Re: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I: 
	Enable Online Controller Reset Bit in register related functions
From: Yinghai Lu <yinghai@kernel.org>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
       "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 7:34 PM, Yang, Bo <Bo.Yang@lsi.com> wrote:
> Enable the Online Controller reset bit in the register related functions.  This is first part of the Online Controller Reset.
> The driver supports XScle and Gen2 chips.  Driver need to read the FW state register to see if there is FW state change
> Happen.
>
> Signed-off-by Bo Yang<bo.yang@lsi.com>

This patch cause kernel hang just after
[  136.996297] megasas: FW now in Ready state

# lspci -vvxxx -s 01:00.0
01:00.0 RAID bus controller: LSI Logic / Symbios Logic LSI MegaSAS 9260 (rev 03)
	Subsystem: LSI Logic / Symbios Logic MegaRAID SAS 9262-8i
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 28
	Region 0: I/O ports at 1c00 [size=256]
	Region 1: Memory at aaefc000 (64-bit, non-prefetchable) [size=16K]
	Region 3: Memory at aae80000 (64-bit, non-prefetchable) [size=256K]
	Expansion ROM at aae40000 [disabled] [size=256K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x8, ASPM L0s, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [d0] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Connection timed out
		Not readable
	Capabilities: [a8] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [c0] MSI-X: Enable- Count=15 Masked-
		Vector table: BAR=1 offset=00002000
		PBA: BAR=1 offset=00003800
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [138] Power Budgeting <?>
	Kernel driver in use: megaraid_sas
00: 00 10 79 00 47 01 10 00 03 00 04 01 40 00 00 00
10: 01 1c 00 00 04 c0 ef aa 00 00 00 00 04 00 e8 aa
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 10 62 92
30: 00 00 e4 aa 50 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 68 03 06 08 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 01 00 00 10 d0 02 00 25 80 00 10
70: 17 28 00 00 82 04 00 00 40 00 42 10 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 16 00 00 00
90: 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 05 c0 80 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 11 00 0e 00 01 20 00 00 01 38 00 00 00 00 00 00
d0: 03 a8 ff 1f 82 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00



YH
