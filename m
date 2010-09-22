Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0IVDpC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 23:45:02 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44454 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092Ab0IVDpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 23:45:01 -0400
X-Sasl-enc: +1QoH7woWO9aj9LrVqQ+esz3AiIcUUuxNpmbJ3tcJ7AR 1285127099
Message-ID: <F4A6AD940A32478B9CDE3EACAF33BC9D@jem>
From: "Rob Mueller" <robm@fastmail.fm>
To: "Christoph Lameter" <cl@linux.com>, "Mel Gorman" <mel@csn.ul.ie>
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, "Bron Gondwana" <brong@fastmail.fm>,
        "linux-mm" <linux-mm@kvack.org>
References: <1284349152.15254.1394658481@webmail.messagingengine.com> <20100916184240.3BC9.A69D9226@jp.fujitsu.com> <20100920093440.GD1998@csn.ul.ie> <52C8765522A740A4A5C027E8FDFFDFE3@jem> <20100921090407.GA11439@csn.ul.ie> <alpine.DEB.2.00.1009210911270.1271@router.home>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad forfile/email/web servers
Date: Wed, 22 Sep 2010 13:44:51 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This could be a screwy hardware issue as pointed out before. Certain
> controllers restrict the memory that I/O can be done to also (32 bit
> controller only able to do I/O to lower 2G?, controller on a PCI bus that
> is local only to a particular node) which would make balancing
> the file cache difficult.

Ah interesting. Is there an easy way to tell if this is an issue? It's an 
ARECA RAID controller, this is the lspci -vvv data from it...

03:00.0 RAID bus controller: Areca Technology Corp. Device 1680
        Subsystem: Areca Technology Corp. Device 1680
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 26
        Region 0: Memory at b1900000 (32-bit, non-prefetchable) [size=8K]
        Expansion ROM at b1c00000 [disabled] [size=64K]
        Capabilities: [98] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [d0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 256 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM unknown, 
Latency L0 <128ns, L1 unlimited
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100] Advanced Error Reporting <?>
        Kernel driver in use: arcmsr



Rob

