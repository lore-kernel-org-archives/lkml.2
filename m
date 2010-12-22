Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab0LVAW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:22:57 -0500
Received: from virgo.iok.hu ([212.40.97.103]:42590 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab0LVAWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:22:55 -0500
Date: Wed, 22 Dec 2010 01:22:48 +0100
From: Miklos Vajna <vmiklos@frugalware.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: shenghui <crosslonelyover@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, Greg KH <greg@kroah.com>,
        systemd-devel@lists.freedesktop.org
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in
 kernel/sched_fair.c
Message-ID: <20101222002248.GP10557@genesis.frugalware.org>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
 <1277808215.1868.5.camel@laptop>
 <20101219020313.GJ31750@genesis.frugalware.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fd5uyaI9j6xoeUBo"
Content-Disposition: inline
In-Reply-To: <20101219020313.GJ31750@genesis.frugalware.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fd5uyaI9j6xoeUBo
Content-Type: multipart/mixed; boundary="df+09Je9rNq3P+GE"
Content-Disposition: inline


--df+09Je9rNq3P+GE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 19, 2010 at 03:03:13AM +0100, Miklos Vajna <vmiklos@frugalware.=
org> wrote:
> Here is a panic I got today:
>=20
> http://frugalware.org/~vmiklos/pics/bug/2.6.37-rc6.png
>=20
> More details:
>=20
> I get this sometimes on boot or shutdown when testing systemd. I did not
> get it with sysvinit, so I guess it may be related to systemd's heavy
> cgroups usage, but I'm not sure. Sadly it isn't 100% reproducible but I
> usually hit it at least once a day.
>=20
> The config is here:
> http://frugalware.org/~vmiklos/logs/2.6.37-rc6.config (I just did a
> yes "" | make config to update it to 2.6.37-rc6.)
>=20
> I got something similar with 2.6.36.1 as well:
>=20
> http://frugalware.org/~vmiklos/pics/bug/2.6.36.1.png
>=20
> Ah, and this is on i686 in VMware - though given that I never had this
> problem with systemd, I guess it won't be an emulator bug. :)
>=20
> I'm not familiar with the sched code, is it possible that this is
> related?

A few more info:

- I reproduced the issue on my Lenovo S12 netbook as well, so it's not a
  virtual machine-related bug. Here is a poor shot:
  http://frugalware.org/~vmiklos/pics/bug/p1040730.jpg
- I'm also attaching the full dmesg in the VM that is finally a text
  using serial console.
- On "how to reproduce": sometimes I just get this during boot. If it
  does not occur, then it does when using "systemctl emergency".

Please let me know if you need more info.

Thanks,

Miklos

--df+09Je9rNq3P+GE
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="dmesg.txt"
Content-Transfer-Encoding: quoted-printable

Initializing cgroup subsys cpuset=0D
Initializing cgroup subsys cpu=0D
Linux version 2.6.36-fw3 (fst@i686.frugalware.org) (gcc version 4.5.1 (Frug=
alware Linux) ) #1 SMP PREEMPT Wed Dec 8 13:27:40 CET 2010=0D
BIOS-provided physical RAM map:=0D
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)=0D
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)=0D
 BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)=0D
 BIOS-e820: 00000000000dc000 - 00000000000e4000 (reserved)=0D
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)=0D
 BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)=0D
 BIOS-e820: 000000001fef0000 - 000000001feff000 (ACPI data)=0D
 BIOS-e820: 000000001feff000 - 000000001ff00000 (ACPI NVS)=0D
 BIOS-e820: 000000001ff00000 - 0000000020000000 (usable)=0D
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)=0D
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)=0D
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)=0D
 BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)=0D
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!=
=0D
DMI present.=0D
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.=0D
Hypervisor detected: VMware=0D
last_pfn =3D 0x20000 max_arch_pfn =3D 0x100000=0D
x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106=0D
mtrr: your BIOS has configured an incorrect mask, fixing it.=0D
Scanning 0 areas for low memory corruption=0D
modified physical RAM map:=0D
 modified: 0000000000000000 - 0000000000010000 (reserved)=0D
 modified: 0000000000010000 - 000000000009f800 (usable)=0D
 modified: 000000000009f800 - 00000000000a0000 (reserved)=0D
 modified: 00000000000ca000 - 00000000000cc000 (reserved)=0D
 modified: 00000000000dc000 - 00000000000e4000 (reserved)=0D
 modified: 00000000000e8000 - 0000000000100000 (reserved)=0D
 modified: 0000000000100000 - 000000001fef0000 (usable)=0D
 modified: 000000001fef0000 - 000000001feff000 (ACPI data)=0D
 modified: 000000001feff000 - 000000001ff00000 (ACPI NVS)=0D
 modified: 000000001ff00000 - 0000000020000000 (usable)=0D
 modified: 00000000e0000000 - 00000000f0000000 (reserved)=0D
 modified: 00000000fec00000 - 00000000fec10000 (reserved)=0D
 modified: 00000000fee00000 - 00000000fee01000 (reserved)=0D
 modified: 00000000fffe0000 - 0000000100000000 (reserved)=0D
found SMP MP-table at [c00f69b0] f69b0=0D
init_memory_mapping: 0000000000000000-0000000020000000=0D
ACPI: RSDP 000f6940 00024 (v02 PTLTD )=0D
ACPI: XSDT 1fef0804 0004C (v01 INTEL  440BX    06040000 VMW  01324272)=0D
ACPI: FACP 1fefee98 000F4 (v04 INTEL  440BX    06040000 PTL  000F4240)=0D
ACPI: DSDT 1fef09bc 0E4DC (v01 PTLTD  Custom   06040000 MSFT 03000001)=0D
ACPI: FACS 1fefffc0 00040=0D
ACPI: BOOT 1fef0994 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)=0D
ACPI: APIC 1fef0944 00050 (v01 PTLTD  ? APIC   06040000  LTP 00000000)=0D
ACPI: MCFG 1fef0908 0003C (v01 PTLTD  $PCITBL$ 06040000  LTP 00000001)=0D
ACPI: SRAT 1fef0888 00080 (v02 VMWARE MEMPLUG  06040000 VMW  00000001)=0D
0MB HIGHMEM available.=0D
512MB LOWMEM available.=0D
  mapped low ram: 0 - 20000000=0D
  low ram: 0 - 20000000=0D
Zone PFN ranges:=0D
  DMA      0x00000010 -> 0x00001000=0D
  Normal   0x00001000 -> 0x00020000=0D
  HighMem  empty=0D
Movable zone start PFN for each node=0D
early_node_map[3] active PFN ranges=0D
    0: 0x00000010 -> 0x0000009f=0D
    0: 0x00000100 -> 0x0001fef0=0D
    0: 0x0001ff00 -> 0x00020000=0D
Using APIC driver default=0D
ACPI: PM-Timer IO Port: 0x1008=0D
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)=0D
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])=0D
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])=0D
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)=0D
Using ACPI (MADT) for SMP configuration information=0D
SMP: Allowing 1 CPUs, 0 hotplug CPUs=0D
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000=0D
PM: Registered nosave memory: 00000000000a0000 - 00000000000ca000=0D
PM: Registered nosave memory: 00000000000ca000 - 00000000000cc000=0D
PM: Registered nosave memory: 00000000000cc000 - 00000000000dc000=0D
PM: Registered nosave memory: 00000000000dc000 - 00000000000e4000=0D
PM: Registered nosave memory: 00000000000e4000 - 00000000000e8000=0D
PM: Registered nosave memory: 00000000000e8000 - 0000000000100000=0D
PM: Registered nosave memory: 000000001fef0000 - 000000001feff000=0D
PM: Registered nosave memory: 000000001feff000 - 000000001ff00000=0D
Allocating PCI resources starting at 20000000 (gap: 20000000:c0000000)=0D
Booting paravirtualized kernel on bare hardware=0D
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1=0D
PERCPU: Embedded 14 pages/cpu @c2000000 s33296 r0 d24048 u4194304=0D
pcpu-alloc: s33296 r0 d24048 u4194304 alloc=3D1*4194304=0D
pcpu-alloc: [0] 0 =0D
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129919=
=0D
Kernel command line: root=3D/dev/sda1 ro console=3DttyS1 console=3Dtty0 ini=
t=3D/bin/systemd=0D
PID hash table entries: 2048 (order: 1, 8192 bytes)=0D
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)=0D
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)=0D
Enabling fast FPU save and restore... done.=0D
Enabling unmasked SIMD FPU exception support... done.=0D
Initializing CPU#0=0D
allocated 2621120 bytes of page_cgroup=0D
please try 'cgroup_disable=3Dmemory' option if you don't want memory cgroup=
s=0D
Subtract (47 early reservations)=0D
  #1 [0000001000 - 0000002000]   EX TRAMPOLINE=0D
  #2 [0001000000 - 000183e7c4]   TEXT DATA BSS=0D
  #3 [000183f000 - 00018461c0]             BRK=0D
  #4 [00000f69c0 - 0000100000]   BIOS reserved=0D
  #5 [00000f69b0 - 00000f69c0]    MP-table mpf=0D
  #6 [000009f800 - 000009fd70]   BIOS reserved=0D
  #7 [000009fe78 - 00000f69b0]   BIOS reserved=0D
  #8 [000009fd70 - 000009fe78]    MP-table mpc=0D
  #9 [0000010000 - 0000011000]      TRAMPOLINE=0D
  #10 [0000011000 - 0000015000]     ACPI WAKEUP=0D
  #11 [0001847000 - 0001848000]         BOOTMEM=0D
  #12 [0001848000 - 0001c48000]         BOOTMEM=0D
  #13 [000183e7d0 - 000183e7d4]         BOOTMEM=0D
  #14 [000183e7e0 - 000183e8a0]         BOOTMEM=0D
  #15 [000183e8a0 - 000183e8d0]         BOOTMEM=0D
  #16 [0001c48000 - 0001c49800]         BOOTMEM=0D
  #17 [000183e8d0 - 000183e8f7]         BOOTMEM=0D
  #18 [000183e900 - 000183ea88]         BOOTMEM=0D
  #19 [000183ea90 - 000183ead0]         BOOTMEM=0D
  #20 [000183ead0 - 000183eb10]         BOOTMEM=0D
  #21 [000183eb10 - 000183eb50]         BOOTMEM=0D
  #22 [000183eb50 - 000183eb90]         BOOTMEM=0D
  #23 [000183eb90 - 000183ebd0]         BOOTMEM=0D
  #24 [000183ebd0 - 000183ec10]         BOOTMEM=0D
  #25 [000183ec10 - 000183ec50]         BOOTMEM=0D
  #26 [000183ec50 - 000183ec90]         BOOTMEM=0D
  #27 [000183ec90 - 000183ecd0]         BOOTMEM=0D
  #28 [000183ecd0 - 000183ed10]         BOOTMEM=0D
  #29 [000183ed10 - 000183ed50]         BOOTMEM=0D
  #30 [000183ed50 - 000183ed90]         BOOTMEM=0D
  #31 [000183ed90 - 000183edd0]         BOOTMEM=0D
  #32 [000183edd0 - 000183ede0]         BOOTMEM=0D
  #33 [000183ede0 - 000183edf0]         BOOTMEM=0D
  #34 [000183edf0 - 000183ee2f]         BOOTMEM=0D
  #35 [000183ee30 - 000183ee6f]         BOOTMEM=0D
  #36 [0002000000 - 000200e000]         BOOTMEM=0D
  #37 [000183ee70 - 000183ee74]         BOOTMEM=0D
  #38 [000183ee80 - 000183ee84]         BOOTMEM=0D
  #39 [000183ee90 - 000183ee94]         BOOTMEM=0D
  #40 [000183eea0 - 000183eea4]         BOOTMEM=0D
  #41 [000183eeb0 - 000183ef60]         BOOTMEM=0D
  #42 [00018461c0 - 0001846268]         BOOTMEM=0D
  #43 [0001c49800 - 0001c4b800]         BOOTMEM=0D
  #44 [0001c4b800 - 0001c8b800]         BOOTMEM=0D
  #45 [0001c8b800 - 0001cab800]         BOOTMEM=0D
  #46 [0001cac000 - 0001f2bec0]         BOOTMEM=0D
Initializing HighMem for node 0 (00000000:00000000)=0D
Memory: 508160k/524288k available (5423k kernel code, 15612k reserved, 1960=
k data, 504k init, 0k highmem)=0D
virtual kernel memory layout:=0D
    fixmap  : 0xfff17000 - 0xfffff000   ( 928 kB)=0D
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)=0D
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)=0D
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)=0D
      .init : 0xc1736000 - 0xc17b4000   ( 504 kB)=0D
      .data : 0xc154bd73 - 0xc1735dcc   (1960 kB)=0D
      .text : 0xc1000000 - 0xc154bd73   (5423 kB)=0D
Checking if this processor honours the WP bit even in supervisor mode...Ok.=
=0D
SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1=0D
Hierarchical RCU implementation.=0D
	RCU-based detection of stalled CPUs is disabled.=0D
	Verbose stalled-CPUs detection is disabled.=0D
NR_IRQS:2304 nr_irqs:256=0D
Extended CMOS year: 2000=0D
Console: colour VGA+ 80x25=0D
console [tty0] enabled=0D
console [ttyS1] enabled=0D
TSC freq read from hypervisor : 1548.584 MHz=0D
Detected 1548.584 MHz processor.=0D
Calibrating delay loop (skipped) preset value.. 3097.16 BogoMIPS (lpj=3D154=
8584)=0D
pid_max: default: 32768 minimum: 301=0D
Security Framework initialized=0D
AppArmor: AppArmor disabled by boot time parameter=0D
Mount-cache hash table entries: 512=0D
Initializing cgroup subsys ns=0D
Initializing cgroup subsys cpuacct=0D
Initializing cgroup subsys memory=0D
Initializing cgroup subsys devices=0D
Initializing cgroup subsys freezer=0D
mce: CPU supports 0 MCE banks=0D
Performance Events: =0D
SMP alternatives: switching to UP code=0D
Freeing SMP alternatives: 24k freed=0D
ACPI: Core revision 20100702=0D
Enabling APIC mode:  Flat.  Using 1 I/O APICs=0D
=2E.TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1=0D
CPU0: Centaur VIA Nano processor U2250 (1.6GHz Capable) stepping 03=0D
Brought up 1 CPUs=0D
Total of 1 processors activated (3097.16 BogoMIPS).=0D
devtmpfs: initialized=0D
xor: automatically using best checksumming function: pIII_sse=0D
   pIII_sse  :  2108.000 MB/sec=0D
xor: using function: pIII_sse (2108.000 MB/sec)=0D
regulator: core version 0.5=0D
NET: Registered protocol family 16=0D
EISA bus registered=0D
ACPI: bus type pci registered=0D
PCI: Using configuration type 1 for base access=0D
bio: create slab <bio-0> at 0=0D
raid6: int32x1    347 MB/s=0D
raid6: int32x2    222 MB/s=0D
raid6: int32x4    113 MB/s=0D
raid6: int32x8     82 MB/s=0D
raid6: mmxx1      449 MB/s=0D
raid6: mmxx2      417 MB/s=0D
raid6: sse1x1     449 MB/s=0D
raid6: sse1x2     429 MB/s=0D
raid6: sse2x1     792 MB/s=0D
raid6: sse2x2     808 MB/s=0D
raid6: using algorithm sse2x2 (808 MB/s)=0D
ACPI: BIOS _OSI(Linux) query ignored=0D
ACPI: Interpreter enabled=0D
ACPI: (supports S0 S1 S4 S5)=0D
ACPI: Using IOAPIC for interrupt routing=0D
ACPI: No dock devices found.=0D
PCI: Using host bridge windows from ACPI; if necessary, use "pci=3Dnocrs" a=
nd report a bug=0D
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])=0D
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]=0D
pci_root PNP0A03:00: host bridge window [mem 0x000cc000-0x000cffff]=0D
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000d3fff]=0D
pci_root PNP0A03:00: host bridge window [mem 0x000d4000-0x000d7fff]=0D
pci_root PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff]=0D
pci_root PNP0A03:00: host bridge window [mem 0x000e4000-0x000e7fff]=0D
pci_root PNP0A03:00: host bridge window [mem 0x20000000-0xfebfffff]=0D
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]=0D
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xfeff]=0D
pci 0000:00:07.3: quirk: [io  0x1000-0x103f] claimed by PIIX4 ACPI=0D
pci 0000:00:07.3: quirk: [io  0x1040-0x104f] claimed by PIIX4 SMB=0D
pci 0000:00:01.0: PCI bridge to [bus 01-01]=0D
pci 0000:00:11.0: PCI bridge to [bus 02-02] (subtractive decode)=0D
pci 0000:00:15.0: PCI bridge to [bus 03-03]=0D
pci 0000:00:15.1: PCI bridge to [bus 04-04]=0D
pci 0000:00:15.2: PCI bridge to [bus 05-05]=0D
pci 0000:00:15.3: PCI bridge to [bus 06-06]=0D
pci 0000:00:15.4: PCI bridge to [bus 07-07]=0D
pci 0000:00:15.5: PCI bridge to [bus 08-08]=0D
pci 0000:00:15.6: PCI bridge to [bus 09-09]=0D
pci 0000:00:15.7: PCI bridge to [bus 0a-0a]=0D
pci 0000:00:16.0: PCI bridge to [bus 0b-0b]=0D
pci 0000:00:16.1: PCI bridge to [bus 0c-0c]=0D
pci 0000:00:16.2: PCI bridge to [bus 0d-0d]=0D
pci 0000:00:16.3: PCI bridge to [bus 0e-0e]=0D
pci 0000:00:16.4: PCI bridge to [bus 0f-0f]=0D
pci 0000:00:16.5: PCI bridge to [bus 10-10]=0D
pci 0000:00:16.6: PCI bridge to [bus 11-11]=0D
pci 0000:00:16.7: PCI bridge to [bus 12-12]=0D
pci 0000:00:17.0: PCI bridge to [bus 13-13]=0D
pci 0000:00:17.1: PCI bridge to [bus 14-14]=0D
pci 0000:00:17.2: PCI bridge to [bus 15-15]=0D
pci 0000:00:17.3: PCI bridge to [bus 16-16]=0D
pci 0000:00:17.4: PCI bridge to [bus 17-17]=0D
pci 0000:00:17.5: PCI bridge to [bus 18-18]=0D
pci 0000:00:17.6: PCI bridge to [bus 19-19]=0D
pci 0000:00:17.7: PCI bridge to [bus 1a-1a]=0D
pci 0000:00:18.0: PCI bridge to [bus 1b-1b]=0D
pci 0000:00:18.1: PCI bridge to [bus 1c-1c]=0D
pci 0000:00:18.2: PCI bridge to [bus 1d-1d]=0D
pci 0000:00:18.3: PCI bridge to [bus 1e-1e]=0D
pci 0000:00:18.4: PCI bridge to [bus 1f-1f]=0D
pci 0000:00:18.5: PCI bridge to [bus 20-20]=0D
pci 0000:00:18.6: PCI bridge to [bus 21-21]=0D
pci 0000:00:18.7: PCI bridge to [bus 22-22]=0D
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 14 15)=0D
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)=0D
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 14 15)=0D
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 14 15)=0D
vgaarb: device added: PCI:0000:00:0f.0,decodes=3Dio+mem,owns=3Dio+mem,locks=
=3Dnone=0D
vgaarb: loaded=0D
SCSI subsystem initialized=0D
usbcore: registered new interface driver usbfs=0D
usbcore: registered new interface driver hub=0D
usbcore: registered new device driver usb=0D
PCI: Using ACPI for IRQ routing=0D
pci 0000:00:18.2: no compatible bridge window for [io  0xf000-0xffff]=0D
NetLabel: Initializing=0D
NetLabel:  domain hash size =3D 128=0D
NetLabel:  protocols =3D UNLABELED CIPSOv4=0D
NetLabel:  unlabeled traffic allowed by default=0D
Switching to clocksource tsc=0D
pnp: PnP ACPI init=0D
ACPI: bus type pnp registered=0D
pnp: PnP ACPI: found 13 devices=0D
ACPI: ACPI bus type pnp unregistered=0D
PnPBIOS: Disabled by ACPI PNP=0D
system 00:01: [io  0x1000-0x103f] has been reserved=0D
system 00:01: [io  0x1040-0x104f] has been reserved=0D
system 00:01: [io  0x0cf0-0x0cf1] has been reserved=0D
system 00:0c: [io  0x1060-0x107f] has been reserved=0D
system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved=0D
system 00:0c: [mem 0xdbe00000-0xdbffffff] has been reserved=0D
pci 0000:00:0f.0: BAR 6: assigned [mem 0x20000000-0x20007fff pref]=0D
pci 0000:00:10.0: BAR 6: assigned [mem 0x20008000-0x2000bfff pref]=0D
pci 0000:00:15.3: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:15.4: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:15.5: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:15.6: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:15.7: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:16.3: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:16.4: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:16.5: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:16.6: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:16.7: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:17.3: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:17.4: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:17.5: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:17.6: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:17.7: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:18.2: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:18.3: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:18.4: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:18.5: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:18.6: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:18.7: BAR 13: can't assign io (size 0x1000)=0D
pci 0000:00:01.0: PCI bridge to [bus 01-01]=0D
pci 0000:00:01.0:   bridge window [io  disabled]=0D
pci 0000:00:01.0:   bridge window [mem disabled]=0D
pci 0000:00:01.0:   bridge window [mem pref disabled]=0D
pci 0000:02:01.0: BAR 6: assigned [mem 0xdc400000-0xdc40ffff pref]=0D
pci 0000:00:11.0: PCI bridge to [bus 02-02]=0D
pci 0000:00:11.0:   bridge window [io  0x2000-0x3fff]=0D
pci 0000:00:11.0:   bridge window [mem 0xd8900000-0xd9cfffff]=0D
pci 0000:00:11.0:   bridge window [mem 0xdc400000-0xdc9fffff 64bit pref]=0D
pci 0000:00:15.0: PCI bridge to [bus 03-03]=0D
pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]=0D
pci 0000:00:15.0:   bridge window [mem 0xd9d00000-0xd9dfffff]=0D
pci 0000:00:15.0:   bridge window [mem 0xdca00000-0xdcafffff 64bit pref]=0D
pci 0000:00:15.1: PCI bridge to [bus 04-04]=0D
pci 0000:00:15.1:   bridge window [io  0x8000-0x8fff]=0D
pci 0000:00:15.1:   bridge window [mem 0xda100000-0xda1fffff]=0D
pci 0000:00:15.1:   bridge window [mem 0xdce00000-0xdcefffff 64bit pref]=0D
pci 0000:00:15.2: PCI bridge to [bus 05-05]=0D
pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]=0D
pci 0000:00:15.2:   bridge window [mem 0xda500000-0xda5fffff]=0D
pci 0000:00:15.2:   bridge window [mem 0xdd200000-0xdd2fffff 64bit pref]=0D
pci 0000:00:15.3: PCI bridge to [bus 06-06]=0D
pci 0000:00:15.3:   bridge window [io  disabled]=0D
pci 0000:00:15.3:   bridge window [mem 0xda900000-0xda9fffff]=0D
pci 0000:00:15.3:   bridge window [mem 0xdd600000-0xdd6fffff 64bit pref]=0D
pci 0000:00:15.4: PCI bridge to [bus 07-07]=0D
pci 0000:00:15.4:   bridge window [io  disabled]=0D
pci 0000:00:15.4:   bridge window [mem 0xdad00000-0xdadfffff]=0D
pci 0000:00:15.4:   bridge window [mem 0xdda00000-0xddafffff 64bit pref]=0D
pci 0000:00:15.5: PCI bridge to [bus 08-08]=0D
pci 0000:00:15.5:   bridge window [io  disabled]=0D
pci 0000:00:15.5:   bridge window [mem 0xdb100000-0xdb1fffff]=0D
pci 0000:00:15.5:   bridge window [mem 0xdde00000-0xddefffff 64bit pref]=0D
pci 0000:00:15.6: PCI bridge to [bus 09-09]=0D
pci 0000:00:15.6:   bridge window [io  disabled]=0D
pci 0000:00:15.6:   bridge window [mem 0xdb500000-0xdb5fffff]=0D
pci 0000:00:15.6:   bridge window [mem 0xde200000-0xde2fffff 64bit pref]=0D
pci 0000:00:15.7: PCI bridge to [bus 0a-0a]=0D
pci 0000:00:15.7:   bridge window [io  disabled]=0D
pci 0000:00:15.7:   bridge window [mem 0xdb900000-0xdb9fffff]=0D
pci 0000:00:15.7:   bridge window [mem 0xde600000-0xde6fffff 64bit pref]=0D
pci 0000:00:16.0: PCI bridge to [bus 0b-0b]=0D
pci 0000:00:16.0:   bridge window [io  0x5000-0x5fff]=0D
pci 0000:00:16.0:   bridge window [mem 0xd9e00000-0xd9efffff]=0D
pci 0000:00:16.0:   bridge window [mem 0xdcb00000-0xdcbfffff 64bit pref]=0D
pci 0000:00:16.1: PCI bridge to [bus 0c-0c]=0D
pci 0000:00:16.1:   bridge window [io  0x9000-0x9fff]=0D
pci 0000:00:16.1:   bridge window [mem 0xda200000-0xda2fffff]=0D
pci 0000:00:16.1:   bridge window [mem 0xdcf00000-0xdcffffff 64bit pref]=0D
pci 0000:00:16.2: PCI bridge to [bus 0d-0d]=0D
pci 0000:00:16.2:   bridge window [io  0xd000-0xdfff]=0D
pci 0000:00:16.2:   bridge window [mem 0xda600000-0xda6fffff]=0D
pci 0000:00:16.2:   bridge window [mem 0xdd300000-0xdd3fffff 64bit pref]=0D
pci 0000:00:16.3: PCI bridge to [bus 0e-0e]=0D
pci 0000:00:16.3:   bridge window [io  disabled]=0D
pci 0000:00:16.3:   bridge window [mem 0xdaa00000-0xdaafffff]=0D
pci 0000:00:16.3:   bridge window [mem 0xdd700000-0xdd7fffff 64bit pref]=0D
pci 0000:00:16.4: PCI bridge to [bus 0f-0f]=0D
pci 0000:00:16.4:   bridge window [io  disabled]=0D
pci 0000:00:16.4:   bridge window [mem 0xdae00000-0xdaefffff]=0D
pci 0000:00:16.4:   bridge window [mem 0xddb00000-0xddbfffff 64bit pref]=0D
pci 0000:00:16.5: PCI bridge to [bus 10-10]=0D
pci 0000:00:16.5:   bridge window [io  disabled]=0D
pci 0000:00:16.5:   bridge window [mem 0xdb200000-0xdb2fffff]=0D
pci 0000:00:16.5:   bridge window [mem 0xddf00000-0xddffffff 64bit pref]=0D
pci 0000:00:16.6: PCI bridge to [bus 11-11]=0D
pci 0000:00:16.6:   bridge window [io  disabled]=0D
pci 0000:00:16.6:   bridge window [mem 0xdb600000-0xdb6fffff]=0D
pci 0000:00:16.6:   bridge window [mem 0xde300000-0xde3fffff 64bit pref]=0D
pci 0000:00:16.7: PCI bridge to [bus 12-12]=0D
pci 0000:00:16.7:   bridge window [io  disabled]=0D
pci 0000:00:16.7:   bridge window [mem 0xdba00000-0xdbafffff]=0D
pci 0000:00:16.7:   bridge window [mem 0xde700000-0xde7fffff 64bit pref]=0D
pci 0000:00:17.0: PCI bridge to [bus 13-13]=0D
pci 0000:00:17.0:   bridge window [io  0x6000-0x6fff]=0D
pci 0000:00:17.0:   bridge window [mem 0xd9f00000-0xd9ffffff]=0D
pci 0000:00:17.0:   bridge window [mem 0xdcc00000-0xdccfffff 64bit pref]=0D
pci 0000:00:17.1: PCI bridge to [bus 14-14]=0D
pci 0000:00:17.1:   bridge window [io  0xa000-0xafff]=0D
pci 0000:00:17.1:   bridge window [mem 0xda300000-0xda3fffff]=0D
pci 0000:00:17.1:   bridge window [mem 0xdd000000-0xdd0fffff 64bit pref]=0D
pci 0000:00:17.2: PCI bridge to [bus 15-15]=0D
pci 0000:00:17.2:   bridge window [io  0xe000-0xefff]=0D
pci 0000:00:17.2:   bridge window [mem 0xda700000-0xda7fffff]=0D
pci 0000:00:17.2:   bridge window [mem 0xdd400000-0xdd4fffff 64bit pref]=0D
pci 0000:00:17.3: PCI bridge to [bus 16-16]=0D
pci 0000:00:17.3:   bridge window [io  disabled]=0D
pci 0000:00:17.3:   bridge window [mem 0xdab00000-0xdabfffff]=0D
pci 0000:00:17.3:   bridge window [mem 0xdd800000-0xdd8fffff 64bit pref]=0D
pci 0000:00:17.4: PCI bridge to [bus 17-17]=0D
pci 0000:00:17.4:   bridge window [io  disabled]=0D
pci 0000:00:17.4:   bridge window [mem 0xdaf00000-0xdaffffff]=0D
pci 0000:00:17.4:   bridge window [mem 0xddc00000-0xddcfffff 64bit pref]=0D
pci 0000:00:17.5: PCI bridge to [bus 18-18]=0D
pci 0000:00:17.5:   bridge window [io  disabled]=0D
pci 0000:00:17.5:   bridge window [mem 0xdb300000-0xdb3fffff]=0D
pci 0000:00:17.5:   bridge window [mem 0xde000000-0xde0fffff 64bit pref]=0D
pci 0000:00:17.6: PCI bridge to [bus 19-19]=0D
pci 0000:00:17.6:   bridge window [io  disabled]=0D
pci 0000:00:17.6:   bridge window [mem 0xdb700000-0xdb7fffff]=0D
pci 0000:00:17.6:   bridge window [mem 0xde400000-0xde4fffff 64bit pref]=0D
pci 0000:00:17.7: PCI bridge to [bus 1a-1a]=0D
pci 0000:00:17.7:   bridge window [io  disabled]=0D
pci 0000:00:17.7:   bridge window [mem 0xdbb00000-0xdbbfffff]=0D
pci 0000:00:17.7:   bridge window [mem 0xde800000-0xde8fffff 64bit pref]=0D
pci 0000:00:18.0: PCI bridge to [bus 1b-1b]=0D
pci 0000:00:18.0:   bridge window [io  0x7000-0x7fff]=0D
pci 0000:00:18.0:   bridge window [mem 0xda000000-0xda0fffff]=0D
pci 0000:00:18.0:   bridge window [mem 0xdcd00000-0xdcdfffff 64bit pref]=0D
pci 0000:00:18.1: PCI bridge to [bus 1c-1c]=0D
pci 0000:00:18.1:   bridge window [io  0xb000-0xbfff]=0D
pci 0000:00:18.1:   bridge window [mem 0xda400000-0xda4fffff]=0D
pci 0000:00:18.1:   bridge window [mem 0xdd100000-0xdd1fffff 64bit pref]=0D
pci 0000:00:18.2: PCI bridge to [bus 1d-1d]=0D
pci 0000:00:18.2:   bridge window [io  disabled]=0D
pci 0000:00:18.2:   bridge window [mem 0xda800000-0xda8fffff]=0D
pci 0000:00:18.2:   bridge window [mem 0xdd500000-0xdd5fffff 64bit pref]=0D
pci 0000:00:18.3: PCI bridge to [bus 1e-1e]=0D
pci 0000:00:18.3:   bridge window [io  disabled]=0D
pci 0000:00:18.3:   bridge window [mem 0xdac00000-0xdacfffff]=0D
pci 0000:00:18.3:   bridge window [mem 0xdd900000-0xdd9fffff 64bit pref]=0D
pci 0000:00:18.4: PCI bridge to [bus 1f-1f]=0D
pci 0000:00:18.4:   bridge window [io  disabled]=0D
pci 0000:00:18.4:   bridge window [mem 0xdb000000-0xdb0fffff]=0D
pci 0000:00:18.4:   bridge window [mem 0xddd00000-0xdddfffff 64bit pref]=0D
pci 0000:00:18.5: PCI bridge to [bus 20-20]=0D
pci 0000:00:18.5:   bridge window [io  disabled]=0D
pci 0000:00:18.5:   bridge window [mem 0xdb400000-0xdb4fffff]=0D
pci 0000:00:18.5:   bridge window [mem 0xde100000-0xde1fffff 64bit pref]=0D
pci 0000:00:18.6: PCI bridge to [bus 21-21]=0D
pci 0000:00:18.6:   bridge window [io  disabled]=0D
pci 0000:00:18.6:   bridge window [mem 0xdb800000-0xdb8fffff]=0D
pci 0000:00:18.6:   bridge window [mem 0xde500000-0xde5fffff 64bit pref]=0D
pci 0000:00:18.7: PCI bridge to [bus 22-22]=0D
pci 0000:00:18.7:   bridge window [io  disabled]=0D
pci 0000:00:18.7:   bridge window [mem 0xdbc00000-0xdbcfffff]=0D
pci 0000:00:18.7:   bridge window [mem 0xde900000-0xde9fffff 64bit pref]=0D
NET: Registered protocol family 2=0D
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)=0D
TCP established hash table entries: 16384 (order: 5, 131072 bytes)=0D
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)=0D
TCP: Hash tables configured (established 16384 bind 16384)=0D
TCP reno registered=0D
UDP hash table entries: 256 (order: 1, 8192 bytes)=0D
UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)=0D
NET: Registered protocol family 1=0D
pci 0000:00:00.0: Limiting direct PCI/PCI transfers=0D
Simple Boot Flag at 0x36 set to 0x1=0D
Scanning for low memory corruption every 60 seconds=0D
audit: initializing netlink socket (disabled)=0D
type=3D2000 audit(1292693630.593:1): initialized=0D
VFS: Disk quotas dquot_6.5.2=0D
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=0D
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers=
, no debug enabled=0D
SGI XFS Quota Management subsystem=0D
msgmni has been set to 992=0D
async_tx: api initialized (async)=0D
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)=0D
io scheduler noop registered=0D
io scheduler deadline registered=0D
io scheduler cfq registered (default)=0D
pcieport 0000:00:15.0: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:15.1: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:15.2: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:15.3: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:15.4: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:15.5: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:15.6: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:15.7: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:16.0: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:16.1: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:16.2: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:16.3: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:16.4: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:16.5: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:16.6: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:16.7: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:17.0: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:17.1: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:17.2: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:17.3: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:17.4: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:17.5: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:17.6: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:17.7: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:18.0: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:18.1: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:18.2: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:18.3: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:18.4: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:18.5: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:18.6: ACPI _OSC control granted for 0x15=0D
pcieport 0000:00:18.7: ACPI _OSC control granted for 0x15=0D
pci_hotplug: PCI Hot Plug PCI Core version: 0.5=0D
isapnp: Scanning for PnP cards...=0D
isapnp: No Plug & Play device found=0D
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled=0D
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0D
=FFserial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A=0D
00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0D
00:0a: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A=0D
Floppy drive(s): fd0 is 1.44M=0D
FDC 0 is a post-1991 82077=0D
brd: module loaded=0D
Compaq SMART2 Driver (v 2.6.0)=0D
HP CISS Driver (v 3.6.26)=0D
Uniform Multi-Platform E-IDE driver=0D
ide-gd driver 1.18=0D
ide-cd driver 5.00=0D
stex: Promise SuperTrak EX Driver version: 4.6.0000.4=0D
scsi0 : ata_piix=0D
scsi1 : ata_piix=0D
ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x10c0 irq 14=0D
ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x10c8 irq 15=0D
Fusion MPT base driver 3.04.17=0D
Copyright (c) 1999-2008 LSI Corporation=0D
Fusion MPT SPI Host driver 3.04.17=0D
mptspi 0000:00:10.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17=0D
mptbase: ioc0: Initiating bringup=0D
ioc0: LSI53C1030 B0: Capabilities=3D{Initiator}=0D
scsi2 : ioc0: LSI53C1030 B0, FwRev=3D01032920h, Ports=3D1, MaxQ=3D128, IRQ=
=3D17=0D
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=0D
ehci_hcd 0000:02:03.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17=0D
ehci_hcd 0000:02:03.0: EHCI Host Controller=0D
ehci_hcd 0000:02:03.0: new USB bus registered, assigned bus number 1=0D
ehci_hcd 0000:02:03.0: irq 17, io mem 0xd8900000=0D
ehci_hcd 0000:02:03.0: USB 2.0 started, EHCI 1.00=0D
scsi 2:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: =
2=0D
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002=0D
scsi target2:0:0: Beginning Domain Validation=0D
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1=0D
usb usb1: Product: EHCI Host Controller=0D
usb usb1: Manufacturer: Linux 2.6.36-fw3 ehci_hcd=0D
usb usb1: SerialNumber: 0000:02:03.0=0D
scsi target2:0:0: Domain Validation skipping write tests=0D
hub 1-0:1.0: USB hub found=0D
scsi target2:0:0: Ending Domain Validation=0D
hub 1-0:1.0: 6 ports detected=0D
scsi target2:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)=0D
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver=0D
uhci_hcd: USB Universal Host Controller Interface driver=0D
uhci_hcd 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18=0D
uhci_hcd 0000:02:00.0: UHCI Host Controller=0D
uhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 2=0D
uhci_hcd 0000:02:00.0: irq 18, io base 0x000020c0=0D
ata2.00: ATAPI: VMware Virtual IDE CDROM Drive, 00000001, max UDMA/33=0D
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0001=0D
ata2.00: configured for UDMA/33=0D
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1=0D
usb usb2: Product: UHCI Host Controller=0D
usb usb2: Manufacturer: Linux 2.6.36-fw3 uhci_hcd=0D
sd 2:0:0:0: [sda] 16777216 512-byte logical blocks: (8.58 GB/8.00 GiB)=0D
usb usb2: SerialNumber: 0000:02:00.0=0D
sd 2:0:0:0: [sda] Write Protect is off=0D
sd 2:0:0:0: [sda] Cache data unavailable=0D
scsi: waiting for bus probes to complete ...=0D
sd 2:0:0:0: [sda] Assuming drive cache: write through=0D
scsi 1:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 1.00 PQ: 0 ANSI: =
5=0D
hub 2-0:1.0: USB hub found=0D
hub 2-0:1.0: 2 ports detected=0D
sd 2:0:0:0: [sda] Cache data unavailable=0D
sd 2:0:0:0: [sda] Assuming drive cache: write through=0D
Initializing USB Mass Storage driver...=0D
sr0: scsi3-mmc drive: 1x/1x xa/form2 cdda tray=0D
cdrom: Uniform CD-ROM driver Revision: 3.20=0D
usbcore: registered new interface driver usb-storage=0D
USB Mass Storage support registered.=0D
usbcore: registered new interface driver ums-alauda=0D
usbcore: registered new interface driver ums-cypress=0D
 sda: sda1=0D
usbcore: registered new interface driver ums-datafab=0D
usbcore: registered new interface driver ums-freecom=0D
usbcore: registered new interface driver ums-isd200=0D
usbcore: registered new interface driver ums-jumpshot=0D
usbcore: registered new interface driver ums-karma=0D
usbcore: registered new interface driver ums-onetouch=0D
usbcore: registered new interface driver ums-sddr09=0D
usbcore: registered new interface driver ums-sddr55=0D
usbcore: registered new interface driver ums-usbat=0D
sd 2:0:0:0: [sda] Cache data unavailable=0D
sd 2:0:0:0: [sda] Assuming drive cache: write through=0D
sd 2:0:0:0: [sda] Attached SCSI disk=0D
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 irq 1,12=0D
serio: i8042 KBD port at 0x60,0x64 irq 1=0D
serio: i8042 AUX port at 0x60,0x64 irq 12=0D
mice: PS/2 mouse device common for all mice=0D
md: linear personality registered for level -1=0D
md: raid0 personality registered for level 0=0D
md: raid1 personality registered for level 1=0D
md: raid10 personality registered for level 10=0D
md: raid6 personality registered for level 6=0D
md: raid5 personality registered for level 5=0D
md: raid4 personality registered for level 4=0D
EISA: Probing bus 0 at eisa.0=0D
EISA: Cannot allocate resource for mainboard=0D
Cannot allocate resource for EISA slot 1=0D
Cannot allocate resource for EISA slot 2=0D
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input=
/input0=0D
Cannot allocate resource for EISA slot 3=0D
Cannot allocate resource for EISA slot 4=0D
Cannot allocate resource for EISA slot 5=0D
Cannot allocate resource for EISA slot 6=0D
Cannot allocate resource for EISA slot 7=0D
Cannot allocate resource for EISA slot 8=0D
EISA: Detected 0 cards.=0D
cpuidle: using governor ladder=0D
cpuidle: using governor menu=0D
usbcore: registered new interface driver hiddev=0D
usbcore: registered new interface driver usbhid=0D
usbhid: USB HID core driver=0D
TCP bic registered=0D
Initializing XFRM netlink socket=0D
NET: Registered protocol family 17=0D
Registering the dns_resolver key type=0D
Using IPI No-Shortcut mode=0D
registered taskstats version 1=0D
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)=0D
md: Waiting for all devices to be available before autodetect=0D
md: If you don't use raid, use raid=3Dnoautodetect=0D
md: Autodetecting RAID arrays.=0D
md: Scanned 0 and added 0 devices.=0D
md: autorun ...=0D
md: ... autorun DONE.=0D
EXT3-fs (sda1): error: couldn't mount because of unsupported optional featu=
res (240)=0D
EXT2-fs (sda1): error: couldn't mount because of unsupported optional featu=
res (240)=0D
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)=0D
VFS: Mounted root (ext4 filesystem) readonly on device 8:1.=0D
devtmpfs: mounted=0D
Freeing unused kernel memory: 504k freed=0D
systemd[1]: systemd 15 running in system mode. (+PAM -LIBWRAP -AUDIT -SELIN=
UX +SYSVINIT -LIBCRYPTSETUP; frugalware)=0D
NET: Registered protocol family 10=0D
lo: Disabled Privacy Extensions=0D
systemd[1]: Set hostname to <frugalware>.=0D
systemd[1]: /etc/mtab is not a symlink or not pointing to /proc/self/mounts=
=2E This is not supported anymore. Please make sure to replace this file by=
 a symlink to avoid incorrect or misleading mount(8) output.=0D
BUG: unable to handle kernel NULL pointer dereference at 0000001c=0D
IP: [<c1030ccf>] pick_next_task_fair+0x6f/0x120=0D
*pde =3D 00000000 =0D
Oops: 0000 [#1] PREEMPT SMP =0D
last sysfs file: /sys/devices/pci0000:00/0000:00:10.0/host2/target2:0:0/2:0=
:0:0/block/sda/sda1/uevent=0D
Modules linked in: ipv6 autofs4=0D
=0D
Pid: 1386, comm: systemd-sysctl Not tainted 2.6.36-fw3 #1 440BX Desktop Ref=
erence Platform/VMware Virtual Platform=0D
EIP: 0060:[<c1030ccf>] EFLAGS: 00010046 CPU: 0=0D
EIP is at pick_next_task_fair+0x6f/0x120=0D
EAX: 00000000 EBX: dfba8180 ECX: dfba85a8 EDX: 00000000=0D
ESI: 00000000 EDI: 00000000 EBP: c2007bc0 ESP: dfbe3ef0=0D
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068=0D
Process systemd-sysctl (pid: 1386, ti=3Ddfbe2000 task=3Ddfa15920 task.ti=3D=
dfbe2000)=0D
Stack:=0D
 dfa15ac8 c2007bc0 00000000 dfa15920 c154849f df02c7b8 00000046 c10e0d92=0D
<0> 00000046 c15537c0 c17b2bc0 00000000 00000082 c17b2bc0 c17b2bc0 dfa15acc=
=0D
<0> c17b2bc0 dfa15920 c17b2bc0 df0328d0 c128d5f0 00000246 00000012 00000001=
=0D
Call Trace:=0D
 [<c154849f>] ? schedule+0x44f/0x8c0=0D
 [<c10e0d92>] ? kmem_cache_free+0x82/0xd0=0D
 [<c128d5f0>] ? cic_free_func+0x0/0x70=0D
 [<c103f36b>] ? do_exit+0x4fb/0x770=0D
 [<c103f7ee>] ? do_group_exit+0x2e/0x90=0D
 [<c103f861>] ? sys_exit_group+0x11/0x20=0D
 [<c10034fc>] ? sysenter_do_call+0x12/0x28=0D
Code: 0f 8e 86 00 00 00 89 fe 8b 43 38 85 c0 74 15 8b 50 34 8b 40 30 89 f9 =
e8 30 ff ff ff 85 c0 0f 8e 78 00 00 00 89 f0 e8 91 fb ff ff <8b> 7e 1c 85 f=
f 74 16 8d 7e 08 39 7b 20 0f 84 8e 00 00 00 8d 53 =0D
EIP: [<c1030ccf>] pick_next_task_fair+0x6f/0x120 SS:ESP 0068:dfbe3ef0=0D
CR2: 000000000000001c=0D
---[ end trace 971e729af87f404e ]---=0D
Fixing recursive fault but reboot is needed!=0D

--df+09Je9rNq3P+GE--

--fd5uyaI9j6xoeUBo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0RRNgACgkQe81tAgORUJa80ACeKB2ZRkA9xdDtUUWi5IOgEDRn
k/UAn2vEWu+YfIjdj9g0+ghfkXPfxdic
=gkzd
-----END PGP SIGNATURE-----

--fd5uyaI9j6xoeUBo--
