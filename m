Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab0FIUqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 16:46:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50730 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899Ab0FIUqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 16:46:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:content-type:subject:date:message-id:to:mime-version:x-mailer;
        b=dQOzkdVYwaj2zpBv/w/K83UvAPe/Iz3edC/OYkMxKwzptKRhMwT9M7YzzRTM8QvNH7
         GIXFBtWWylEfdjuTHBiqIw/5l4iTiwREo53s0G2HAF3LQrH2j3Ouv96VTbkhCL/vPvSL
         DBoei1TMzVqp/6hCILZ9aM399QitH0aSsRqzo=
From: Ales Teska <ales.teska@gmail.com>
Content-Type: multipart/signed; boundary=Apple-Mail-3--691038633; protocol="application/pkcs7-signature"; micalg=sha1
Subject: PROBLEM: PPP and other serial port related application hangs in kernel space
Date: Wed, 9 Jun 2010 22:46:28 +0200
Message-Id: <900E3B14-5B92-4A37-9581-049DB40F4D1C@gmail.com>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1078)
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-3--691038633
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi all,

after upgrade of Linux kernel to version 2.6.34 I started to observe =
following problem - ppp and other serial port related application =
occasionally (in 1 hour or 1/10 ppp connections) 'hangs' (see =
description bellow) rendering related serial device unusable. I =
backtracked this issue to 2.6.32.15.
Application remains in the condition marked as 'D' in 'ps' output =
(waiting for result from kernel space, if I understand that correctly); =
it stays in this condition forever.
Moreover any other application that tries to open same serial port hangs =
the same way.

Here is example of such a situation:
# ps ax
  PID TTY      STAT   TIME COMMAND
....
 1275 ?        D      0:01 ufoprobe-client /dev/ttyUSB0
....

I also found following information in dmesg:
[ 1673.660876] ------------[ cut here ]------------
[ 1673.661471] WARNING: at drivers/char/tty_io.c:1278 =
tty_open+0x213/0x451()
[ 1673.662358] Modules linked in: ppp_deflate zlib_deflate bsd_comp =
ppp_async crc_ccitt ppp_generic slhc ipv6 nvram msr cpuid ledtrig_timer =
ledtrig_heartbeat ledtrig_default_on geodewdt lm90 hwmon scx200_acb =
option usbserial ehci_hcd ohci_hcd via_rhine usbcore leds_alix2 mii
[ 1673.689168] Pid: 1275, comm: ufoprobe_client Not tainted =
2.6.34-486-exiprobes #1
[ 1673.690452] Call Trace:
[ 1673.690947]  [<c10e93af>] ? tty_open+0x213/0x451
[ 1673.691926]  [<c1018f51>] warn_slowpath_common+0x45/0x5c
[ 1673.693006]  [<c1018f75>] warn_slowpath_null+0xd/0x10
[ 1673.694293]  [<c10e93af>] tty_open+0x213/0x451
[ 1673.694755]  [<c1068105>] chrdev_open+0xe3/0x126
[ 1673.695733]  [<c10648e5>] __dentry_open+0x123/0x1f7
[ 1673.697472]  [<c10655f8>] nameidata_to_filp+0x29/0x3d
[ 1673.697726]  [<c1068022>] ? chrdev_open+0x0/0x126
[ 1673.698957]  [<c106d961>] do_last+0x361/0x474
[ 1673.700138]  [<c1066861>] ? percpu_counter_add+0x23/0x2f
[ 1673.701189]  [<c106ed97>] do_filp_open+0x165/0x3b5
[ 1673.701700]  [<c10212e8>] ? update_process_times+0x3a/0x3e
[ 1673.703295]  [<c1075c1b>] ? spin_unlock+0x17/0x22
[ 1673.704537]  [<c10646ac>] do_sys_open+0x4a/0xec
[ 1673.705244]  [<c1064790>] sys_open+0x1e/0x26
[ 1673.706190]  [<c118c835>] syscall_call+0x7/0xb
[ 1673.706644]  [<c1180000>] ? xfrm_add_pol_expire+0x7a/0x166
[ 1673.708205] ---[ end trace 69d4cf5dc236c7af ]---

Keywords: ppp tty serial
Kernel version: Linux version 2.6.34-486-exiprobes (root@voyage) (gcc =
version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 PREEMPT Wed =
Jun 9 19:18:19 GMT 2010

Environment:
ALIX2D2 Board with 2 LAN and 2 miniPCI, LX800, USB
LX-800 with integrated RAM and PSU
CPU: 500 MHz AMD Geode LX800
Dual USB port
DRAM: 256 MB DDR DRAM on board
Storage: CompactFlash socket
2 Ethernet channels (Via VT6105M 10/100)
I/O: DB9 serial port, dual USB port

# lspci
00:01.0 Host bridge: Advanced Micro Devices [AMD] Unknown device 2080 =
(rev 33)
00:01.2 Entertainment encryption device: Advanced Micro Devices [AMD] =
Geode LX AES Security Block
00:09.0 Ethernet controller: VIA Technologies, Inc. VT6105M [Rhine-III] =
(rev 96)
00:0b.0 Ethernet controller: VIA Technologies, Inc. VT6105M [Rhine-III] =
(rev 96)
00:0f.0 ISA bridge: Advanced Micro Devices [AMD] CS5536 [Geode =
companion] ISA (rev 03)
00:0f.2 IDE interface: Advanced Micro Devices [AMD] CS5536 [Geode =
companion] IDE (rev 01)
00:0f.4 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode =
companion] OHC (rev 02)
00:0f.5 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode =
companion] EHC (rev 02)

Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 5
model           : 10
model name      : Geode(TM) Integrated Processor by AMD PCS
stepping        : 2
cpu MHz         : 498.071
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu de pse tsc msr cx8 sep pge cmov clflush mmx mmxext =
3dnowext 3dnow
bogomips        : 996.14
clflush size    : 32
cache_alignment : 32
address sizes   : 32 bits physical, 32 bits virtual
power management:

Module information (from /proc/modules):=20
ppp_deflate 2734 0 - Live 0xd0a65000
zlib_deflate 15675 1 ppp_deflate, Live 0xd0a58000
bsd_comp 3754 0 - Live 0xd0a3c000
ppp_async 5124 0 - Live 0xd0a31000
crc_ccitt 983 1 ppp_async, Live 0xd0a26000
ppp_generic 13543 3 ppp_deflate,bsd_comp,ppp_async, Live 0xd0a19000
slhc 3559 1 ppp_generic, Live 0xd0a0b000
ipv6 183015 14 - Live 0xd09c8000
nvram 4136 0 - Live 0xd0981000
msr 1494 0 - Live 0xd0976000
cpuid 1263 0 - Live 0xd096c000
ledtrig_timer 1496 0 - Live 0xd0962000
ledtrig_heartbeat 857 0 - Live 0xd0958000
ledtrig_default_on 512 0 - Live 0xd094f000
geodewdt 2091 2 - Live 0xd0946000
lm90 6492 0 - Live 0xd093b000
hwmon 1007 1 lm90, Live 0xd092f000
scx200_acb 2570 0 - Live 0xd0925000
option 13661 2 - Live 0xd0915000
usbserial 22562 7 option, Live 0xd08f9000
ehci_hcd 38670 0 - Live 0xd08cc000
ohci_hcd 27580 0 - Live 0xd08ad000
via_rhine 15098 0 - Live 0xd0889000
usbcore 112174 5 option,usbserial,ehci_hcd,ohci_hcd, Live 0xd0856000
leds_alix2 1315 0 - Live 0xd0825000
mii 2687 1 via_rhine, Live 0xd0804000

Loaded driver and hardware information (/proc/ioports, /proc/iomem)
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
0170-0177 : 0000:00:0f.2
01f0-01f7 : 0000:00:0f.2
  01f0-01f7 : pata_cs5536
02f8-02ff : serial
0376-0376 : 0000:00:0f.2
03f6-03f6 : 0000:00:0f.2
  03f6-03f6 : pata_cs5536
03f8-03ff : serial
0cf8-0cff : PCI conf1
1000-10ff : 0000:00:09.0
  1000-10ff : via-rhine
1400-14ff : 0000:00:0b.0
  1400-14ff : via-rhine
6000-6007 : 0000:00:0f.0
  6000-6007 : CS5536 ACB0
6100-61ff : 0000:00:0f.0
  6100-61ff : leds_alix2
6200-623f : 0000:00:0f.0
  6200-623f : cs5535-mfgpt
9c00-9c3f : 0000:00:0f.0
9d00-9d7f : 0000:00:0f.0
ac1c-ac1f : 0000:00:01.0
ff00-ff0f : 0000:00:0f.2
  ff00-ff0f : pata_cs5536

# cat /proc/iomem  =20
00000000-00000fff : reserved
00001000-0009ffff : System RAM
000a0000-000bffff : Video RAM area
000e0000-000effff : Extension ROM
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-0fffffff : System RAM
  01000000-0118d4e5 : Kernel code
  0118d4e6-0125dde7 : Kernel data
  01282000-012d6bab : Kernel bss
e0000000-e00000ff : 0000:00:09.0
  e0000000-e00000ff : via-rhine
e0040000-e00400ff : 0000:00:0b.0
  e0040000-e00400ff : via-rhine
efff4000-efff7fff : 0000:00:01.2
  efff4000-efff7fff : geode-aes
efffd000-efffdfff : 0000:00:0f.5
  efffd000-efffdfff : ehci_hcd
efffe000-efffefff : 0000:00:0f.4
  efffe000-efffefff : ohci_hcd
fff00000-ffffffff : reserved

PCI information ('lspci -vvv' as root)
# lspci -vvv=20
00:01.0 Host bridge: Advanced Micro Devices [AMD] Unknown device 2080 =
(rev 33)
        Subsystem: Advanced Micro Devices [AMD] Unknown device 2080
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 248, Cache Line Size: 32 bytes
        Region 0: I/O ports at ac1c [size=3D4]

00:01.2 Entertainment encryption device: Advanced Micro Devices [AMD] =
Geode LX AES Security Block
        Subsystem: Advanced Micro Devices [AMD] Geode LX AES Security =
Block
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 9
        Region 0: Memory at efff4000 (32-bit, non-prefetchable) =
[size=3D16K]

00:09.0 Ethernet controller: VIA Technologies, Inc. VT6105M [Rhine-III] =
(rev 96)
        Subsystem: VIA Technologies, Inc. Unknown device 0106
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- =
ParErr- Stepping+ SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (750ns min, 2000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 10
        Region 0: I/O ports at 1000 [size=3D256]
        Region 1: Memory at e0000000 (32-bit, non-prefetchable) =
[size=3D256]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0b.0 Ethernet controller: VIA Technologies, Inc. VT6105M [Rhine-III] =
(rev 96)
        Subsystem: VIA Technologies, Inc. Unknown device 0106
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- =
ParErr- Stepping+ SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (750ns min, 2000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 15
        Region 0: I/O ports at 1400 [size=3D256]
        Region 1: Memory at e0040000 (32-bit, non-prefetchable) =
[size=3D256]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0f.0 ISA bridge: Advanced Micro Devices [AMD] CS5536 [Geode =
companion] ISA (rev 03)
        Subsystem: Advanced Micro Devices [AMD] CS5536 [Geode companion] =
ISA
        Control: I/O+ Mem- BusMaster- SpecCycle+ MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Region 0: I/O ports at 6000 [size=3D8]
        Region 1: I/O ports at 6100 [size=3D256]
        Region 2: I/O ports at 6200 [size=3D64]
        Region 3: I/O ports at <unassigned>
        Region 4: I/O ports at 9d00 [size=3D128]
        Region 5: I/O ports at 9c00 [size=3D64]

00:0f.2 IDE interface: Advanced Micro Devices [AMD] CS5536 [Geode =
companion] IDE (rev 01) (prog-if 80 [Master])
        Subsystem: Advanced Micro Devices [AMD] CS5536 [Geode companion] =
IDE
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 248, Cache Line Size: 32 bytes
        Region 0: [virtual] Memory at 000001f0 (32-bit, =
non-prefetchable) [disabled] [size=3D8]
        Region 1: [virtual] Memory at 000003f0 (type 3, =
non-prefetchable) [disabled] [size=3D1]
        Region 2: [virtual] Memory at 00000170 (32-bit, =
non-prefetchable) [disabled] [size=3D8]
        Region 3: [virtual] Memory at 00000370 (type 3, =
non-prefetchable) [disabled] [size=3D1]
        Region 4: I/O ports at ff00 [size=3D16]

00:0f.4 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode =
companion] OHC (rev 02) (prog-if 10 [OHCI])
        Subsystem: Advanced Micro Devices [AMD] CS5536 [Geode companion] =
OHC
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin D routed to IRQ 12
        Region 0: Memory at efffe000 (32-bit, non-prefetchable) =
[size=3D4K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0f.5 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode =
companion] EHC (rev 02) (prog-if 20 [EHCI])
        Subsystem: Advanced Micro Devices [AMD] CS5536 [Geode companion] =
EHC
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium =
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin D routed to IRQ 12
        Region 0: Memory at efffd000 (32-bit, non-prefetchable) =
[size=3D4K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

SCSI information (from /proc/scsi/scsi)
# cat /proc/scsi/scsi=20
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: IEI Technology C Rev: 0811
  Type:   Direct-Access                    ANSI  SCSI revision: 05

Other information that might be relevant to the problem:
* Previous version of the kernel i used (2.6.29.1) was and still is OK =
(without this issue).
* I'm using ppp version 2.4.5
* My kernel is vanilla version compiled for i486
* So far I'm not able to write script to reproduce that for 100% - but =
just enabling and disabling ppp connection will do the work

Thank you,
Ales Teska


--Apple-Mail-3--691038633
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIF0jCCBc4w
ggO2oAMCAQICAwgUfjANBgkqhkiG9w0BAQUFADB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQL
ExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3Jp
dHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xMDAxMjAwMTU0NDRaFw0x
MDA3MTkwMTU0NDRaMIGgMRgwFgYDVQQDEw9DQWNlcnQgV29UIFVzZXIxHTAbBgkqhkiG9w0BCQEW
DnRlc2thQGN5YmVyLmN6MSMwIQYJKoZIhvcNAQkBFhRhbGVzLnRlc2thQGdtYWlsLmNvbTEiMCAG
CSqGSIb3DQEJARYTYWxlcy50ZXNrYUBjeWJlci5jejEcMBoGCSqGSIb3DQEJARYNYWxleEBjeWJl
ci5jejCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANDeFSDQiduIqebNe6WvB/J9LOV3
jZSrU/f0Vod183Ak6RY3JudJiCft9tbIn/qmeh9n3jswspjZ8JGT939xEc819w5nvojch3kz7fIZ
jVzJbj8VVaL0dz6QpPEHu1d/0U8i+rBYs1DFvFasulLKjW75i/S7IhxjimX9r64Qx/Q1kYwMVZ8Y
6SFsZT1h7EZ+/ndkUUbfF7NQxwtB+xcKwNYSyO3bwgwZnNCu68NNiJQRL6S946EoNVSKJWd0e/ZY
44BhIjSlTxcx1/qgwnTT6dh2IJAFGbw91WAW8iPa262SyJ44GoljLz0IV17+ryFPs/NKK380p++G
RkkWROj56y0CAwEAAaOCATUwggExMAwGA1UdEwEB/wQCMAAwVgYJYIZIAYb4QgENBEkWR1RvIGdl
dCB5b3VyIG93biBjZXJ0aWZpY2F0ZSBmb3IgRlJFRSBoZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5D
QWNlcnQub3JnMEAGA1UdJQQ5MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYB
BAGCNwoDAwYJYIZIAYb4QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29j
c3AuY2FjZXJ0Lm9yZzBTBgNVHREETDBKgQ50ZXNrYUBjeWJlci5jeoEUYWxlcy50ZXNrYUBnbWFp
bC5jb22BE2FsZXMudGVza2FAY3liZXIuY3qBDWFsZXhAY3liZXIuY3owDQYJKoZIhvcNAQEFBQAD
ggIBAJ1/tqFKObMtLCLj55BlXh5kP7I2RBUNuQBpdnb/f8655yEP+kGww/QwF1DUs7Q/q/Z7U13D
jTooB+GrpI8nZfvtI4EnrpQPWO1tclRwQYcloPoq7lbWKv1vb7Fufhq3RXabrYhmPOwsTJ6j4K9b
M8JfW0DPW0S9CSFgCR8y1C57J4+t6P2heoTnuIrCP0Y1I1fkX5Egce/eRjKsW2EY7HuxRs3Rn2Dj
2QKPft1tpf8JdgD8K6PMzatyAWOpGdU0RuS3+hsBunVz/6UXlBNpqk2brrVLnYHEAovDya/rPdqq
L9MShHNBoNOykivihCVUIM0GPtNYHbTfQEc2mWLayWtJGdBl0h9jFocnkN26JrdZgZvz2+LOQdjN
KnwvhdIZwkujqlnn5S6mbKLOlQKT6wgJzA0FIxYXgLU32lygfL017ID2V6uju8+y6H0svEeh4bQ1
+7seeoTlbv8r314ZHBhZfS0voVeAX8CIM1rQjmGeC9dh7X9ihSotAKR0HmZnVtqOtZVXToMeNrFB
HlbZhf0G3UiNKji5wbr7gYghB1dwps8b3m6KTQcPV3hO2BvmHpYZFdie5TeMIMxn23ID8n1ZlSos
LKquRSFJSsHAarDpCxHt/c2By0k4vwwQCWlOwdGQCzBmS7CPj+BiN+6qChYrxFu8i1xZUuQ17/8f
j86/MYIDMzCCAy8CAQEwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3
dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZI
hvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAwgUfjAJBgUrDgMCGgUAoIIBhzAYBgkqhkiG9w0B
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMDA2MDkyMDQ2MjhaMCMGCSqGSIb3DQEJ
BDEWBBSoL7MVdw7NqbOKJth4dn5RnYtS0zCBkQYJKwYBBAGCNxAEMYGDMIGAMHkxEDAOBgNVBAoT
B1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2Vy
dCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMI
FH4wgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0
dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMIFH4wDQYJKoZIhvcNAQEBBQAEggEA
uPCJ8IeUw3ff5wn8/gFGreO1QT0nx4WRQqIrOsSVAsjs7Qw2vpJmm5j/Vljb4z9jz9CQ+5W7RB4j
tzVhShfxakVJ7rCd1P7isU6qp41aoeODDyRGre6JfUt0euHyP3/s9DNL4mSxJVoqlX1Lo0Vti5He
+qvqrFyx/Ik8vmYMTTPCAh4H3gUt+9xelT0otpym7RD2pSLNiuH6syA13DDc31zlcReGR3zdYlP4
995rV/zh+41tqAvMkvu+IHfMufwuR8MSMbn5o1JFVgVxmchJAHW9e0Di+f7RlcoZB7uY1wz6KF9a
E6uGwc/FJ3FwlLdViLfPB4uXhdNdlQyFLyoqZQAAAAAAAA==

--Apple-Mail-3--691038633--
