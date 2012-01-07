Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418Ab2AGDM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 22:12:26 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43246 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759048Ab2AGDMY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 22:12:24 -0500
MIME-Version: 1.0
In-Reply-To: <20090428202259.ede11021.akpm@linux-foundation.org>
References: <49F2D0B1.6030800@t-online.de>
	<20090428202259.ede11021.akpm@linux-foundation.org>
Date: Fri, 6 Jan 2012 19:12:23 -0800
X-Google-Sender-Auth: aDOTogYCRiQTkuSo52k-RIKxk_w
Message-ID: <CANcMJZCVeC8FS0hptZ3+_Wu7E9vMqxoQOZ5ejVivJ1diiXh1NA@mail.gmail.com>
Subject: Re: 2.6.30-rc3, forcedeth: no net
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harald Dunkel <harald.dunkel@t-online.de>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 8:22 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> (cc's added)
> On Sat, 25 Apr 2009 10:58:25 +0200 Harald Dunkel <harald.dunkel@t-online.de> wrote:
>
>> There is a problem with forcedeth: The initialization on my
>> machine takes several minutes. This exceeds the usual wait
>> loop of dhcpcd. Using a static IP address doesn't help, either.
>> IP address and so on are set correctly, but there is still
>> no net.
>>
>> I could reproduce this with 2.6.29.1 and 2.6.30-rc3. For
>> testing I had reverted cb52deba12f27af90a46d2f8667a64888118a888
>> ("power down phy when interface is down"), but this did not help.
>> It was a wild guess, anyway.
>>
>> /var/log/messages:
>> :
>> :
>> Apr 25 10:29:53 elmer kernel: [    5.796093] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
>> Apr 25 10:29:53 elmer kernel: [    5.908812] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 22
>> Apr 25 10:29:53 elmer kernel: [    5.944151] forcedeth 0000:00:0a.0: PCI INT A -> Link[LMAC] -> GSI 22 (level, low) -> IRQ 22
>> Apr 25 10:29:53 elmer kernel: [    6.056607] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:22:68:62:c1:8d
>> Apr 25 10:29:53 elmer kernel: [    6.075176] usbcore: registered new interface driver usbfs
>> Apr 25 10:29:53 elmer kernel: [    6.154910] forcedeth 0000:00:0a.0: highdma csum pwrctl gbit lnktim msi desc-v3
>> :
>> :
>> Apr 25 10:29:54 elmer kernel: [   22.422017] eth0: no link during initialization.
>> Apr 25 10:29:54 elmer kernel: [   24.774868] eth0: link up.
>> Apr 25 10:29:54 elmer kernel: [   24.780817] eth0: link down.
>> Apr 25 10:29:54 elmer kernel: [   31.401174] eth0: link up.
>> Apr 25 10:29:54 elmer kernel: [   33.169139] eth0: link down.
>> Apr 25 10:29:54 elmer kernel: [   38.006407] eth0: link up.
>> Apr 25 10:29:54 elmer kernel: [   38.011970] eth0: link down.
>> Apr 25 10:31:58 elmer kernel: [  216.027643] eth0: link up.
>> :
>>
>> lspci:
>> 00:0a.0 Ethernet controller: nVidia Corporation MCP79 Ethernet (rev b1)
>>         Subsystem: Acer Incorporated [ALI] Device 0222
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0 (250ns min, 5000ns max)
>>         Interrupt: pin A routed to IRQ 22
>>         Region 0: Memory at fae7d000 (32-bit, non-prefetchable) [size=4K]
>>         Region 1: I/O ports at d080 [size=8]
>>         Region 2: Memory at fae7e800 (32-bit, non-prefetchable) [size=256]
>>         Region 3: Memory at fae7e400 (32-bit, non-prefetchable) [size=16]
>>         Capabilities: [44] Power Management version 2
>>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
>>         Kernel driver in use: forcedeth
>>
>> The machine is an Acer Aspire Revo.
>>

Just FYI, I burned the day chasing a very similar issue on an Acer
Aspire Revo (R1600).  After being a fine test machine for a few years,
all of a sudden the link would seem to go down when booting custom
kernels.  Running. ifconfig eth0 down; ifconfig eth0 up would fix it,
as would unplugging and re-plugging in the cable.  Once it got into
this state, changing kernel versions wouldn't matter. No link at
bootup.

The only odd bit was the distro kernel (Ubuntu 11.10 3.0.0 based)
would usually work (although not always). I suspect this has to do
with some sort of timing issue, as the distro kernel uses modules and
my kernels are statically linked.

In the past, this had happened once before, and disconnecting the
power to the system for a bit, and then reconnecting it seemed to
resolve it. Unfortunately that didn't work this time.

Anyway, after trying numerous kernels and config changes trying to
narrow things down, I ended up flashing the BIOS (from P01-A1 to
P01-A4L_A) and the issue went away.

Anyway, googling on this shows tons of similar strange behavior with
forcedeth, so I wanted to post what worked for me.  And while it may
just be some old BIOS/firmware bug, the odd behavior between distro
kernels and my own makes me suspect there's some sort of timing race
with the current driver when the network adapter gets into this
strange state.

thanks
-john
