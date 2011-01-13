Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120Ab1AMRy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:54:27 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34345 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933091Ab1AMRyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:54:25 -0500
Date: Thu, 13 Jan 2011 18:55:31 +0100
From: Borislav Petkov <bp@amd64.org>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Matthew Garrett <mjg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
Message-ID: <20110113175531.GD2006@aftab>
References: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com>
 <1294934542-2411-2-git-send-email-manoj.iyer@canonical.com>
 <20110113164616.GB21289@srcf.ucam.org>
 <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6>
 <20110113172205.GA30866@kryptos.osrc.amd.com>
 <AANLkTinw23rtSERxAy6G_cu5=rvQeEzxvf3snsUOZE+z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinw23rtSERxAy6G_cu5=rvQeEzxvf3snsUOZE+z@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 12:33:27PM -0500, Manoj Iyer wrote:
> Borislav,
> 
> Please see below lspci and dmesg output from AMD based ThinkPad Edge 11.
> 
> lspci
> =====
> 00:00.0 Host bridge [0600]: Advanced Micro Devices [AMD] RS780 Host
> Bridge Alternate [1022:9601]
>         Subsystem: Lenovo Device [17aa:21ca]
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort+ >SERR- <PERR- INTx-
>         Latency: 0
>         Capabilities: [c4] HyperTransport: Slave or Primary Interface
>                 Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
>                 Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> IsocEn- LSEn+ ExtCTL- 64b-
>                 Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
> DwFcInEn- LWO=16bit DwFcOutEn-
>                 Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
> IsocEn- LSEn- ExtCTL- 64b-
>                 Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit
> DwFcInEn- LWO=8bit DwFcOutEn-
>                 Revision ID: 3.00
>                 Link Frequency 0: 1.0GHz
>                 Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
>                 Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
> 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
>                 Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
>                 Link Frequency 1: 200MHz
>                 Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
>                 Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz-
> 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
>                 Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF-
> RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
>                 Prefetchable memory behind bridge Upper: 00-00
>                 Bus Number: 00
>         Capabilities: [54] HyperTransport: UnitID Clumping
>         Capabilities: [40] HyperTransport: Retry Mode
>         Capabilities: [9c] HyperTransport: #1a
>         Capabilities: [f8] HyperTransport: #1c
> 
> 00:01.0 PCI bridge [0604]: Advanced Micro Devices [AMD] RS780 PCI to
> PCI bridge (int gfx) [1022:9602] (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 64
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
>         I/O behind bridge: 00009000-00009fff
>         Memory behind bridge: d0400000-d05fffff
>         Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
>         Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
>         Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] RS780 PCI
> to PCI bridge (int gfx) [1022:9602]
>         Kernel modules: shpchp
> 
> 00:04.0 PCI bridge [0604]: Advanced Micro Devices [AMD] RS780 PCI to
> PCI bridge (PCIE port 0) [1022:9604] (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 32 bytes
>         Bus: primary=00, secondary=02, subordinate=07, sec-latency=0
>         I/O behind bridge: 0000a000-0000bfff
>         Memory behind bridge: 80000000-800fffff
>         Prefetchable memory behind bridge: 00000000d0000000-00000000d03fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: [50] Power Management version 3
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>                         ExtTag+ RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> 

This doesn't look complete since it shows only 3 PCI devices. Can you do

lspci -vv >> lspci.out

and attach the file instead since the mail client wraps the lines anyway.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
