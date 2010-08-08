Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0HHJzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 05:55:15 -0400
Received: from mx0.vr-web.de ([195.200.35.198]:59044 "EHLO mx0.vr-web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab0HHJzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 05:55:10 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Aug 2010 05:55:10 EDT
From: Andreas <andihartmann@01019freenet.de>
X-Newsgroups: linux.kernel
Subject: rt61pci - bad performance
Date: Sun, 08 Aug 2010 11:49:49 +0200
Organization: privat
Message-ID: <i3lug9$bfn$1@ID-44327.news.uni-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: abuse@arcor.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.3a6pre) Gecko/20100803 SeaMonkey/2.1a2
To: linux-kernel@vger.kernel.org
X-BitDefender-Scanner: Clean, Agent: BitDefender Courier 3.0.2 on
 vrwf203, sigver: 7.28621
X-BitDefender-CF-Stamp: none
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I've got the following hardware


01:05.0 Network controller: RaLink RT2561/RT61 rev B 802.11g
         Subsystem: Micro-Star International Co., Ltd. Device b833
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 128, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 21
         Region 0: Memory at cc000000 (32-bit, non-prefetchable) [size=32K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: ndiswrapper


running on a 32bit notebook with kernel 2.6.34-12-desktop (OpenSuSE 
11.3). There is no difference between the compat-wireless-modules 
2010-07-20 and the original modules shipped with the openSuSE 11.3 kernel.

If the rt61-chip is connected to a AP using rt61pci, the best 
throughput, which can be achieved (at the same place), is about 1,7 
MBytes/s.

kernel: [  656.112190] cfg80211: Calling CRDA to update world regulatory 
domain
kernel: [  656.112267] cfg80211: Calling CRDA for country: DE
kernel: [  656.169518] cfg80211: Regulatory domain changed to country: DE
kernel: [  656.169524]     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
kernel: [  656.169528]     (2400000 KHz - 2483500 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
kernel: [  656.169532]     (5150000 KHz - 5350000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
kernel: [  656.169535]     (5470000 KHz - 5725000 KHz @ 40000 KHz), 
(N/A, 2698 mBm)
kernel: [  656.206228] rt61pci 0000:01:05.0: PCI INT A -> GSI 21 (level, 
low) -> IRQ 21
kernel: [  656.219941] phy0: Selected rate control algorithm 'minstrel'
kernel: [  656.222216] Registered led device: rt61pci-phy0::radio
kernel: [  656.222658] Registered led device: rt61pci-phy0::assoc
kernel: notebook1 ifup:     wlan0     device: RaLink RT2561/RT61 rev B 
802.11g



wlan0     IEEE 802.11bg  ESSID:"--------"
           Mode:Managed  Frequency:2.412 GHz  Access Point: some AP
           Bit Rate=1 Mb/s   Tx-Power=5 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:off
           Link Quality=38/70  Signal level=-72 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

The throughput is measured with ping -f -s 7000 and xosview -n.




If I'm using ndiswrapper with the windows driver, first of all, I can 
see additional information in iwconfig:

wlan0     IEEE 802.11g  ESSID:"--------"
           Mode:Managed  Frequency:2.412 GHz  Access Point: some AP
           Bit Rate=54 Mb/s   Tx-Power:20 dBm   Sensitivity=-121 dBm
           RTS thr=2347 B   Fragment thr=2346 B
           Encryption key:some key   Security mode:restricted
           Power Management:off
           Link Quality:62/100  Signal level:-56 dBm  Noise level:-96 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0


There is a switch for sensitivity (which is not supported with rt61pci) 
and the link quality compared with ndiswrapper is worse (38% to 62%).

The following is remarkably too:
ndiswrapper uses a Tx-Power of 20 dBm, rt61pci only 5 dBm. I don't know, 
why rt61pci uses 5 dBm. It's a hard limit and I can't set it on a value 
higher than 5 unless the driver is patched. Nevertheless, setting a 
higher value (of 20 dBm) by patch does not mean to get a better performance.
Ndiswrapper shows an encryption key, rt61pci not. Does it mean, that 
rt61pci doesn't use hardware encryption?


With ndiswrapper, the rt61pci-chip achieves a throughput of 2,6 MBytes/s 
- that's about 1 MByte/s more than rt61pci.

I have to say, that the difference between rt61pci and ndiswrapper gets 
worse if the link quality is getting more badly. Or in other words: 
ndiswrapper handles bad connections better then rt61pci.


Do you have any idea to get rt61pci working as fast as ndiswrapper?


Kind regards,
Andreas
