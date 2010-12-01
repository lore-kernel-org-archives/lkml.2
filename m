Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0LAMoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 07:44:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab0LAMoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 07:44:54 -0500
Date: Wed, 1 Dec 2010 07:44:45 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Tejun Heo <tj@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.37
Message-ID: <20101201124445.GG25668@bombadil.infradead.org>
References: <20101022012302.GA7487@havoc.gtf.org>
 <20101129180755.GK15818@bombadil.infradead.org>
 <4CF506A6.4020200@kernel.org>
 <20101130153839.GM15818@bombadil.infradead.org>
 <4CF52652.4030802@kernel.org>
 <20101130163150.GA25668@bombadil.infradead.org>
 <20101130175317.GB25668@bombadil.infradead.org>
 <20101130210938.GF25668@bombadil.infradead.org>
 <4CF62EE0.7040607@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF62EE0.7040607@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 12:17:52PM +0100, Tejun Heo wrote:
> > [10273.011241] ata1.00: internal command failure: stat=0xef
> > ehi_desc="irq_stat 0x00400001, PHY RDY changed"
> 
> Hmmm, so it's a timing problem.  For some reason, a PHY event is being
> reported after reset is complete which unfortunately gets reported
> while DIPM command is in progress.  Hmmm... what's broken is that the
> PHY event happens after reset is complete.  Can you please attach the
> output of "lspci -nn" and "hdparm -I /dev/sda"?  Looks a lot like a
> timing issue.  Maybe we'll have to add a delay somewhere.  :-(
> 
> 

Sure, np:

00:1f.2 SATA controller [0106]: Intel Corporation 5 Series/3400 Series
Chipset 6 port SATA AHCI Controller [8086:3b2f] (rev 06) (prog-if 01
[AHCI 1.0])
	Subsystem: Lenovo Device [17aa:2168]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 42
	Region 0: I/O ports at 1860 [size=8]
	Region 1: I/O ports at 1814 [size=4]
	Region 2: I/O ports at 1818 [size=8]
	Region 3: I/O ports at 1810 [size=4]
	Region 4: I/O ports at 1840 [size=32]
	Region 5: Memory at f2727000 (32-bit, non-prefetchable)
[size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0100c  Data: 4161
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

/dev/sda:

ATA device, with non-removable media
	Model Number:       HITACHI HTS725032A9A364                 
	Serial Number:      100407PCKC04VPHVB55K
	Firmware Revision:  PC3ZC70F
	Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II
Extensions, SATA Rev 2.5, SATA Rev 2.6; Revision: ATA8-AST T13 Project
D1697 Revision 0b
Standards:
	Used: unknown (minor revision code 0x0028) 
	Supported: 8 7 6 5 
	Likely used: 8
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  625142448
	Logical  Sector size:                   512 bytes
	Physical Sector size:                   512 bytes
	device size with M = 1024*1024:      305245 MBytes
	device size with M = 1000*1000:      320072 MBytes (320 GB)
	cache/buffer size  = 15151 KBytes (type=DualPortCache)
	Form Factor: 2.5 inch
	Nominal Media Rotation Rate: 7200
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Vendor, no device specific
minimum
	R/W multiple sector transfer: Max = 16	Current = ?
	Advanced power management level: 254
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5 
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4 
	     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	DOWNLOAD_MICROCODE
	   *	Advanced Power Management feature set
	    	SET_MAX security extension
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	   *	General Purpose Logging feature set
	   *	64-bit World wide name
	   *	IDLE_IMMEDIATE with UNLOAD
	   *	WRITE_UNCORRECTABLE_EXT command
	   *	{READ,WRITE}_DMA_EXT_GPL commands
	   *	Segmented DOWNLOAD_MICROCODE
	   *	Gen1 signaling speed (1.5Gb/s)
	   *	Gen2 signaling speed (3.0Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Host-initiated interface power management
	   *	Phy event counters
	   *	Idle-Unload when NCQ is active
	   *	NCQ priority information
	   *	DMA Setup Auto-Activate optimization
	    	Device-initiated interface power management
	   *	Software settings preservation
	   *	SMART Command Transport (SCT) feature set
	   *	SCT LBA Segment Access (AC2)
	   *	SCT Error Recovery Control (AC3)
	   *	SCT Features Control (AC4)
	   *	SCT Data Tables (AC5)
Security: 
	Master password revision code = 65534
		supported
	not	enabled
	not	locked
	not	frozen
	not	expired: security count
		supported: enhanced erase
	88min for SECURITY ERASE UNIT. 88min for ENHANCED SECURITY ERASE
UNIT.
Logical Unit WWN Device Identifier: 5000cca5b7da1312
	NAA		: 5
	IEEE OUI	: 000cca
	Unique ID	: 5b7da1312
Checksum: correct

regards, Kyle
