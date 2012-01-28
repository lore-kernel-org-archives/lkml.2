Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2A1U02 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 15:26:28 -0500
Received: from nm10-vm0.bullet.mail.ird.yahoo.com ([77.238.189.90]:27821 "HELO
	nm10-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751916Ab2A1U0Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 15:26:25 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jan 2012 15:26:23 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 361842.57733.bm@omp1025.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=cimwFFrUCmFwuD7BannOzwCDKYrJdIwauBtrMC/RQgkjLmO9ZjTtQaUjm9EefLzpxGCwb4kljiHr1hv8/w15kL2InCw47uhUH3OpIj5qq4wbhbkT2SmA1yBFQc0kW9vnIfiB0d8JjmZvRqM1633bunUcVxE3tpocHB2lMr9bcms=;
X-YMail-OSG: XhPF2r0VM1mM7yI4duKfWrldffA8f8iOuT2387BnQAxsfzB
 OUBV8jFBD_jrzBGF8gRtCjMmpNwm3joCcEi_o4hPtCOSgWqVHVVwdauLImiF
 hrsoU7p7Sumg3Ry0dKZGnEKnKR9KknDp6_mvdNHIZYy75URQThRTQc8GMtHO
 72a.A_b1k0ckixKef_P3NbP3hWxvzGxOjtB9GG1.tkSMHGow3rk1cjE9WjTg
 DgENFCT7p2WZrX15xQhvpWn9hvyr85wGETWGLOJ3VHHvG79TqypM2WHylG1J
 GeDXQnQm_.Ki.MPtQVP4Zoc.jdb3giRjIjWoBEQl5sR5YGjBh9Ya_0pRfcA.
 SpfjiSFmTvNAsOOcbEcfmfXpwJr2OYkTrHJqJ0Ep0JfH_CnsWc_1EIcbdRYh
 s_zIM3tA_0YwmPyYgJ4QMcTcfK54z
X-Mailer: YahooMailWebService/0.8.116.331537
Message-ID: <1327782057.70545.YahooMailNeo@web29605.mail.ird.yahoo.com>
Date: Sat, 28 Jan 2012 20:20:57 +0000 (GMT)
From: m ki <mki2268@yahoo.com>
Reply-To: m ki <mki2268@yahoo.com>
Subject: PROBLEM: slow nfs transfer on crypted partition (dm_crypt/LUKS) with the Kernel 3.x branch
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:    
slow nfs transfer on crypted partition (dm_crypt/LUKS/ext4) with the Kernel 3.x branch

[2.] Full description of the problem/report:
Hello,
I would like to submit a 'limitation' appearing after upgrading my Ubuntu_Server_11.04 (Kernel 2.6.38-13#52) to Ubuntu_Server_11.10 (Kernel 3.0.0-15#26)
With this new Kernel, performances have dropped when accessing a crypted partition

A test using nfs4 to access a crypted partition on the server:
*Svr Kernel 3.0.0-15#26  : NFS (R/W) = 30 MB/s / 33 MB/s   <--------
*Svr Kernel 2.6.38-13#52 : NFS (R/W) = 81 MB/s / 53 MB/s

As you can see, there is a big difference
With Kernel 3.x, the flow is always constant at 30MB; there's clearly a limitation
(The client can be a 2.6 or 3.x Kernel, results are the same)

For comparison, without nfs: doing a transfer with a 2nd HD on the server:
*Svr Kernel 3.0.0-15#26  : cp (from/to) the crypted partiton = 64 MB/s / 57 MB/s
*Svr Kernel 2.6.38-13#52 : cp (from/to) the crypted partiton = 61 MB/s / 60 MB/s
Using dm_crypt without nfs, there's no difference between the 2 Kernels

And using nfs on a non-crypted partition (same HD of the crypted one)
*Svr Kernel 3.0.0-15#26  : NFS (R/W) = 92 MB/s / 77 MB/s
*Svr Kernel 2.6.38-13#52 : NFS (R/W) = 111 MB/s / 74 MB/s
Using nfs without dm_crypt, there's no big difference between the 2 Kernels too 


Apparently, there is a bad interaction between nfs and dm_crypt when running a 3.x Kernel (cache problem?)

The server is a fileserver using default parameters, except for exportfs that use the option async
rsize and wsize are set to 131072b. That seems to be the maximum accepted now; in the past the maximum payload 1048576b was possible
No paquets are lost during nfs transfers. nfsd is running 8 threads.

I don't know how manage the module dm_crypt. (See parameters in [7.7])


I've build another server with a debian Wheezy (Kernel 3.1.0-1) and another one with a Fedora 16 (Kernel 3.2.1-3).
Both obtained the same results.

That's all I can say for the moment.
Feel free to ask more informations / tests.

Please, CC me for replying.  I'm reading the Kernel list using the newsgroup linux.kernel, but I don't think I can reply directly to it

Regards !
Mickael



[3.] Keywords (i.e., modules, networking, kernel):
nfs4, dm_crypt, kernel 3.x

[4.] Kernel version (from /proc/version):
Linux version 3.0.0-15-server (buildd@crested) (gcc version 4.6.1 (Ubuntu/Linaro 4.6.1-9ubuntu3) ) #26-Ubuntu SMP Fri Jan 20 19:07:39 UTC 2012

[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt)
No Oops or bad logs reported


[7.] Environment
CPU AMD Athlon64 3500+ (1core)
1GB RAM
mobo Asus A8N nForce4
eth 1GB nForce4
HD WD 2To Green (sata_nv)

[7.1.] Software (add the output of the ver_linux script here)
Linux  3.0.0-15-server #26-Ubuntu SMP Fri Jan 20 19:07:39 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
Gnu C                  ./ver_linux:
./ver_linux: 20: ld: not found
binutils               
util-linux             2.19.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.41.14
PPP                    2.4.5
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
Sh-utils               8.5
Modules Loaded         dm_crypt speedstep_lib nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc psmouse serio_raw edac_core k8temp edac_mce_amd i2c_nforce2 asus_atk0110 lp parport nouveau ttm drm_kms_helper skge forcedeth drm i2c_algo_bit mxm_wmi wmi video sata_nv pata_amd


[7.2.] Processor information (from /proc/cpuinfo):
processor    : 0
vendor_id    : AuthenticAMD
cpu family    : 15
model        : 47
model name    : AMD Athlon(tm) 64 Processor 3500+
stepping    : 2
cpu MHz        : 1000.000
cache size    : 512 KB
fpu        : yes
fpu_exception    : yes
cpuid level    : 1
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm 3dnowext 3dnow up rep_good nopl pni lahf_lm
bogomips    : 2010.12
TLB size    : 1024 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

[7.3.] Module information (from /proc/modules):
dm_crypt 23199 1 - Live 0xffffffffa0219000
speedstep_lib 13195 0 - Live 0xffffffffa01a1000
nfsd 322392 13 - Live 0xffffffffa02ae000
nfs 354737 0 - Live 0xffffffffa0240000
lockd 86161 2 nfsd,nfs, Live 0xffffffffa0221000
fscache 61593 1 nfs, Live 0xffffffffa0208000
auth_rpcgss 53320 2 nfsd,nfs, Live 0xffffffffa01f9000
nfs_acl 12883 2 nfsd,nfs, Live 0xffffffffa017b000
sunrpc 240955 20 nfsd,nfs,lockd,auth_rpcgss,nfs_acl, Live 0xffffffffa01bd000
psmouse 73882 0 - Live 0xffffffffa01a9000
serio_raw 13166 0 - Live 0xffffffffa00a3000
edac_core 53746 0 - Live 0xffffffffa0192000
k8temp 13057 0 - Live 0xffffffffa0176000
edac_mce_amd 23709 0 - Live 0xffffffffa016f000
i2c_nforce2 13058 0 - Live 0xffffffffa0012000
asus_atk0110 18078 0 - Live 0xffffffffa0028000
lp 17799 0 - Live 0xffffffffa007d000
parport 46562 1 lp, Live 0xffffffffa0185000
nouveau 728677 1 - Live 0xffffffffa00bc000
ttm 76805 1 nouveau, Live 0xffffffffa00a8000
drm_kms_helper 42558 1 nouveau, Live 0xffffffffa0097000
skge 49902 0 - Live 0xffffffffa006f000
forcedeth 67563 0 - Live 0xffffffffa0085000
drm 236290 3 nouveau,ttm,drm_kms_helper, Live 0xffffffffa0034000
i2c_algo_bit 13423 1 nouveau, Live 0xffffffffa002f000
mxm_wmi 12979 1 nouveau, Live 0xffffffffa001d000
wmi 19256 1 mxm_wmi, Live 0xffffffffa0022000
video 19412 1 nouveau, Live 0xffffffffa0017000
sata_nv 32305 4 - Live 0xffffffffa0009000
pata_amd 14121 0 - Live 0xffffffffa0000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
:~$ /proc/ioports
0000-ffff : PCI Bus #00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0073 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:06.0
    0170-0177 : pata_amd
  01f0-01f7 : 0000:00:06.0
    01f0-01f7 : pata_amd
  0290-0297 : pnp 00:02
  0376-0376 : 0000:00:06.0
    0376-0376 : pata_amd
  03f6-03f6 : 0000:00:06.0
    03f6-03f6 : pata_amd
  04d0-04d1 : pnp 00:02
  0800-087f : pnp 00:02
  0960-0967 : 0000:00:08.0
    0960-0967 : sata_nv
  0970-0977 : 0000:00:07.0
    0970-0977 : sata_nv
  09e0-09e7 : 0000:00:08.0
    09e0-09e7 : sata_nv
  09f0-09f7 : 0000:00:07.0
    09f0-09f7 : sata_nv
  0b60-0b63 : 0000:00:08.0
    0b60-0b63 : sata_nv
  0b70-0b73 : 0000:00:07.0
    0b70-0b73 : sata_nv
  0be0-0be3 : 0000:00:08.0
    0be0-0be3 : sata_nv
  0bf0-0bf3 : 0000:00:07.0
    0bf0-0bf3 : sata_nv
  0cf8-0cff : PCI conf1
  4000-407f : pnp 00:01
    4000-4003 : ACPI PM1a_EVT_BLK
    4004-4005 : ACPI PM1a_CNT_BLK
    4008-400b : ACPI PM_TMR
    401c-401c : ACPI PM2_CNT_BLK
    4020-4027 : ACPI GPE0_BLK
  4080-40ff : pnp 00:01
  4400-447f : pnp 00:01
  4480-44ff : pnp 00:01
    44a0-44af : ACPI GPE1_BLK
  4800-487f : pnp 00:01
  4880-48ff : pnp 00:01
  4c00-4c3f : 0000:00:01.1
    4c00-4c3f : nForce2_smbus
  4c40-4c7f : 0000:00:01.1
    4c40-4c7f : nForce2_smbus
  a000-afff : PCI Bus 0000:05
    a000-a0ff : 0000:05:0c.0
      a000-a0ff : skge
  b000-b007 : 0000:00:0a.0
    b000-b007 : forcedeth
  c400-c40f : 0000:00:08.0
    c400-c40f : sata_nv
  d800-d80f : 0000:00:07.0
    d800-d80f : sata_nv
  dc00-dc1f : 0000:00:01.1
  f000-f00f : 0000:00:06.0
    f000-f00f : pata_amd

:~$ /proc/iomem
00000000-0000ffff : reserved
00010000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : PCI Bus #00
000c0000-000c7fff : Video ROM
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-3ffeffff : System RAM
  01000000-016129fb : Kernel code
  016129fc-01cd157f : Kernel data
  01dbc000-01f10fff : Kernel bss
3fff0000-3fff2fff : ACPI Non-volatile Storage
3fff3000-3fffffff : ACPI Tables
40000000-fcffffffff : PCI Bus #00
  40000000-400fffff : PCI Bus 0000:05
    40000000-4001ffff : 0000:05:0c.0
  40100000-401000ff : 0000:00:02.1
    40100000-401000ff : ehci_hcd
  c0000000-c7ffffff : PCI Bus 0000:01
    c0000000-c7ffffff : 0000:01:00.0
  c8000000-cfffffff : PCI Bus 0000:01
    c8000000-cbffffff : 0000:01:00.0
    cc000000-ccffffff : 0000:01:00.0
    cd000000-cd01ffff : 0000:01:00.0
  d0000000-d1ffffff : PCI Bus 0000:05
    d1000000-d1003fff : 0000:05:0c.0
      d1000000-d1003fff : skge
  d2000000-d2000fff : 0000:00:0a.0
    d2000000-d2000fff : forcedeth
  d2001000-d2001fff : 0000:00:08.0
    d2001000-d2001fff : sata_nv
  d2002000-d2002fff : 0000:00:07.0
    d2002000-d2002fff : sata_nv
  d2003000-d2003fff : 0000:00:02.0
    d2003000-d2003fff : ohci_hcd
  e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
    e0000000-efffffff : reserved
      e0000000-efffffff : pnp 00:09
  feb00000-ffffffff : reserved
    feb00000-fec0ffff : PCI Bus #00
      fec00000-fec003ff : IOAPIC 0
    fee00000-feefffff : pnp 00:0a
      fee00000-fee00fff : Local APIC
    fefff000-feffffff : pnp 00:0a
    fff80000-fff80fff : pnp 00:0a
    fff90000-fffbffff : pnp 00:0a
    fffed000-fffeffff : pnp 00:0a
    ffff0000-ffffffff : pnp 00:0a


[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
    Subsystem: ASUSTeK Computer Inc. A8N-E Mainboard
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [44] HyperTransport: Slave or Primary Interface
        Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
        Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
        Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
        Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
        Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
        Revision ID: 1.03
        Link Frequency 0: 1.0GHz
        Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
        Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
        Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
        Link Frequency 1: 200MHz
        Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
        Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
        Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
        Prefetchable memory behind bridge Upper: 00-00
        Bus Number: 00
    Capabilities: [e0] HyperTransport: MSI Mapping Enable+ Fixed-
        Mapping Address Base: 00000000fee00000

00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
    Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard
    Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0

00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
    Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard
    Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin A routed to IRQ 10
    Region 0: I/O ports at dc00 [size=32]
    Region 4: I/O ports at 4c00 [size=64]
    Region 5: I/O ports at 4c40 [size=64]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: nForce2_smbus
    Kernel modules: i2c-nforce2

00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2) (prog-if 01 [Subtractive decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Bus: primary=00, secondary=05, subordinate=05, sec-latency=128
    I/O behind bridge: 0000a000-0000afff
    Memory behind bridge: d0000000-d1ffffff
    Prefetchable memory behind bridge: 40000000-400fffff
    Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-

00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
    Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
    Latency: 0 (250ns min, 5000ns max)
    Interrupt: pin A routed to IRQ 23
    Region 0: Memory at d2000000 (32-bit, non-prefetchable) [size=4K]
    Region 1: I/O ports at b000 [size=8]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
    Kernel driver in use: forcedeth
    Kernel modules: forcedeth

00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [48] MSI: Enable+ Count=1/2 Maskable- 64bit+
        Address: 00000000fee0100c  Data: 4129
    Capabilities: [58] HyperTransport: MSI Mapping Enable- Fixed-
        Mapping Address Base: 00000000fee00000
    Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
            ExtTag- RBE- FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #3, Speed 2.5GT/s, Width x2, ASPM L0s, Latency L0 <512ns, L1 <4us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #8, PowerLimit 25.000W; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
            Control: AttnInd Off, PwrInd On, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=1 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32+ WRR64- WRR128-
        Ctrl:    ArbSelect=WRR32
        Status:    InProgress-
        Port Arbitration Table [1a0] <?>
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
            Status:    NegoPending- InProgress-
        VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable- ID=1 ArbSelect=Fixed TC/VC=00
            Status:    NegoPending- InProgress-
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [48] MSI: Enable+ Count=1/2 Maskable- 64bit+
        Address: 00000000fee0100c  Data: 4141
    Capabilities: [58] HyperTransport: MSI Mapping Enable- Fixed-
        Mapping Address Base: 00000000fee00000
    Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
            ExtTag- RBE- FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #2, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <512ns, L1 <4us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #4, PowerLimit 10.000W; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
            Control: AttnInd Off, PwrInd On, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=1 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32+ WRR64- WRR128-
        Ctrl:    ArbSelect=WRR32
        Status:    InProgress-
        Port Arbitration Table [1a0] <?>
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
            Status:    NegoPending- InProgress-
        VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable- ID=1 ArbSelect=Fixed TC/VC=00
            Status:    NegoPending- InProgress-
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [48] MSI: Enable+ Count=1/2 Maskable- 64bit+
        Address: 00000000fee0100c  Data: 4149
    Capabilities: [58] HyperTransport: MSI Mapping Enable- Fixed-
        Mapping Address Base: 00000000fee00000
    Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
            ExtTag- RBE- FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <512ns, L1 <4us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #2, PowerLimit 10.000W; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
            Control: AttnInd Off, PwrInd On, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=1 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32+ WRR64- WRR128-
        Ctrl:    ArbSelect=WRR32
        Status:    InProgress-
        Port Arbitration Table [1a0] <?>
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
            Status:    NegoPending- InProgress-
        VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable- ID=1 ArbSelect=Fixed TC/VC=00
            Status:    NegoPending- InProgress-
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: c8000000-cfffffff
    Prefetchable memory behind bridge: 00000000c0000000-00000000c7ffffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [48] MSI: Enable+ Count=1/2 Maskable- 64bit+
        Address: 00000000fee0100c  Data: 4151
    Capabilities: [58] HyperTransport: MSI Mapping Enable- Fixed-
        Mapping Address Base: 00000000fee00000
    Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
            ExtTag- RBE- FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr+ UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x16, ASPM L0s, Latency L0 <512ns, L1 <4us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #1, PowerLimit 75.000W; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
            Control: AttnInd Off, PwrInd On, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=1 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32+ WRR64- WRR128-
        Ctrl:    ArbSelect=WRR32
        Status:    InProgress-
        Port Arbitration Table [1a0] <?>
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
            Status:    NegoPending- InProgress-
        VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable- ID=1 ArbSelect=Fixed TC/VC=00
            Status:    NegoPending- InProgress-
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Capabilities: [80] HyperTransport: Host or Secondary Interface
        Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
        Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
        Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
        Revision ID: 1.02
        Link Frequency: 1.0GHz
        Link Error: <Prot- <Ovfl- <EOC- CTLTm-
        Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
        Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Kernel modules: amd64_edac_mod

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Kernel driver in use: k8temp
    Kernel modules: k8temp


[7.6.] SCSI information (from /proc/scsi/scsi)
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD20EARS-00M Rev: 51.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05


[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

:~$ cryptsetup luksDump /dev/sda1
Version:           1
Cipher name:       aes
Cipher mode:       cbc-essiv:sha256
Hash spec:         sha1
Payload offset:    2056
MK bits:           256

:~$ mkfs.ext4 /dev/mapper/crypted -m 0.2

:~$ exportfs -v
/mnt/crypted         192.168.0.1(rw,async,wdelay,no_root_squash,no_subtree_check)

:~$ cat /proc/mount (server)
/dev/mapper/crypted /mnt/crypted ext4 rw,relatime,user_xattr,acl,barrier=1,data=ordered 0 0

:~$ cat /proc/mount (client)
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0
192.168.0.10:/mnt/crypted/ /mnt/crypted nfs4 rw,relatime,vers=4,rsize=131072,wsize=131072,namlen=255,hard,proto=tcp,port=0,timeo=600,retrans=2,sec=sys,clientaddr=192.168.0.1,minorversion=0,local_lock=none,addr=192.168.0.10 0 0

:~$ nfsiostat (after reading and writing a 2GB file)
192.168.0.10:/mnt/crypted/ mounted on /mnt/crypted:
   op/s        rpc bklog
1432.16        0.88
read:             ops/s           kB/s          kB/op        retrans        avg RTT (ms)    avg exe (ms)
         32.037     4108.500     128.242        0 (0.0%)      66.974      94.895
write:            ops/s           kB/s          kB/op        retrans        avg RTT (ms)    avg exe (ms)
         47.713     4116.645      86.280        0 (0.0%)      27.833     1814.244

192.168.0.10:/mnt/sda2/ mounted on /mnt/sda2:  (sda2 -> ext4 not crypted partition)
   op/s        rpc bklog
9417.74        5.37
read:             ops/s           kB/s          kB/op        retrans        avg RTT (ms)    avg exe (ms)
        199.295     25502.509     127.964        0 (0.0%)      16.920      22.618
write:            ops/s           kB/s          kB/op        retrans        avg RTT (ms)    avg exe (ms)
        329.141     25555.419      77.643        0 (0.0%)       3.888     507.813

:~$ cat /proc/fs/nfsd
export_features:    0x17e3f 0xf
exports:    /mnt/crypted    192.168.0.1(rw,no_root_squash,async,wdelay,no_subtree_check)
max_block_size:    131072
nfsv4gracetime:    90
nfsv4leasetime:        90
nfsv4recoverydir:    /var/lib/nfs/v4recovery
pool_stats:    0 350070842 335513464 11979013 24
pool_threads:    8
portlist:    udp/tcp=2049
supported_krb5_enctypes:    18,17,16,23,3,1,2
threads:    8
versions:    +2 +3 +4 +4.1

:~$ cat /sys/kernel/slab/dm_crypt_io/
aliases : [0]
align : [8]
alloc_calls : []
cache_dma : [0]
cpu_slabs : [1 N0=1]
ctor : []
destroy_by_rcu : [0]
free_calls : []
hwcache_align : [0]
min_partial : [7]
objects : [26 N0=26]
object_size : [152]
objects_partial : [0]
objs_per_slab : [26]
order : [0]
partial : [0]
poison : [0]
reclaim_account : [0]
red_zone : [0]
remote_node_defrag_ratio : [100]
reserved : [0]
sanity_checks : [0]
shrink : []
slabs : [1 N0=1]
slab_size : [152]
store_user : [0]
total_objects : [26 N0=26]
trace : [0]
validate : []
