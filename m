Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab2LCGnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 01:43:32 -0500
Received: from nm27-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.227]:32536
	"EHLO nm27-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293Ab2LCGna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 01:43:30 -0500
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2012 01:43:30 EST
X-Yahoo-Newman-Id: 280622.27498.bm@smtp104.rog.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KkCKJGAVM1ml6UmHZPJqQ4g1GujTPx_eb5pKFpBDFGMeY9.
 zDaBTMSHGug8LuYPsHK6lZoFq_KjZFW0MjNzZMz46LimWRaMjVrF7P2XP1s9
 J5E0jSGX_r19JTBA08UXqzPNfe08PI.KFxqXsOVzfKbwvj18K7m0.59DoK4i
 tmcYmggeOqL4_5xSkZQ.xr_kxOm7clqAyfOddjgnALeVsDdtcMW4nufqIMMi
 0CnuSueSn0AukBbwYYAXxTedhoUFERXWNTWnuJTKfCzJxHB.HF229s.k3fEo
 CxeibZkxdk5K1wBOVMw5qvy7mrX1ddWlCa19kYboNwYg3C4pIv8mWZU2wH8o
 UMneVeLh9ZoN2VQLkVa2p3CEdhDgIptVEGDWXJPIRHBkTtLOgFjLLrHwVIfp
 iJjZLoY.jOaxv2K37jlVsVfpx1GNpAmoAN5cEVM0BJ3zch_L8oWak3ZwpIwF
 yLutbUToLn0GXDjhS5rgfvCQn7ZYOks0G
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [3.5/6.x][e1000e] - Regression - Unable to receive packets if MTU == 1500
Date: Mon, 03 Dec 2012 01:36:20 -0500
Message-ID: <3129701.ibSZ1FKvJb@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.9.3 (Linux/3.6.7-5.fc18.x86_64; KDE/4.9.3; x86_64; ; )
In-Reply-To: <7116504.sq7QLdbdRU@segfault.sh0n.net>
References: <7116504.sq7QLdbdRU@segfault.sh0n.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 01, 2012 02:01:05 PM Shawn Starr wrote:
> Hello network driver folks,

To follow up, this is fixed now in 3.6.7-5.fc18.x86_64 

[38936.525226] e1000e 0000:00:19.0: eth0: changing MTU from 9000 to 1500
[38936.539510] e1000e 0000:00:19.0: Interrupt Throttle Rate turned on
[38939.352053] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow 
Control: Rx/Tx

I don't remember which 3.6 -rc fixed it but I saw some adjustments in e1000e 
threshold changes in Linus's usual announce -rc emails.

Thanks for fixing! Now onto Fedora 19 (3.7) kernel testing

Shawn.

> 
> I recently decided to reinstall my Lenovo W500 laptop and found I wasn't
> able to get DHCP leases, I wasn't able to install over PXE (when getting
> the IP a second time within the OS)
> 
> Fedora is currently using kernel-3.6.2-2.fc18.x86_64 (Pre-beta)
> 
> The only difference I noticed was in my old install of Fedora, I had added
> MTU=9000 to the interface config while using a 3.5 kernel, not knowing 3.6.x
> seems to break things.
> 
> My Cisco DPC3825 Switch/Cable modem has an MTU setting but this is from
> Cable provider <-> WAN interface only. I tried changing to 1500 but by
> default it uses this anyway.
> 
> I had noticed tx unit hang errors sometimes, but not when MTU is above 1500.
> 
> PCI info:
> 
> 00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network
> Connection (rev 03)
>         Subsystem: Lenovo Device 20ee
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 46
>         Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=128K]
>         Region 1: Memory at fc025000 (32-bit, non-prefetchable) [size=4K]
>         Region 2: I/O ports at 1840 [size=32]
>         Capabilities: [c8] Power Management version 2
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
>         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                 Address: 00000000fee0100c  Data: 41a2
>         Capabilities: [e0] PCI Advanced Features
>                 AFCap: TP+ FLR+
>                 AFCtrl: FLR-
>                 AFStatus: TP-
>         Kernel driver in use: e1000e
> 
> e1000e conversation log:
> 
> [   12.653816] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
> [   12.653819] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
> [   12.653855] e1000e 0000:00:19.0: setting latency timer to 64
> [   12.653938] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set
> to dynamic conservative mode
> [   12.653980] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [   12.844121] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1)
> 00:22:68:0c:96:e3
> [   12.844124] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network
> Connection [   12.844150] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA
> No: 1008FF-0FF [   17.459570] e1000e 0000:00:19.0: eth0: changing MTU from
> 1500 to 9000 [   17.459577] e1000e 0000:00:19.0: Interrupt Throttle Rate
> turned off [   17.948121] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [   18.049164] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [   20.442936] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow
> Control: Rx/Tx
> 
> When I set MTU = 1500 (2000 works), it will stop receiving packets, it also
> disables Interrupt Throttling when MTU is set higher.
> 
> After testing reasons why it wasn't get a DHCP lease, I decided to bump the
> MTU to 9000 for Jumbo Frames and as soon as I did this, I was able to get a
> lease and the network functioned resumes receiving packets.
> 
> Can anyone else report regressions or might know whats going on?
> 
> Thanks,
> Shawn.
