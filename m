Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858Ab0J0LfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:35:21 -0400
Received: from 78-83-101-184.spectrumnet.bg ([78.83.101.184]:32827 "EHLO
	croler.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754365Ab0J0LfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:35:17 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Oct 2010 07:35:16 EDT
Message-ID: <4CC80AF3.9040708@croler.net>
Date: Wed, 27 Oct 2010 14:20:19 +0300
From: Nikolay Pelov <npelov@croler.net>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: linux kernel 2.6.35.7 R6040 network driver messages
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-nicksoft.info-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: o9RBKEH4028258
X-nicksoft.info-MailScanner: Found to be clean
X-nicksoft.info-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-1.799, required 1, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_50 0.00)
X-nicksoft.info-MailScanner-From: npelov@croler.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I haven't reported kernel bug until now. I'll try to send as much 
information as I can. I hope it is sufficient.

1. I see repeating (flood) messages "Oct 27 13:14:59 mclive5 kernel: 
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1" in my syslog - once per 
second.
2.  Frequency is probably one message per second because I see this on 
every 61 seconds: "last message repeated 61 times". I'm not sure if the 
problem is in the driver or in OS because I use Centos 5.5 with newer 
kernel, but I don't have the same problem with other network adapters. 
R6040 is build into kernet, not as a module.
3. keywords: modules, networking, kernel, problem, linkup, syslog, 
r6040, MicroClient JrMX
4. kernel version - # cat /proc/version
Linux version 2.6.35.7-ns.i586 (root@localhost.localdomain) (gcc version 
4.1.2 20080704 (Red Hat 4.1.2-48)) #15 Thu Oct 21 18:26:55 CEST 2010
SMP is disabled
5.
6. The problem is always presend. doesn't have to trigger it. only bring 
interface up:
ifconfig eth0 up
7.1 Operating system is Centos 5.5 without updates. it's run as livecd 
(my own modification). initrd is completely rewritten - it uses bash for 
init script. init script just mounts the filesystem and ends with:
exec chroot . /bin/bash <<- EOF >/dev/console

echo "running init"
exec /sbin/init $level

EOF

root filesystem is AUFS that consists of:
  one squashfs image
  one tmpfs ram disk with size=200M

7.2. processor info:
Processor is Xcore86 MX at 1 GHz and it is i586 compatible
/proc/cpu reports Vortex86 SoC
flags           : fpu tsc cx8
7.3 module information:
# cat /proc/modules
ipv6 216009 16 - Live 0xe08ba000
hidp 9827 2 - Live 0xe086b000
l2cap 33993 5 hidp, Live 0xe0875000
crc16 995 1 l2cap, Live 0xe085d000
bluetooth 46244 2 hidp,l2cap, Live 0xe0842000
rfkill 7982 1 bluetooth, Live 0xe0824000
tun 12103 0 - Live 0xe0979000
dm_mirror 11560 0 - Live 0xe0967000
dm_region_hash 5376 1 dm_mirror, Live 0xe0957000
dm_log 7531 2 dm_mirror,dm_region_hash, Live 0xe094a000
dm_multipath 14155 0 - Live 0xe092e000
scsi_dh 3972 1 dm_multipath, Live 0xe091f000
dm_mod 52849 3 dm_mirror,dm_log,dm_multipath, Live 0xe0903000
option 12594 0 - Live 0xe08b4000
usb_wwan 6820 1 option, Live 0xe0899000
serio_raw 3328 0 - Live 0xe088c000
rtc_cmos 7326 0 - Live 0xe0880000
rtc_core 10393 1 rtc_cmos, Live 0xe0870000
pcspkr 1279 0 - Live 0xe0857000
rtc_lib 1477 1 rtc_core, Live 0xe0861000

7.4 Loaded driver and hardware information
# cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc_cmos
  0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:0c.0
  0170-0177 : pata_rdc
01f0-01f7 : 0000:00:0c.0
  01f0-01f7 : pata_rdc
02e8-02ef : serial
0376-0376 : 0000:00:0c.0
  0376-0376 : pata_rdc
03c0-03df : vga+
03e8-03ef : serial
03f6-03f6 : 0000:00:0c.0
  03f6-03f6 : pata_rdc
03f8-03ff : serial
0cf8-0cff : PCI conf1
de00-deff : 0000:00:08.0
  de00-deff : r6040
df80-dfff : 0000:00:0d.0
ef00-ef0f : 0000:00:0c.0
  ef00-ef0f : pata_rdc

# cat  /proc/iomem
00000000-00000fff : reserved
00001000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000e4000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-1fffffff : System RAM
  00400000-007c990c : Kernel code
  007c990d-0095d2d7 : Kernel data
  009c1000-00a40e37 : Kernel bss
f8000000-fbffffff : 0000:00:0d.0
febc0000-febcffff : 0000:00:08.0
febd9000-febd9fff : 0000:00:0a.0
  febd9000-febd9fff : ohci_hcd
febda000-febdafff : 0000:00:0b.0
  febda000-febdafff : ohci_hcd
febdb400-febdb4ff : 0000:00:08.0
  febdb400-febdb4ff : r6040
febdb800-febdb8ff : 0000:00:0a.1
  febdb800-febdb8ff : ehci_hcd
febdbc00-febdbcff : 0000:00:0b.1
  febdbc00-febdbcff : ehci_hcd
febdc000-febdffff : 0000:00:0e.0
febe0000-febfffff : 0000:00:0d.0
ff000000-ffffffff : reserved

7.5 PCI info:
# lspci -vvv
00:00.0 Host bridge: RDC Semiconductor, Inc. R6021 Host Bridge (rev 02)
        Control: I/O- Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0

00:07.0 ISA bridge: RDC Semiconductor, Inc. Unknown device 6036
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=?? >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:08.0 Ethernet controller: RDC Semiconductor, Inc. R6040 MAC Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 128 (750ns min, 2000ns max)
        Interrupt: pin A routed to IRQ 7
        Region 0: I/O ports at de00 [size=256]
        Region 1: Memory at febdb400 (32-bit, non-prefetchable) [size=256]
        Expansion ROM at febc0000 [disabled] [size=64K]

00:0a.0 USB Controller: RDC Semiconductor, Inc. R6060 USB 1.1 Controller 
(rev 12) (prog-if 10 [OHCI])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 128, Cache Line Size: 16 bytes
        Interrupt: pin A routed to IRQ 3
        Region 0: Memory at febd9000 (32-bit, non-prefetchable) [size=4K]

00:0a.1 USB Controller: RDC Semiconductor, Inc. R6061 USB 2.0 Controller 
(rev 03) (prog-if 20 [EHCI])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 128, Cache Line Size: 16 bytes
        Interrupt: pin B routed to IRQ 3
        Region 0: Memory at febdb800 (32-bit, non-prefetchable) [size=256]

00:0b.0 USB Controller: RDC Semiconductor, Inc. R6060 USB 1.1 Controller 
(rev 12) (prog-if 10 [OHCI])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 128, Cache Line Size: 16 bytes
        Interrupt: pin A routed to IRQ 3
        Region 0: Memory at febda000 (32-bit, non-prefetchable) [size=4K]

00:0b.1 USB Controller: RDC Semiconductor, Inc. R6061 USB 2.0 Controller 
(rev 03) (prog-if 20 [EHCI])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 128, Cache Line Size: 16 bytes
        Interrupt: pin B routed to IRQ 3
        Region 0: Memory at febdbc00 (32-bit, non-prefetchable) [size=256]

00:0c.0 IDE interface: RDC Semiconductor, Inc. Unknown device 1011 (rev 
01) (prog-if 8a [Master SecP PriP])
        Subsystem: RDC Semiconductor, Inc. Unknown device 1011
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size: 16 bytes
        Interrupt: pin A routed to IRQ 14
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at ef00 [size=16]

00:0d.0 VGA compatible controller: RDC Semiconductor, Inc. Unknown 
device 2010 (prog-if 00 [VGA controller])
        Subsystem: RDC Semiconductor, Inc. Unknown device 2010
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 9
        Region 0: Memory at f8000000 (32-bit, non-prefetchable) [size=64M]
        Region 1: Memory at febe0000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at df80 [size=128]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0e.0 Audio device: RDC Semiconductor, Inc. Unknown device 3010 (rev 01)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 128, Cache Line Size: 16 bytes
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at febdc000 (32-bit, non-prefetchable) [size=16K]

7.6 SCSI info
# cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD1600BEVT-0 Rev: 11.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05

7.7 Other information that might be relevant to the problem
can't think of
8. Other notes, patches, fixes, workarounds
AUFS patch was added to kernel 2.6.35.7
no other patches to kernel
hardware is: http://www.norhtec.com/products/mcjrmx/index.html, but it's 
not documented very well.
RAM: 512

I had similar problems with kernel 2.6.29  (not absolutely sure about 
the version) and another hardware (i486 compatible - XCore86 DX CPU on a 
Microclient JrDX), but the messages were output to the console and were 
a lot faster - few messages per second.


Good Luck!

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

