Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab2CGIRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 03:17:51 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45281 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2CGIRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 03:17:45 -0500
Message-ID: <1331108169.1544.33.camel@ierdnac-hp>
Subject: intel_idle regresion ?
From: Andrei Popa <andrei.popa@i-neo.ro>
Reply-To: andrei.popa@i-neo.ro
To: linux-kernel@vger.kernel.org
Cc: lenb@kernel.org, linux-pm@lists.linux-foundation.org
Date: Wed, 07 Mar 2012 10:16:09 +0200
Organization: INEOSOFT
Content-Type: multipart/signed; micalg="sha512";
	protocol="application/x-pkcs7-signature";
	boundary="=-yf9Tk2a3JDXMYfKNNJXf"
X-Mailer: Evolution 3.2.3
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yf9Tk2a3JDXMYfKNNJXf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,


After upgrading a routing and shaping server (that routes 400mbps
traffic shaped with htb) from linux 2.6.35.11 to 3.0.23 the idle
processor decreased very much.

Both kernels are patched with linux-imq but IMQ is not used.

Here is the graph with shows the idle time modification between the
kernels:
http://94.53.12.114/cpu.png
=46rom 10:00 to 16:00 is running 3.0.23 kernel.
=46rom 16:00 to 18:00 is running 2.6.35 kernel.
=46rom 18:00 to 19:30 is running 3.0.23 kernel.
=46rom 19:30 to 20:00 is running 2.6.35 kernel.
=46rom 21:00 to 21:30 is running 3.0.23 kernel with idle=3Dpoll (here I
realized that the problem is with the kernel puting the CPUs in deeper C
states).
=46rom 21:30 to the next restart is running 3.0.23 kernel with idle=3Dwait,
then idle=3Dhalt and the whole night is running with idle=3Dnomwait.
Then after the last restart is running with intel_idle.max_cstate=3D0.

I belive kernel 3.0.23 is putting the CPUs in sleep state when it
shouldn't. Kernel 2.6.35.11 is working properly.

root@linux:~# uname -a
Linux linux 3.0.23-perf #12 SMP Tue Mar 6 17:22:10 EET 2012 x86_64
Intel(R) Xeon(R) CPU X3430 @ 2.40GHz GenuineIntel GNU/Linux

# cat /proc/cpuinfo=20
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 30
model name      : Intel(R) Xeon(R) CPU           X3430  @ 2.40GHz
stepping        : 5
cpu MHz         : 2400.308
cache size      : 8192 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est
tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 4800.61
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 30
model name      : Intel(R) Xeon(R) CPU           X3430  @ 2.40GHz
stepping        : 5
cpu MHz         : 2400.308
cache size      : 8192 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 4
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est
tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 4799.26
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 30
model name      : Intel(R) Xeon(R) CPU           X3430  @ 2.40GHz
stepping        : 5
cpu MHz         : 2400.308
cache size      : 8192 KB
physical id     : 0
siblings        : 4
core id         : 2
cpu cores       : 4
apicid          : 4
initial apicid  : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est
tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 4799.26
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 30
model name      : Intel(R) Xeon(R) CPU           X3430  @ 2.40GHz
stepping        : 5
cpu MHz         : 2400.308
cache size      : 8192 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 4
apicid          : 6
initial apicid  : 6
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est
tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 4799.26
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

dmesg:
=3Dnone
vgaarb: loaded
vgaarb: bridge control possible 0000:05:00.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: Discovered peer bus ff
pci 0000:ff:00.0: [8086:2c50] type 0 class 0x000600
pci 0000:ff:00.1: [8086:2c81] type 0 class 0x000600
pci 0000:ff:02.0: [8086:2c90] type 0 class 0x000600
pci 0000:ff:02.1: [8086:2c91] type 0 class 0x000600
pci 0000:ff:03.0: [8086:2c98] type 0 class 0x000600
pci 0000:ff:03.1: [8086:2c99] type 0 class 0x000600
pci 0000:ff:03.2: [8086:2c9a] type 0 class 0x000600
pci 0000:ff:03.4: [8086:2c9c] type 0 class 0x000600
pci 0000:ff:04.0: [8086:2ca0] type 0 class 0x000600
pci 0000:ff:04.1: [8086:2ca1] type 0 class 0x000600
pci 0000:ff:04.2: [8086:2ca2] type 0 class 0x000600
pci 0000:ff:04.3: [8086:2ca3] type 0 class 0x000600
pci 0000:ff:05.0: [8086:2ca8] type 0 class 0x000600
pci 0000:ff:05.1: [8086:2ca9] type 0 class 0x000600
pci 0000:ff:05.2: [8086:2caa] type 0 class 0x000600
pci 0000:ff:05.3: [8086:2cab] type 0 class 0x000600
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009a400 - 000000000009ffff=20
reserve RAM buffer: 000000009da0c000 - 000000009fffffff=20
HPET: 8 timers in total, 4 timers will be used for per-cpu timer
hpet: hpet2 irq 40 for MSI
hpet: hpet3 irq 41 for MSI
hpet: hpet4 irq 42 for MSI
hpet: hpet5 irq 43 for MSI
Switching to clocksource hpet
pnp: PnP ACPI init
CE: hpet4 increased min_delta_ns to 20113 nsec
ACPI: bus type pnp registered
pnp 00:00: [bus 00-fe]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000c4000-0x000cbfff window]
pnp 00:00: [mem 0xfed40000-0xfedfffff window]
pnp 00:00: [mem 0xb0000000-0xfdffffff window]
pnp 00:00: [mem 0x00000000 window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [mem 0xfec00000-0xfecfffff]
pnp 00:01: Plug and Play ACPI device, IDs PNP0003 (active)
pnp 00:02: [io  0x0000-0x000f]
pnp 00:02: [io  0x0081-0x0083]
pnp 00:02: [io  0x0087]
pnp 00:02: [io  0x0089-0x008b]
pnp 00:02: [io  0x008f]
pnp 00:02: [io  0x00c0-0x00df]
pnp 00:02: [dma 4]
pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: [io  0x0070-0x0071]
pnp 00:03: [io  0x0074-0x0077]
pnp 00:03: [irq 8]
pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:04: [io  0x00f0]
pnp 00:04: [irq 13]
pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [mem 0xfed00000-0xfed003ff]
pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:07: [io  0x0500-0x057f]
pnp 00:07: [io  0x0600-0x061f]
pnp 00:07: [io  0x0880-0x0883]
pnp 00:07: [io  0x0ca4-0x0ca5]
pnp 00:07: [io  0x0400-0x047f]
pnp 00:07: [io  0x0092]
pnp 00:07: [io  0x0010-0x001f]
pnp 00:07: [io  0x0072-0x0073]
pnp 00:07: [io  0x0080]
pnp 00:07: [io  0x0084-0x0086]
pnp 00:07: [io  0x0088]
pnp 00:07: [io  0x008c-0x008e]
pnp 00:07: [io  0x0090-0x009f]
pnp 00:07: [io  0x0800-0x081f]
pnp 00:07: [io  0x0ca2-0x0ca3]
pnp 00:07: [mem 0xfed1c000-0xfed3fffe]
pnp 00:07: [mem 0xff000000-0xffffffff]
pnp 00:07: [mem 0xfee00000-0xfeefffff]
pnp 00:07: [mem 0xfe900000-0xfe90001f]
pnp 00:07: [mem 0xfea00000-0xfea0001f]
pnp 00:07: [mem 0xfed1b000-0xfed1bfff]
pnp 00:07: [mem 0xfed14000-0xfed17ffe]
pnp 00:07: [mem 0xfed18000-0xfed18ffe]
pnp 00:07: [mem 0xfed19000-0xfed19ffe]
system 00:07: [io  0x0500-0x057f] has been reserved
system 00:07: [io  0x0600-0x061f] has been reserved
system 00:07: [io  0x0880-0x0883] has been reserved
system 00:07: [io  0x0ca4-0x0ca5] has been reserved
system 00:07: [io  0x0400-0x047f] has been reserved
system 00:07: [io  0x0800-0x081f] has been reserved
system 00:07: [io  0x0ca2-0x0ca3] has been reserved
system 00:07: [mem 0xfed1c000-0xfed3fffe] could not be reserved
system 00:07: [mem 0xff000000-0xffffffff] could not be reserved
system 00:07: [mem 0xfee00000-0xfeefffff] has been reserved
system 00:07: [mem 0xfe900000-0xfe90001f] has been reserved
system 00:07: [mem 0xfea00000-0xfea0001f] has been reserved
system 00:07: [mem 0xfed1b000-0xfed1bfff] has been reserved
system 00:07: [mem 0xfed14000-0xfed17ffe] has been reserved
system 00:07: [mem 0xfed18000-0xfed18ffe] has been reserved
system 00:07: [mem 0xfed19000-0xfed19ffe] has been reserved
system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:08: [io  0x03f8-0x03ff]
pnp 00:08: [irq 4]
pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:09: [io  0x02f8-0x02ff]
pnp 00:09: [irq 3]
pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0a: [io  0x0ca2]
pnp 00:0a: [io  0x0ca3]
pnp 00:0a: Plug and Play ACPI device, IDs IPI0001 (active)
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:01:00.0: no compatible bridge window for [mem
0xfffc0000-0xffffffff pref]
pci 0000:02:00.0: no compatible bridge window for [mem
0xfffc0000-0xffffffff pref]
pci 0000:03:00.0: no compatible bridge window for [mem
0xfffc0000-0xffffffff pref]
pci 0000:05:00.0: no compatible bridge window for [mem
0xffff0000-0xffffffff pref]
PCI: max bus depth: 1 pci_try_num: 2
pci 0000:00:03.0: BAR 15: assigned [mem 0xb1e00000-0xb1efffff pref]
pci 0000:00:05.0: BAR 15: assigned [mem 0xb1f00000-0xb1ffffff pref]
pci 0000:00:1c.0: BAR 15: assigned [mem 0xb2000000-0xb20fffff pref]
pci 0000:01:00.0: BAR 6: assigned [mem 0xb1e00000-0xb1e3ffff pref]
pci 0000:00:03.0: PCI bridge to [bus 01-01]
pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:03.0:   bridge window [mem 0xb1c00000-0xb1cfffff]
pci 0000:00:03.0:   bridge window [mem 0xb1e00000-0xb1efffff pref]
pci 0000:02:00.0: BAR 6: assigned [mem 0xb1f00000-0xb1f3ffff pref]
pci 0000:00:05.0: PCI bridge to [bus 02-02]
pci 0000:00:05.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:05.0:   bridge window [mem 0xb1b00000-0xb1bfffff]
pci 0000:00:05.0:   bridge window [mem 0xb1f00000-0xb1ffffff pref]
pci 0000:03:00.0: BAR 6: assigned [mem 0xb2000000-0xb203ffff pref]
pci 0000:00:1c.0: PCI bridge to [bus 03-03]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xb1a00000-0xb1afffff]
pci 0000:00:1c.0:   bridge window [mem 0xb2000000-0xb21fffff pref]
pci 0000:00:1c.4: PCI bridge to [bus 04-04]
pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.4:   bridge window [mem 0xb1900000-0xb19fffff]
pci 0000:00:1c.4:   bridge window [mem pref disabled]
pci 0000:05:00.0: BAR 6: assigned [mem 0xb1810000-0xb181ffff pref]
pci 0000:00:1c.6: PCI bridge to [bus 05-05]
pci 0000:00:1c.6:   bridge window [io  disabled]
pci 0000:00:1c.6:   bridge window [mem 0xb1000000-0xb18fffff]
pci 0000:00:1c.6:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
pci 0000:00:1c.7: PCI bridge to [bus 06-06]
pci 0000:00:1c.7:   bridge window [io  disabled]
pci 0000:00:1c.7:   bridge window [mem disabled]
pci 0000:00:1c.7:   bridge window [mem pref disabled]
pci 0000:00:1e.0: PCI bridge to [bus 07-07]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem disabled]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.6: setting latency timer to 64
pci 0000:00:1c.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0xfed40000-0xfedfffff]
pci_bus 0000:00: resource 8 [mem 0xb0000000-0xfdffffff]
pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:01: resource 1 [mem 0xb1c00000-0xb1cfffff]
pci_bus 0000:01: resource 2 [mem 0xb1e00000-0xb1efffff pref]
pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:02: resource 1 [mem 0xb1b00000-0xb1bfffff]
pci_bus 0000:02: resource 2 [mem 0xb1f00000-0xb1ffffff pref]
pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:03: resource 1 [mem 0xb1a00000-0xb1afffff]
pci_bus 0000:03: resource 2 [mem 0xb2000000-0xb21fffff pref]
pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:04: resource 1 [mem 0xb1900000-0xb19fffff]
pci_bus 0000:05: resource 1 [mem 0xb1000000-0xb18fffff]
pci_bus 0000:05: resource 2 [mem 0xb0000000-0xb0ffffff 64bit pref]
pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:07: resource 7 [mem 0xfed40000-0xfedfffff]
pci_bus 0000:07: resource 8 [mem 0xb0000000-0xfdffffff]
pci_bus 0000:ff: resource 0 [io  0x0000-0xffff]
pci_bus 0000:ff: resource 1 [mem 0x00000000-0xfffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:1a.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1a.0: PCI INT A disabled
pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
pci 0000:00:1d.0: PCI INT A disabled
pci 0000:05:00.0: Boot video device
PCI: CLS 64 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880099a05000 - ffff88009da05000
software IO TLB at phys 0x99a05000 - 0x9da05000
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.30 [Flags: R/O].
fuse init (API version 7.16)
JFS: nTxBlock =3D 8192, nTxLock =3D 65536
SGI XFS with security attributes, large block/inode numbers, no debug
enabled
msgmni has been set to 7831
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:03.0: setting latency timer to 64
pcieport 0000:00:03.0: irq 44 for MSI/MSI-X
pcieport 0000:00:05.0: setting latency timer to 64
pcieport 0000:00:05.0: irq 45 for MSI/MSI-X
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 46 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
pcieport 0000:00:1c.4: irq 47 for MSI/MSI-X
pcieport 0000:00:1c.6: setting latency timer to 64
pcieport 0000:00:1c.6: irq 48 for MSI/MSI-X
pcieport 0000:00:1c.7: setting latency timer to 64
pcieport 0000:00:1c.7: irq 49 for MSI/MSI-X
aer 0000:00:03.0:pcie02: service driver aer loaded
aer 0000:00:05.0:pcie02: service driver aer loaded
intel_idle: disabled
input: Sleep Button
as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-3 state
ioatdma: Intel(R) QuickData Technology Driver 4.00
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
lp: driver loaded but no devices found
Real Time Clock Driver v1.12b
Non-volatile memory driver v1.3
loop: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.26)
Uniform Multi-Platform E-IDE driver
ide_generic: please use "probe_mask=3D0x3f" module parameter for probing
all legacy ISA IDE ports
Probing IDE interface ide0...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Refined TSC clocksource calibration: 2399.970 MHz.
Switching to clocksource tsc
ide1 at 0x170-0x177,0x376 on irq 15
ide-gd driver 1.18
ide-cd driver 5.00
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver 1.1-7[28000]-ms
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.05.38-rc1 Wed. May. 11 17:00:00 PDT 2011
mpt2sas version 08.100.00.02 loaded
ipr: IBM Power RAID SCSI Device Driver version: 2.5.2 (April 27, 2011)
RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
ahci 0000:00:1f.2: irq 50 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x3f impl SATA
mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part apst=20
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xb1d20000 port 0xb1d20100 irq 50
ata2: SATA max UDMA/133 abar m2048@0xb1d20000 port 0xb1d20180 irq 50
ata3: SATA max UDMA/133 abar m2048@0xb1d20000 port 0xb1d20200 irq 50
ata4: SATA max UDMA/133 abar m2048@0xb1d20000 port 0xb1d20280 irq 50
ata5: SATA max UDMA/133 abar m2048@0xb1d20000 port 0xb1d20300 irq 50
ata6: SATA max UDMA/133 abar m2048@0xb1d20000 port 0xb1d20380 irq 50
Fixed MDIO Bus: probed
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
e1000: Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1)
00:15:17:d0:ff:19
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 9, PBA No: 0310FF-0FF
e1000e 0000:01:00.0: Disabling ASPM L0s=20
e1000e 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:01:00.0: setting latency timer to 64
e1000e 0000:01:00.0: irq 52 for MSI/MSI-X
e1000e 0000:01:00.0: irq 53 for MSI/MSI-X
e1000e 0000:01:00.0: irq 54 for MSI/MSI-X
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: failed to IDENTIFY (I/O error, err_mask=3D0x100)
e1000e 0000:01:00.0: eth1: (PCI Express:2.5GT/s:Width x1)
00:1b:21:61:41:10
e1000e 0000:01:00.0: eth1: Intel(R) PRO/1000 Network Connection
e1000e 0000:01:00.0: eth1: MAC: 3, PHY: 8, PBA No: E46981-003
e1000e 0000:02:00.0: Disabling ASPM L0s=20
e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:02:00.0: setting latency timer to 64
e1000e 0000:02:00.0: irq 55 for MSI/MSI-X
e1000e 0000:02:00.0: irq 56 for MSI/MSI-X
e1000e 0000:02:00.0: irq 57 for MSI/MSI-X
e1000e 0000:02:00.0: eth2: (PCI Express:2.5GT/s:Width x1)
00:1b:21:61:41:1f
e1000e 0000:02:00.0: eth2: Intel(R) PRO/1000 Network Connection
e1000e 0000:02:00.0: eth2: MAC: 3, PHY: 8, PBA No: E46981-003
e1000e 0000:03:00.0: Disabling ASPM L0s=20
e1000e 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:03:00.0: setting latency timer to 64
e1000e 0000:03:00.0: irq 58 for MSI/MSI-X
e1000e 0000:03:00.0: irq 59 for MSI/MSI-X
e1000e 0000:03:00.0: irq 60 for MSI/MSI-X
e1000e 0000:03:00.0: eth3: (PCI Express:2.5GT/s:Width x1)
00:1b:21:61:40:53
e1000e 0000:03:00.0: eth3: Intel(R) PRO/1000 Network Connection
e1000e 0000:03:00.0: eth3: MAC: 3, PHY: 8, PBA No: E46981-003
e1000e 0000:04:00.0: Disabling ASPM L0s=20
e1000e 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:04:00.0: setting latency timer to 64
e1000e 0000:04:00.0: irq 61 for MSI/MSI-X
e1000e 0000:04:00.0: irq 62 for MSI/MSI-X
e1000e 0000:04:00.0: irq 63 for MSI/MSI-X
e1000e 0000:04:00.0: eth4: (PCI Express:2.5GT/s:Width x1)
00:15:17:d0:ff:18
e1000e 0000:04:00.0: eth4: Intel(R) PRO/1000 Network Connection
e1000e 0000:04:00.0: eth4: MAC: 3, PHY: 8, PBA No: 1010FF-0FF
Intel(R) Gigabit Ethernet Network Driver - version 3.0.6-k2
Copyright (c) 2007-2011 Intel Corporation.
Intel(R) Virtual Function Network Driver - version 1.0.8-k0
Copyright (c) 2009 - 2010 Intel Corporation.
bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
bonding: Warning: either miimon or arp_interval and arp_ip_target module
parameters must be specified, otherwise bonding will not detect link
failures! see bonding.txt for details.
jme: JMicron JMC2XX ethernet driver version 1.0.8
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
cnic: Broadcom NetXtreme II CNIC Driver cnic v2.2.14 (Mar 30, 2011)
sky2: driver version 1.28
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
PPP MPPE Compression module registered
NET: Registered protocol family 24
IMQ driver loaded successfully. (numdevs =3D 8, numqueues =3D 1)
        Hooking IMQ after NAT on PREROUTING.
        Hooking IMQ before NAT on POSTROUTING.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
  http://www.scyld.com/network/drivers.html
uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
console [netcon0] enabled
netconsole: network logging started
Fusion MPT base driver 3.04.19
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.19
Fusion MPT FC Host driver 3.04.19
Fusion MPT SAS Host driver 3.04.19
Fusion MPT misc device (ioctl) driver 3.04.19
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=3D10,220)
usbmon: debugfs is not available
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:1a.0: setting latency timer to 64
ehci_hcd 0000:00:1a.0: EHCI Host Controller
ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.0: debug port 2
ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.0: irq 21, io mem 0xb1d22000
ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.0: setting latency timer to 64
ehci_hcd 0000:00:1d.0: EHCI Host Controller
ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.0: debug port 2
ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.0: irq 23, io mem 0xb1d21000
ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
USB Serial support registered for GSM modem (1-port)
usbcore: registered new interface driver option
option: v0.7.2:USB Driver for GSM modems
USB Serial support registered for pl2303
usbcore: registered new interface driver pl2303
pl2303: Prolific PL2303 USB to serial adaptor driver
i8042: PNP: No PS/2 controller found. Probing ports directly.
i8042: No controller found
mousedev: PS/2 mouse device common for all mice
i2c /dev entries driver
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 18 (level, low) -> IRQ 18
usbcore: registered new interface driver i2c-diolan-u2c
i2c-parport: adapter type unspecified
i2c-parport-light: adapter type unspecified
usbcore: registered new interface driver i2c-tiny-usb
applesmc: supported laptop not found!
applesmc: driver init failed (ret=3D-19)!
coretemp coretemp.0: TjMax is 99 C.
coretemp coretemp.0: TjMax is 99 C.
coretemp coretemp.0: TjMax is 99 C.
coretemp coretemp.0: TjMax is 99 C.
usb 1-1: new high speed USB device number 2 using ehci_hcd
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 6 ports detected
usb 2-1: new high speed USB device number 2 using ehci_hcd
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 8 ports detected
i2c-core: driver [max6639] using legacy suspend method
i2c-core: driver [max6639] using legacy resume method
pc87360: PC8736x not detected, module not inserted
via_cputemp: Not a VIA CPU
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: multipath personality registered for level -4
cpuidle: using governor ladder
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
oprofile: using NMI interrupt.
pktgen: Packet Generator for packet performance testing. Version: 2.74
GACT probability on
Mirror/redirect action on
netem: version 1.3
u32 classifier
    Actions configured
Netfilter messages via NETLINK v0.30.
NF_TPROXY: Transparent proxy support initialized, version 4.1.0
NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
xt_time: kernel timezone is -0000
ip_set: protocol 6
IPv4 over IPv4 tunneling driver
ip_tables: (C) 2000-2006 Netfilter Core Team
arp_tables: (C) 2002 David S. Miller
TCP bic registered
TCP cubic registered
TCP westwood registered
TCP highspeed registered
TCP hybla registered
TCP htcp registered
TCP vegas registered
TCP veno registered
TCP scalable registered
TCP lp registered
TCP yeah registered
TCP illinois registered
NET: Registered protocol family 17
Bridge firewalling registered
802.1Q VLAN Support v1.8
Registering the dns_resolver key type
usb 2-1.2: new full speed USB device number 3 using ehci_hcd
input: American Megatrends Inc. Virtual Keyboard and Mouse
as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input2
generic-usb 0003:046B:FF10.0001: input: USB HID v1.10 Keyboard [American
Megatrends Inc. Virtual Keyboard and Mouse] on
usb-0000:00:1d.0-1.2/input0
input: American Megatrends Inc. Virtual Keyboard and Mouse
as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.1/input/input3
generic-usb 0003:046B:FF10.0002: input: USB HID v1.10 Mouse [American
Megatrends Inc. Virtual Keyboard and Mouse] on
usb-0000:00:1d.0-1.2/input1
ata1.00: ATA-8: ST3250310NS, SN06, max UDMA/133
ata1.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: ATA-8: ST3250310NS, SN06, max UDMA/133
ata2.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST3250310NS      SN06 PQ: 0
ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
scsi 1:0:0:0: Direct-Access     ATA      ST3250310NS      SN06 PQ: 0
ANSI: 5
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 1:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
 sdb: sdb1 sdb2 sdb3
sd 1:0:0:0: [sdb] Attached SCSI disk
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: qc timeout (cmd 0xa1)
ata4.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
ata4: limiting SATA link speed to 1.5 Gbps
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata4.00: failed to IDENTIFY (I/O error, err_mask=3D0x100)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=3Dnoautodetect
md: Autodetecting RAID arrays.
md: Scanned 4 and added 4 devices.
md: autorun ...
md: considering sdb3 ...
md:  adding sdb3 ...
md: sdb1 has different UUID to sdb3
md:  adding sda3 ...
md: sda1 has different UUID to sdb3
md: created md1
md: bind<sda3>
md: bind<sdb3>
md: running: <sdb3><sda3>
bio: create slab <bio-1> at 1
md/raid1:md1: active with 2 out of 2 mirrors
md1: detected capacity change from 0 to 247786438656
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
md/raid1:md0: active with 2 out of 2 mirrors
md0: detected capacity change from 0 to 246677504
md: ... autorun DONE.
 md1: unknown partition table
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (md1): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 9:1.
Freeing unused kernel memory: 540k freed
udev: starting version 151
udevd (183): /proc/183/oom_adj is deprecated, please
use /proc/183/oom_score_adj instead.
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
 md0: unknown partition table
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
EXT3-fs (md1): using internal journal
Adding 1975988k swap on /dev/sda2.  Priority:-1 extents:1
across:1975988k=20
bonding: bond0: setting mode to 802.3ad (4).
bonding: bond0: Setting MII monitoring interval to 100.
bonding: bond0: Setting down delay to 200.
bonding: bond0: Setting up delay to 200.
bonding: bond0: setting xmit hash policy to layer3+4 (1).
8021q: adding VLAN 0 to HW filter on device bond0
e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
8021q: adding VLAN 0 to HW filter on device eth1
e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
bonding: bond0: enslaving eth0 as a backup interface with a down link.
8021q: adding VLAN 0 to HW filter on device eth1
bonding: bond0: enslaving eth1 as a backup interface with a down link.
e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx
bonding: bond0: link status up for interface eth1, enabling it in 0 ms.
bonding: bond0: link status definitely up for interface eth1, 1000 Mbps
full duplex.
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx
bonding: bond0: link status up for interface eth0, enabling it in 200
ms.
bonding: bond0: link status definitely up for interface eth0, 1000 Mbps
full duplex.
bonding: bond1: setting mode to 802.3ad (4).
bonding: bond1: Setting MII monitoring interval to 100.
bonding: bond1: Setting down delay to 200.
bonding: bond1: Setting up delay to 200.
bonding: bond1: setting xmit hash policy to layer3+4 (1).
8021q: adding VLAN 0 to HW filter on device bond1
8021q: adding VLAN 0 to HW filter on device eth2
8021q: adding VLAN 0 to HW filter on device eth3
8021q: adding VLAN 0 to HW filter on device eth2
bonding: bond1: enslaving eth2 as a backup interface with a down link.
8021q: adding VLAN 0 to HW filter on device eth3
bonding: bond1: enslaving eth3 as a backup interface with a down link.
device bond0.2197 entered promiscuous mode
device bond0 entered promiscuous mode
device eth0 entered promiscuous mode
device eth1 entered promiscuous mode
device bond1.2197 entered promiscuous mode
device bond1 entered promiscuous mode
device eth2 entered promiscuous mode
device eth3 entered promiscuous mode
br2197: port 1(bond0.2197) entering forwarding state
br2197: port 1(bond0.2197) entering forwarding state
8021q: adding VLAN 0 to HW filter on device eth4
e1000e: eth2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx
bonding: bond1: link status up for interface eth2, enabling it in 0 ms.
bonding: bond1: link status definitely up for interface eth2, 1000 Mbps
full duplex.
br2197: port 2(bond1.2197) entering forwarding state
br2197: port 2(bond1.2197) entering forwarding state
e1000e: eth3 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx
bonding: bond1: link status up for interface eth3, enabling it in 200
ms.
bonding: bond1: link status definitely up for interface eth3, 1000 Mbps
full duplex.
br2197: port 1(bond0.2197) entering forwarding state
br2197: port 2(bond1.2197) entering forwarding state
hrtimer: interrupt took 24661 ns
device ifb0 entered promiscuous mode
scsi_verify_blk_ioctl: 78 callbacks suppressed
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!


Kernel 2.6.35.11 config:
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.35.11-perf
# Tue Mar  6 15:51:58 2012
#
CONFIG_64BIT=3Dy
# CONFIG_X86_32 is not set
CONFIG_X86_64=3Dy
CONFIG_X86=3Dy
CONFIG_INSTRUCTION_DECODER=3Dy
CONFIG_OUTPUT_FORMAT=3D"elf64-x86-64"
CONFIG_ARCH_DEFCONFIG=3D"arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=3Dy
CONFIG_GENERIC_CMOS_UPDATE=3Dy
CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=3Dy
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_LATENCYTOP_SUPPORT=3Dy
CONFIG_MMU=3Dy
CONFIG_ZONE_DMA=3Dy
CONFIG_NEED_DMA_MAP_STATE=3Dy
CONFIG_NEED_SG_DMA_LENGTH=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=3Dy
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
CONFIG_GENERIC_TIME_VSYSCALL=3Dy
CONFIG_ARCH_HAS_CPU_RELAX=3Dy
CONFIG_ARCH_HAS_DEFAULT_IDLE=3Dy
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=3Dy
CONFIG_HAVE_SETUP_PER_CPU_AREA=3Dy
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=3Dy
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=3Dy
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=3Dy
CONFIG_ARCH_HIBERNATION_POSSIBLE=3Dy
CONFIG_ARCH_SUSPEND_POSSIBLE=3Dy
CONFIG_ZONE_DMA32=3Dy
CONFIG_ARCH_POPULATES_NODE_MAP=3Dy
CONFIG_AUDIT_ARCH=3Dy
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=3Dy
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=3Dy
CONFIG_HAVE_EARLY_RES=3Dy
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_GENERIC_PENDING_IRQ=3Dy
CONFIG_USE_GENERIC_SMP_HELPERS=3Dy
CONFIG_X86_64_SMP=3Dy
CONFIG_X86_HT=3Dy
CONFIG_X86_TRAMPOLINE=3Dy
CONFIG_ARCH_HWEIGHT_CFLAGS=3D"-fcall-saved-rdi -fcall-saved-rsi
-fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9
-fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=3Dy

#
# General setup
#
CONFIG_EXPERIMENTAL=3Dy
CONFIG_LOCK_KERNEL=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32
CONFIG_CROSS_COMPILE=3D""
CONFIG_LOCALVERSION=3D""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=3Dy
CONFIG_HAVE_KERNEL_BZIP2=3Dy
CONFIG_HAVE_KERNEL_LZMA=3Dy
CONFIG_HAVE_KERNEL_LZO=3Dy
CONFIG_KERNEL_GZIP=3Dy
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_SYSVIPC_SYSCTL=3Dy
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=3Dy
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_TINY_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=3D32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=3Dy
CONFIG_IKCONFIG_PROC=3Dy
CONFIG_LOG_BUF_SHIFT=3D15
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=3Dy
CONFIG_CGROUPS=3Dy
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=3Dy
CONFIG_CGROUP_FREEZER=3Dy
CONFIG_CGROUP_DEVICE=3Dy
CONFIG_CPUSETS=3Dy
CONFIG_PROC_PID_CPUSET=3Dy
CONFIG_CGROUP_CPUACCT=3Dy
CONFIG_RESOURCE_COUNTERS=3Dy
CONFIG_CGROUP_MEM_RES_CTLR=3Dy
# CONFIG_CGROUP_MEM_RES_CTLR_SWAP is not set
CONFIG_CGROUP_SCHED=3Dy
CONFIG_FAIR_GROUP_SCHED=3Dy
CONFIG_RT_GROUP_SCHED=3Dy
CONFIG_BLK_CGROUP=3Dy
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_MM_OWNER=3Dy
# CONFIG_SYSFS_DEPRECATED_V2 is not set
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=3Dy
CONFIG_UTS_NS=3Dy
CONFIG_IPC_NS=3Dy
CONFIG_USER_NS=3Dy
CONFIG_PID_NS=3Dy
CONFIG_NET_NS=3Dy
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=3Dy
CONFIG_ANON_INODES=3Dy
# CONFIG_EMBEDDED is not set
CONFIG_UID16=3Dy
CONFIG_SYSCTL_SYSCALL=3Dy
CONFIG_KALLSYMS=3Dy
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
CONFIG_PCSPKR_PLATFORM=3Dy
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_TIMERFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_AIO=3Dy
CONFIG_HAVE_PERF_EVENTS=3Dy

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=3Dy
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_PCI_QUIRKS=3Dy
CONFIG_SLUB_DEBUG=3Dy
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=3Dy
# CONFIG_SLOB is not set
CONFIG_PROFILING=3Dy
CONFIG_OPROFILE=3Dy
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=3Dy
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=3Dy
CONFIG_HAVE_IOREMAP_PROT=3Dy
CONFIG_HAVE_KPROBES=3Dy
CONFIG_HAVE_KRETPROBES=3Dy
CONFIG_HAVE_OPTPROBES=3Dy
CONFIG_HAVE_ARCH_TRACEHOOK=3Dy
CONFIG_HAVE_DMA_ATTRS=3Dy
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=3Dy
CONFIG_HAVE_DMA_API_DEBUG=3Dy
CONFIG_HAVE_HW_BREAKPOINT=3Dy
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=3Dy
CONFIG_HAVE_USER_RETURN_NOTIFIER=3Dy

#
# GCOV-based kernel profiling
#
CONFIG_SLOW_WORK=3Dy
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=3Dy
CONFIG_RT_MUTEXES=3Dy
CONFIG_BASE_SMALL=3D0
# CONFIG_MODULES is not set
CONFIG_BLOCK=3Dy
CONFIG_BLK_DEV_BSG=3Dy
CONFIG_BLK_DEV_INTEGRITY=3Dy
CONFIG_BLOCK_COMPAT=3Dy

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
CONFIG_CFQ_GROUP_IOSCHED=3Dy
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=3Dy
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"cfq"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_INLINE_SPIN_UNLOCK=3Dy
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=3Dy
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=3Dy
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=3Dy
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=3Dy
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=3Dy
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=3Dy
CONFIG_FREEZER=3Dy

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=3Dy
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy
CONFIG_SMP=3Dy
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_MPPARSE=3Dy
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=3Dy
CONFIG_SCHED_OMIT_FRAME_POINTER=3Dy
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=3Dy
CONFIG_MEMTEST=3Dy
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=3Dy
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=3Dy
CONFIG_X86_INTERNODE_CACHE_SHIFT=3D6
CONFIG_X86_CMPXCHG=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D6
CONFIG_X86_XADD=3Dy
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_INTEL_USERCOPY=3Dy
CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
CONFIG_X86_P6_NOP=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMPXCHG64=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_FAMILY=3D64
CONFIG_X86_DEBUGCTLMSR=3Dy
CONFIG_CPU_SUP_INTEL=3Dy
CONFIG_CPU_SUP_AMD=3Dy
CONFIG_CPU_SUP_CENTAUR=3Dy
CONFIG_HPET_TIMER=3Dy
CONFIG_HPET_EMULATE_RTC=3Dy
CONFIG_DMI=3Dy
CONFIG_GART_IOMMU=3Dy
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=3Dy
CONFIG_IOMMU_HELPER=3Dy
# CONFIG_IOMMU_API is not set
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=3D8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=3Dy
CONFIG_PREEMPT_NONE=3Dy
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=3Dy
CONFIG_X86_IO_APIC=3Dy
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=3Dy
CONFIG_X86_MCE_INTEL=3Dy
CONFIG_X86_MCE_AMD=3Dy
CONFIG_X86_MCE_THRESHOLD=3Dy
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=3Dy
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=3Dy
CONFIG_DIRECT_GBPAGES=3Dy
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=3Dy
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
CONFIG_ILLEGAL_POINTER_VALUE=3D0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=3Dy
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=3Dy
CONFIG_SPARSEMEM=3Dy
CONFIG_HAVE_MEMORY_PRESENT=3Dy
CONFIG_SPARSEMEM_EXTREME=3Dy
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=3Dy
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=3Dy
CONFIG_SPARSEMEM_VMEMMAP=3Dy
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=3Dy
CONFIG_SPLIT_PTLOCK_CPUS=3D4
CONFIG_PHYS_ADDR_T_64BIT=3Dy
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_BOUNCE=3Dy
CONFIG_VIRT_TO_BUS=3Dy
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=3D4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=3Dy
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
# CONFIG_X86_RESERVE_LOW_64K is not set
CONFIG_MTRR=3Dy
CONFIG_MTRR_SANITIZER=3Dy
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=3D0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=3D1
CONFIG_X86_PAT=3Dy
CONFIG_ARCH_USES_PG_UNCACHED=3Dy
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=3Dy
CONFIG_HZ_100=3Dy
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=3D100
CONFIG_SCHED_HRTICK=3Dy
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=3D0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=3D0x1000000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=3Dy
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy

#
# Power management and ACPI options
#
CONFIG_PM=3Dy
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=3Dy
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_POWER_METER is not set
CONFIG_ACPI_SYSFS_POWER=3Dy
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=3Dy
CONFIG_ACPI_BATTERY=3Dy
CONFIG_ACPI_BUTTON=3Dy
CONFIG_ACPI_FAN=3Dy
CONFIG_ACPI_DOCK=3Dy
CONFIG_ACPI_PROCESSOR=3Dy
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=3Dy
CONFIG_ACPI_CUSTOM_DSDT_FILE=3D""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=3Dy
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=3Dy
CONFIG_CPU_IDLE_GOV_LADDER=3Dy
CONFIG_INTEL_IDLE=3Dy

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=3Dy
CONFIG_I7300_IDLE=3Dy

#
# Bus options (PCI etc.)
#
CONFIG_PCI=3Dy
CONFIG_PCI_DIRECT=3Dy
CONFIG_PCI_MMCONFIG=3Dy
CONFIG_PCI_DOMAINS=3Dy
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=3Dy
CONFIG_PCIEAER=3Dy
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=3Dy
CONFIG_PCI_MSI=3Dy
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=3Dy
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=3Dy
CONFIG_ISA_DMA_API=3Dy
CONFIG_K8_NB=3Dy
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_COMPAT_BINFMT_ELF=3Dy
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=3Dy
CONFIG_IA32_EMULATION=3Dy
CONFIG_IA32_AOUT=3Dy
CONFIG_COMPAT=3Dy
CONFIG_COMPAT_FOR_U64_ALIGNMENT=3Dy
CONFIG_SYSVIPC_COMPAT=3Dy
CONFIG_NET=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dy
CONFIG_UNIX=3Dy
# CONFIG_NET_KEY is not set
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
CONFIG_IP_ADVANCED_ROUTER=3Dy
# CONFIG_ASK_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE=3Dy
# CONFIG_IP_FIB_HASH is not set
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=3Dy
CONFIG_IP_ROUTE_MULTIPATH=3Dy
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=3Dy
CONFIG_NET_IPGRE=3Dy
CONFIG_NET_IPGRE_BROADCAST=3Dy
CONFIG_IP_MROUTE=3Dy
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=3Dy
CONFIG_IP_PIMSM_V2=3Dy
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=3Dy
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=3Dy
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=3Dy
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=3Dy
CONFIG_DEFAULT_TCP_CONG=3D"cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=3Dy
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=3Dy
CONFIG_BRIDGE_NETFILTER=3Dy

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=3Dy
CONFIG_NETFILTER_NETLINK_QUEUE=3Dy
CONFIG_NETFILTER_NETLINK_LOG=3Dy
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_TPROXY=3Dy
CONFIG_NETFILTER_XTABLES=3Dy

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=3Dy

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=3Dy
CONFIG_NETFILTER_XT_TARGET_DSCP=3Dy
CONFIG_NETFILTER_XT_TARGET_HL=3Dy
CONFIG_NETFILTER_XT_TARGET_IMQ=3Dy
CONFIG_NETFILTER_XT_TARGET_MARK=3Dy
CONFIG_NETFILTER_XT_TARGET_NFLOG=3Dy
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=3Dy
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
CONFIG_NETFILTER_XT_TARGET_TPROXY=3Dy
CONFIG_NETFILTER_XT_TARGET_TRACE=3Dy
CONFIG_NETFILTER_XT_TARGET_TCPMSS=3Dy
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=3Dy

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_COMMENT=3Dy
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=3Dy
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=3Dy
CONFIG_NETFILTER_XT_MATCH_HL=3Dy
CONFIG_NETFILTER_XT_MATCH_IPRANGE=3Dy
CONFIG_NETFILTER_XT_MATCH_LENGTH=3Dy
CONFIG_NETFILTER_XT_MATCH_LIMIT=3Dy
CONFIG_NETFILTER_XT_MATCH_MAC=3Dy
CONFIG_NETFILTER_XT_MATCH_MARK=3Dy
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=3Dy
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=3Dy
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=3Dy
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
CONFIG_NETFILTER_XT_MATCH_REALM=3Dy
CONFIG_NETFILTER_XT_MATCH_RECENT=3Dy
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_SOCKET is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
CONFIG_NETFILTER_XT_MATCH_STRING=3Dy
CONFIG_NETFILTER_XT_MATCH_TCPMSS=3Dy
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
CONFIG_NETFILTER_XT_MATCH_U32=3Dy
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=3Dy
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=3Dy
CONFIG_IP_NF_MATCH_ADDRTYPE=3Dy
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_ECN is not set
CONFIG_IP_NF_MATCH_TTL=3Dy
CONFIG_IP_NF_FILTER=3Dy
CONFIG_IP_NF_TARGET_REJECT=3Dy
CONFIG_IP_NF_TARGET_LOG=3Dy
CONFIG_IP_NF_TARGET_ULOG=3Dy
CONFIG_IP_NF_MANGLE=3Dy
CONFIG_IP_NF_TARGET_ECN=3Dy
CONFIG_IP_NF_TARGET_TTL=3Dy
CONFIG_IP_NF_RAW=3Dy
# CONFIG_IP_NF_ARPTABLES is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=3Dy
CONFIG_BRIDGE=3Dy
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=3Dy
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=3Dy
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=3Dy

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=3Dy
CONFIG_NET_SCH_HTB=3Dy
CONFIG_NET_SCH_HFSC=3Dy
CONFIG_NET_SCH_PRIO=3Dy
CONFIG_NET_SCH_MULTIQ=3Dy
CONFIG_NET_SCH_RED=3Dy
CONFIG_NET_SCH_SFQ=3Dy
CONFIG_NET_SCH_TEQL=3Dy
CONFIG_NET_SCH_TBF=3Dy
CONFIG_NET_SCH_GRED=3Dy
CONFIG_NET_SCH_DSMARK=3Dy
CONFIG_NET_SCH_NETEM=3Dy
CONFIG_NET_SCH_DRR=3Dy
CONFIG_NET_SCH_INGRESS=3Dy

#
# Classification
#
CONFIG_NET_CLS=3Dy
CONFIG_NET_CLS_BASIC=3Dy
CONFIG_NET_CLS_TCINDEX=3Dy
CONFIG_NET_CLS_ROUTE4=3Dy
CONFIG_NET_CLS_ROUTE=3Dy
CONFIG_NET_CLS_FW=3Dy
CONFIG_NET_CLS_U32=3Dy
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=3Dy
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=3Dy
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=3Dy
CONFIG_NET_EMATCH_STACK=3D32
CONFIG_NET_EMATCH_CMP=3Dy
CONFIG_NET_EMATCH_NBYTE=3Dy
CONFIG_NET_EMATCH_U32=3Dy
CONFIG_NET_EMATCH_META=3Dy
CONFIG_NET_EMATCH_TEXT=3Dy
CONFIG_NET_CLS_ACT=3Dy
CONFIG_NET_ACT_POLICE=3Dy
CONFIG_NET_ACT_GACT=3Dy
CONFIG_GACT_PROB=3Dy
CONFIG_NET_ACT_MIRRED=3Dy
CONFIG_NET_ACT_IPT=3Dy
CONFIG_NET_ACT_NAT=3Dy
CONFIG_NET_ACT_PEDIT=3Dy
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=3Dy
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=3Dy
# CONFIG_DCB is not set
CONFIG_RPS=3Dy

#
# Network testing
#
CONFIG_NET_PKTGEN=3Dy
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=3Dy
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=3D""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
CONFIG_FW_LOADER=3Dy
CONFIG_FIRMWARE_IN_KERNEL=3Dy
CONFIG_EXTRA_FIRMWARE=3D""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=3Dy
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=3Dy
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=3Dy
CONFIG_PARPORT_PC=3Dy
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=3Dy
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
CONFIG_BLK_CPQ_DA=3Dy
CONFIG_BLK_CPQ_CISS_DA=3Dy
# CONFIG_CISS_SCSI_TAPE is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dy
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=3Dy
CONFIG_IDE=3Dy

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=3Dy
CONFIG_IDE_TIMINGS=3Dy
CONFIG_IDE_ATAPI=3Dy
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=3Dy
CONFIG_IDE_GD_ATA=3Dy
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=3Dy
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=3Dy
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=3Dy
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=3Dy

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=3Dy
CONFIG_IDEPCI_PCIBUS_ORDER=3Dy
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=3Dy
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=3Dy
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=3Dy
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=3Dy
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=3Dy
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=3Dy
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=3Dy

#
# SCSI device support
#
CONFIG_SCSI_MOD=3Dy
CONFIG_RAID_ATTRS=3Dy
CONFIG_SCSI=3Dy
CONFIG_SCSI_DMA=3Dy
CONFIG_SCSI_TGT=3Dy
CONFIG_SCSI_NETLINK=3Dy
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dy
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=3Dy
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=3Dy

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dy
CONFIG_SCSI_FC_ATTRS=3Dy
# CONFIG_SCSI_FC_TGT_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=3Dy
CONFIG_SCSI_SAS_LIBSAS=3Dy
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=3Dy
# CONFIG_ISCSI_TCP is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=3Dy
CONFIG_SCSI_AACRAID=3Dy
CONFIG_SCSI_AIC7XXX=3Dy
CONFIG_AIC7XXX_CMDS_PER_DEVICE=3D32
CONFIG_AIC7XXX_RESET_DELAY_MS=3D5000
CONFIG_AIC7XXX_DEBUG_ENABLE=3Dy
CONFIG_AIC7XXX_DEBUG_MASK=3D0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=3Dy
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=3Dy
CONFIG_AIC79XX_CMDS_PER_DEVICE=3D32
CONFIG_AIC79XX_RESET_DELAY_MS=3D5000
CONFIG_AIC79XX_DEBUG_ENABLE=3Dy
CONFIG_AIC79XX_DEBUG_MASK=3D0
CONFIG_AIC79XX_REG_PRETTY_PRINT=3Dy
CONFIG_SCSI_AIC94XX=3Dy
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=3Dy
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_DPT_I2O=3Dy
CONFIG_SCSI_ADVANSYS=3Dy
CONFIG_SCSI_ARCMSR=3Dy
# CONFIG_SCSI_ARCMSR_AER is not set
CONFIG_MEGARAID_NEWGEN=3Dy
CONFIG_MEGARAID_MM=3Dy
CONFIG_MEGARAID_MAILBOX=3Dy
CONFIG_MEGARAID_LEGACY=3Dy
CONFIG_MEGARAID_SAS=3Dy
CONFIG_SCSI_MPT2SAS=3Dy
CONFIG_SCSI_MPT2SAS_MAX_SGE=3D128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_HPTIOP=3Dy
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_IPS=3Dy
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=3Dy
CONFIG_SCSI_IPR_TRACE=3Dy
CONFIG_SCSI_IPR_DUMP=3Dy
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=3Dy
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=3Dy
CONFIG_SATA_PMP=3Dy

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=3Dy
CONFIG_SATA_AHCI_PLATFORM=3Dy
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_SIL24=3Dy
CONFIG_ATA_SFF=3Dy

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=3Dy

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=3Dy
CONFIG_SATA_MV=3Dy
CONFIG_SATA_NV=3Dy
# CONFIG_SATA_PROMISE is not set
CONFIG_SATA_SIL=3Dy
CONFIG_SATA_SIS=3Dy
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=3Dy
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=3Dy
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=3Dy
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=3Dy
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=3Dy
CONFIG_BLK_DEV_MD=3Dy
CONFIG_MD_AUTODETECT=3Dy
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=3Dy
CONFIG_MD_RAID1=3Dy
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
CONFIG_MD_MULTIPATH=3Dy
# CONFIG_MD_FAULTY is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_FUSION=3Dy
CONFIG_FUSION_SPI=3Dy
CONFIG_FUSION_FC=3Dy
CONFIG_FUSION_SAS=3Dy
CONFIG_FUSION_MAX_SGE=3D128
CONFIG_FUSION_CTL=3Dy
CONFIG_FUSION_LOGGING=3Dy

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=3Dy
CONFIG_IFB=3Dy
CONFIG_DUMMY=3Dy
CONFIG_BONDING=3Dy
CONFIG_MACVLAN=3Dy
CONFIG_MACVTAP=3Dy
# CONFIG_EQUALIZER is not set
CONFIG_IMQ=3Dy
# CONFIG_IMQ_BEHAVIOR_AA is not set
CONFIG_IMQ_BEHAVIOR_AB=3Dy
# CONFIG_IMQ_BEHAVIOR_BA is not set
# CONFIG_IMQ_BEHAVIOR_BB is not set
CONFIG_IMQ_NUM_DEVS=3D16
CONFIG_TUN=3Dy
CONFIG_VETH=3Dy
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=3Dy

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=3Dy
CONFIG_DAVICOM_PHY=3Dy
CONFIG_QSEMI_PHY=3Dy
CONFIG_LXT_PHY=3Dy
CONFIG_CICADA_PHY=3Dy
CONFIG_VITESSE_PHY=3Dy
CONFIG_SMSC_PHY=3Dy
CONFIG_BROADCOM_PHY=3Dy
CONFIG_ICPLUS_PHY=3Dy
CONFIG_REALTEK_PHY=3Dy
CONFIG_NATIONAL_PHY=3Dy
CONFIG_STE10XP=3Dy
CONFIG_LSI_ET1011C_PHY=3Dy
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=3Dy
CONFIG_MDIO_BITBANG=3Dy
CONFIG_NET_ETHERNET=3Dy
CONFIG_MII=3Dy
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=3Dy
CONFIG_VORTEX=3Dy
CONFIG_TYPHOON=3Dy
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
CONFIG_NET_TULIP=3Dy
CONFIG_DE2104X=3Dy
CONFIG_DE2104X_DSL=3D0
CONFIG_TULIP=3Dy
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
CONFIG_TULIP_NAPI=3Dy
# CONFIG_TULIP_NAPI_HW_MITIGATION is not set
CONFIG_DE4X5=3Dy
CONFIG_WINBOND_840=3Dy
CONFIG_DM9102=3Dy
CONFIG_ULI526X=3Dy
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=3Dy
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_B44=3Dy
CONFIG_B44_PCI_AUTOSELECT=3Dy
CONFIG_B44_PCICORE_AUTOSELECT=3Dy
CONFIG_B44_PCI=3Dy
CONFIG_FORCEDETH=3Dy
CONFIG_E100=3Dy
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=3Dy
CONFIG_8139TOO_PIO=3Dy
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
CONFIG_SIS900=3Dy
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
CONFIG_VIA_RHINE=3Dy
CONFIG_VIA_RHINE_MMIO=3Dy
# CONFIG_SC92031 is not set
# CONFIG_NET_POCKET is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=3Dy
CONFIG_ACENIC=3Dy
CONFIG_ACENIC_OMIT_TIGON_I=3Dy
CONFIG_DL2K=3Dy
CONFIG_E1000=3Dy
CONFIG_E1000E=3Dy
CONFIG_IP1000=3Dy
CONFIG_IGB=3Dy
CONFIG_IGB_DCA=3Dy
CONFIG_IGBVF=3Dy
CONFIG_NS83820=3Dy
CONFIG_HAMACHI=3Dy
CONFIG_YELLOWFIN=3Dy
CONFIG_R8169=3Dy
CONFIG_R8169_VLAN=3Dy
CONFIG_SIS190=3Dy
CONFIG_SKGE=3Dy
CONFIG_SKY2=3Dy
CONFIG_VIA_VELOCITY=3Dy
CONFIG_TIGON3=3Dy
CONFIG_BNX2=3Dy
CONFIG_CNIC=3Dy
CONFIG_QLA3XXX=3Dy
CONFIG_ATL1=3Dy
CONFIG_ATL1E=3Dy
CONFIG_ATL1C=3Dy
CONFIG_JME=3Dy
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=3Dy
CONFIG_PPP_MULTILINK=3Dy
CONFIG_PPP_FILTER=3Dy
CONFIG_PPP_ASYNC=3Dy
CONFIG_PPP_SYNC_TTY=3Dy
CONFIG_PPP_DEFLATE=3Dy
CONFIG_PPP_BSDCOMP=3Dy
CONFIG_PPP_MPPE=3Dy
CONFIG_PPPOE=3Dy
# CONFIG_SLIP is not set
CONFIG_SLHC=3Dy
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=3Dy
CONFIG_NETCONSOLE_DYNAMIC=3Dy
CONFIG_NETPOLL=3Dy
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=3Dy
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=3Dy
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
CONFIG_INPUT_MOUSEDEV_PSAUX=3Dy
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
CONFIG_KEYBOARD_ATKBD=3Dy
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=3Dy
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_CONSOLE_TRANSLATIONS=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=3Dy
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=3Dy
CONFIG_SERIAL_8250_PCI=3Dy
CONFIG_SERIAL_8250_PNP=3Dy
CONFIG_SERIAL_8250_NR_UARTS=3D4
CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=3Dy
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_UNIX98_PTYS=3Dy
CONFIG_DEVPTS_MULTIPLE_INSTANCES=3Dy
CONFIG_LEGACY_PTYS=3Dy
CONFIG_LEGACY_PTY_COUNT=3D256
CONFIG_PRINTER=3Dy
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=3Dy
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=3Dy
CONFIG_HW_RANDOM_AMD=3Dy
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=3Dy
CONFIG_RTC=3Dy
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=3Dy
# CONFIG_RAMOOPS is not set
# CONFIG_I2C is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=3Dy
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=3Dy
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=3Dy
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_K8TEMP=3Dy
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_I5K_AMB=3Dy
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_CORETEMP=3Dy
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_THERMAL=3Dy
CONFIG_THERMAL_HWMON=3Dy
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=3Dy

#
# Sonics Silicon Backplane
#
CONFIG_SSB=3Dy
CONFIG_SSB_SPROM=3Dy
CONFIG_SSB_PCIHOST_POSSIBLE=3Dy
CONFIG_SSB_PCIHOST=3Dy
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=3Dy
CONFIG_SSB_DRIVER_PCICORE=3Dy
# CONFIG_MFD_SUPPORT is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=3Dy
CONFIG_VGA_ARB_MAX_GPUS=3D16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=3Dy
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=3Dy
CONFIG_HID=3Dy
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=3Dy
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# Special HID drivers
#
# CONFIG_HID_3M_PCT is not set
CONFIG_HID_A4TECH=3Dy
CONFIG_HID_APPLE=3Dy
CONFIG_HID_BELKIN=3Dy
# CONFIG_HID_CANDO is not set
CONFIG_HID_CHERRY=3Dy
CONFIG_HID_CHICONY=3Dy
CONFIG_HID_CYPRESS=3Dy
CONFIG_HID_DRAGONRISE=3Dy
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EGALAX is not set
CONFIG_HID_EZKEY=3Dy
CONFIG_HID_KYE=3Dy
CONFIG_HID_GYRATION=3Dy
CONFIG_HID_TWINHAN=3Dy
CONFIG_HID_KENSINGTON=3Dy
CONFIG_HID_LOGITECH=3Dy
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_HID_MICROSOFT=3Dy
# CONFIG_HID_MOSART is not set
CONFIG_HID_MONTEREY=3Dy
CONFIG_HID_NTRIG=3Dy
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=3Dy
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=3Dy
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_KONE is not set
CONFIG_HID_SAMSUNG=3Dy
CONFIG_HID_SONY=3Dy
# CONFIG_HID_STANTUM is not set
CONFIG_HID_SUNPLUS=3Dy
CONFIG_HID_GREENASIA=3Dy
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=3Dy
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=3Dy
CONFIG_HID_THRUSTMASTER=3Dy
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_ZEROPLUS=3Dy
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=3Dy
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB=3Dy
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_MON=3Dy
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=3Dy
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=3Dy
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=3Dy
CONFIG_USB_UHCI_HCD=3Dy
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=3Dy
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=3Dy
CONFIG_USB_SERIAL_CONSOLE=3Dy
# CONFIG_USB_EZUSB is not set
CONFIG_USB_SERIAL_GENERIC=3Dy
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=3Dy
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=3Dy
CONFIG_USB_SERIAL_OPTION=3Dy
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_ZIO is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=3Dy
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=3Dy
CONFIG_INTEL_IOATDMA=3Dy
CONFIG_TIMB_DMA=3Dy
CONFIG_DMA_ENGINE=3Dy

#
# DMA Clients
#
CONFIG_NET_DMA=3Dy
CONFIG_ASYNC_TX_DMA=3Dy
# CONFIG_DMATEST is not set
CONFIG_DCA=3Dy
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=3Dy
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=3Dy
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=3Dy
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=3Dy
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=3Dy
CONFIG_EXT4_FS_XATTR=3Dy
CONFIG_EXT4_FS_POSIX_ACL=3Dy
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=3Dy
CONFIG_JBD2=3Dy
CONFIG_FS_MBCACHE=3Dy
CONFIG_REISERFS_FS=3Dy
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=3Dy
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=3Dy
CONFIG_XFS_FS=3Dy
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=3Dy
CONFIG_FSNOTIFY=3Dy
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
CONFIG_QUOTA=3Dy
CONFIG_QUOTA_NETLINK_INTERFACE=3Dy
CONFIG_PRINT_QUOTA_WARNING=3Dy
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=3Dy
CONFIG_QFMT_V1=3Dy
CONFIG_QFMT_V2=3Dy
CONFIG_QUOTACTL=3Dy
CONFIG_QUOTACTL_COMPAT=3Dy
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=3Dy
CONFIG_CUSE=3Dy

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dy
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_UDF_FS=3Dy
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dy
CONFIG_MSDOS_FS=3Dy
CONFIG_VFAT_FS=3Dy
CONFIG_FAT_DEFAULT_CODEPAGE=3D437
CONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-1"
CONFIG_NTFS_FS=3Dy
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=3Dy
CONFIG_PROC_PAGE_MONITOR=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=3Dy
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=3Dy
CONFIG_NFS_FS=3Dy
CONFIG_NFS_V3=3Dy
CONFIG_NFS_V3_ACL=3Dy
CONFIG_NFS_V4=3Dy
# CONFIG_NFS_V4_1 is not set
CONFIG_NFSD=3Dy
CONFIG_NFSD_V2_ACL=3Dy
CONFIG_NFSD_V3=3Dy
CONFIG_NFSD_V3_ACL=3Dy
CONFIG_NFSD_V4=3Dy
CONFIG_LOCKD=3Dy
CONFIG_LOCKD_V4=3Dy
CONFIG_EXPORTFS=3Dy
CONFIG_NFS_ACL_SUPPORT=3Dy
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dy
CONFIG_SUNRPC_GSS=3Dy
CONFIG_RPCSEC_GSS_KRB5=3Dy
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=3Dy
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"iso8859-1"
CONFIG_NLS_CODEPAGE_437=3Dy
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=3Dy
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=3D1024
CONFIG_MAGIC_SYSRQ=3Dy
CONFIG_STRIP_ASM_SYMS=3Dy
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=3Dy
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=3Dy
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=3Dy
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=3Dy
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_FUNCTION_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=3Dy
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=3Dy
CONFIG_HAVE_DYNAMIC_FTRACE=3Dy
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=3Dy
CONFIG_HAVE_SYSCALL_TRACEPOINTS=3Dy
CONFIG_RING_BUFFER=3Dy
CONFIG_RING_BUFFER_ALLOW_SWAP=3Dy
CONFIG_TRACING_SUPPORT=3Dy
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=3Dy
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=3Dy
# CONFIG_KMEMCHECK is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=3Dy
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=3Dy
CONFIG_IO_DELAY_TYPE_0X80=3D0
CONFIG_IO_DELAY_TYPE_0XED=3D1
CONFIG_IO_DELAY_TYPE_UDELAY=3D2
CONFIG_IO_DELAY_TYPE_NONE=3D3
CONFIG_IO_DELAY_0X80=3Dy
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=3D0
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
CONFIG_DEFAULT_SECURITY_DAC=3Dy
CONFIG_DEFAULT_SECURITY=3D""
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=3Dy
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=3Dy
CONFIG_CRYPTO=3Dy

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_ALGAPI2=3Dy
CONFIG_CRYPTO_AEAD2=3Dy
CONFIG_CRYPTO_BLKCIPHER=3Dy
CONFIG_CRYPTO_BLKCIPHER2=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_HASH2=3Dy
CONFIG_CRYPTO_RNG2=3Dy
CONFIG_CRYPTO_PCOMP=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
CONFIG_CRYPTO_MANAGER2=3Dy
# CONFIG_CRYPTO_MANAGER_TESTS is not set
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=3Dy
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=3Dy
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=3Dy
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=3Dy
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=3Dy
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=3Dy
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=3Dy
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=3Dy
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=3Dy
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=3Dy
CONFIG_GENERIC_FIND_FIRST_BIT=3Dy
CONFIG_GENERIC_FIND_NEXT_BIT=3Dy
CONFIG_GENERIC_FIND_LAST_BIT=3Dy
CONFIG_CRC_CCITT=3Dy
CONFIG_CRC16=3Dy
CONFIG_CRC_T10DIF=3Dy
CONFIG_CRC_ITU_T=3Dy
CONFIG_CRC32=3Dy
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=3Dy
CONFIG_ZLIB_INFLATE=3Dy
CONFIG_ZLIB_DEFLATE=3Dy
CONFIG_TEXTSEARCH=3Dy
CONFIG_TEXTSEARCH_KMP=3Dy
CONFIG_TEXTSEARCH_BM=3Dy
CONFIG_TEXTSEARCH_FSM=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_NLATTR=3Dy


Kernel 3.0.23 config:
#
# Automatically generated make config: don't edit
# Linux/x86_64 3.0.23-core2-x64-ng11 Kernel Configuration
#
CONFIG_64BIT=3Dy
# CONFIG_X86_32 is not set
CONFIG_X86_64=3Dy
CONFIG_X86=3Dy
CONFIG_INSTRUCTION_DECODER=3Dy
CONFIG_OUTPUT_FORMAT=3D"elf64-x86-64"
CONFIG_ARCH_DEFCONFIG=3D"arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=3Dy
CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=3Dy
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_LATENCYTOP_SUPPORT=3Dy
CONFIG_MMU=3Dy
CONFIG_ZONE_DMA=3Dy
CONFIG_NEED_DMA_MAP_STATE=3Dy
CONFIG_NEED_SG_DMA_LENGTH=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=3Dy
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
CONFIG_GENERIC_TIME_VSYSCALL=3Dy
CONFIG_ARCH_HAS_CPU_RELAX=3Dy
CONFIG_ARCH_HAS_DEFAULT_IDLE=3Dy
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=3Dy
CONFIG_HAVE_SETUP_PER_CPU_AREA=3Dy
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=3Dy
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=3Dy
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=3Dy
CONFIG_ARCH_HIBERNATION_POSSIBLE=3Dy
CONFIG_ARCH_SUSPEND_POSSIBLE=3Dy
CONFIG_ZONE_DMA32=3Dy
CONFIG_ARCH_POPULATES_NODE_MAP=3Dy
CONFIG_AUDIT_ARCH=3Dy
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=3Dy
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=3Dy
CONFIG_HAVE_INTEL_TXT=3Dy
CONFIG_X86_64_SMP=3Dy
CONFIG_X86_HT=3Dy
CONFIG_ARCH_HWEIGHT_CFLAGS=3D"-fcall-saved-rdi -fcall-saved-rsi
-fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9
-fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=3Dy
CONFIG_IRQ_WORK=3Dy

#
# General setup
#
CONFIG_EXPERIMENTAL=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32
CONFIG_CROSS_COMPILE=3D""
CONFIG_LOCALVERSION=3D""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=3Dy
CONFIG_HAVE_KERNEL_BZIP2=3Dy
CONFIG_HAVE_KERNEL_LZMA=3Dy
CONFIG_HAVE_KERNEL_XZ=3Dy
CONFIG_HAVE_KERNEL_LZO=3Dy
CONFIG_KERNEL_GZIP=3Dy
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME=3D"(none)"
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_SYSVIPC_SYSCTL=3Dy
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=3Dy
CONFIG_BSD_PROCESS_ACCT_V3=3Dy
CONFIG_FHANDLE=3Dy
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=3Dy

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_HAVE_SPARSE_IRQ=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_GENERIC_IRQ_SHOW=3Dy
CONFIG_GENERIC_PENDING_IRQ=3Dy
CONFIG_IRQ_FORCED_THREADING=3Dy
# CONFIG_SPARSE_IRQ is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=3Dy
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=3D32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=3Dy
CONFIG_IKCONFIG_PROC=3Dy
CONFIG_LOG_BUF_SHIFT=3D15
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=3Dy
CONFIG_CGROUPS=3Dy
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=3Dy
CONFIG_CGROUP_DEVICE=3Dy
CONFIG_CPUSETS=3Dy
CONFIG_PROC_PID_CPUSET=3Dy
CONFIG_CGROUP_CPUACCT=3Dy
CONFIG_RESOURCE_COUNTERS=3Dy
CONFIG_CGROUP_MEM_RES_CTLR=3Dy
# CONFIG_CGROUP_MEM_RES_CTLR_SWAP is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=3Dy
CONFIG_FAIR_GROUP_SCHED=3Dy
CONFIG_RT_GROUP_SCHED=3Dy
CONFIG_BLK_CGROUP=3Dy
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_NAMESPACES=3Dy
CONFIG_UTS_NS=3Dy
CONFIG_IPC_NS=3Dy
CONFIG_USER_NS=3Dy
CONFIG_PID_NS=3Dy
CONFIG_NET_NS=3Dy
CONFIG_SCHED_AUTOGROUP=3Dy
CONFIG_MM_OWNER=3Dy
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=3Dy
CONFIG_ANON_INODES=3Dy
# CONFIG_EXPERT is not set
CONFIG_UID16=3Dy
CONFIG_SYSCTL_SYSCALL=3Dy
CONFIG_KALLSYMS=3Dy
# CONFIG_KALLSYMS_ALL is not set
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
CONFIG_PCSPKR_PLATFORM=3Dy
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_TIMERFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_AIO=3Dy
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=3Dy

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=3Dy
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_PCI_QUIRKS=3Dy
CONFIG_SLUB_DEBUG=3Dy
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=3Dy
CONFIG_PROFILING=3Dy
CONFIG_OPROFILE=3Dy
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=3Dy
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=3Dy
CONFIG_HAVE_IOREMAP_PROT=3Dy
CONFIG_HAVE_KPROBES=3Dy
CONFIG_HAVE_KRETPROBES=3Dy
CONFIG_HAVE_OPTPROBES=3Dy
CONFIG_HAVE_ARCH_TRACEHOOK=3Dy
CONFIG_HAVE_DMA_ATTRS=3Dy
CONFIG_USE_GENERIC_SMP_HELPERS=3Dy
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=3Dy
CONFIG_HAVE_DMA_API_DEBUG=3Dy
CONFIG_HAVE_HW_BREAKPOINT=3Dy
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=3Dy
CONFIG_HAVE_USER_RETURN_NOTIFIER=3Dy
CONFIG_HAVE_PERF_EVENTS_NMI=3Dy
CONFIG_HAVE_ARCH_JUMP_LABEL=3Dy

#
# GCOV-based kernel profiling
#
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=3Dy
CONFIG_RT_MUTEXES=3Dy
CONFIG_BASE_SMALL=3D0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=3Dy
CONFIG_BLOCK=3Dy
CONFIG_BLK_DEV_BSG=3Dy
CONFIG_BLK_DEV_INTEGRITY=3Dy
# CONFIG_BLK_DEV_THROTTLING is not set
CONFIG_BLOCK_COMPAT=3Dy

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
CONFIG_CFQ_GROUP_IOSCHED=3Dy
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=3Dy
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"cfq"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_INLINE_SPIN_UNLOCK=3Dy
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=3Dy
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=3Dy
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=3Dy
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=3Dy
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=3Dy
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=3Dy
CONFIG_FREEZER=3Dy

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=3Dy
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy
CONFIG_SMP=3Dy
CONFIG_X86_MPPARSE=3Dy
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=3Dy
CONFIG_SCHED_OMIT_FRAME_POINTER=3Dy
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=3Dy
CONFIG_MEMTEST=3Dy
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=3Dy
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=3D6
CONFIG_X86_CMPXCHG=3Dy
CONFIG_CMPXCHG_LOCAL=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D6
CONFIG_X86_XADD=3Dy
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_INTEL_USERCOPY=3Dy
CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
CONFIG_X86_P6_NOP=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMPXCHG64=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_FAMILY=3D64
CONFIG_X86_DEBUGCTLMSR=3Dy
CONFIG_CPU_SUP_INTEL=3Dy
CONFIG_CPU_SUP_AMD=3Dy
CONFIG_CPU_SUP_CENTAUR=3Dy
CONFIG_HPET_TIMER=3Dy
CONFIG_HPET_EMULATE_RTC=3Dy
CONFIG_DMI=3Dy
CONFIG_GART_IOMMU=3Dy
# CONFIG_CALGARY_IOMMU is not set
CONFIG_AMD_IOMMU=3Dy
# CONFIG_AMD_IOMMU_STATS is not set
CONFIG_SWIOTLB=3Dy
CONFIG_IOMMU_HELPER=3Dy
CONFIG_IOMMU_API=3Dy
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=3D8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=3Dy
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_PREEMPT_NONE=3Dy
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=3Dy
CONFIG_X86_IO_APIC=3Dy
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=3Dy
CONFIG_X86_MCE_INTEL=3Dy
CONFIG_X86_MCE_AMD=3Dy
CONFIG_X86_MCE_THRESHOLD=3Dy
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=3Dy
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=3Dy
CONFIG_ARCH_DMA_ADDR_T_64BIT=3Dy
CONFIG_DIRECT_GBPAGES=3Dy
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_ARCH_SPARSEMEM_DEFAULT=3Dy
CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
CONFIG_ILLEGAL_POINTER_VALUE=3D0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=3Dy
CONFIG_SPARSEMEM_MANUAL=3Dy
CONFIG_SPARSEMEM=3Dy
CONFIG_HAVE_MEMORY_PRESENT=3Dy
CONFIG_SPARSEMEM_EXTREME=3Dy
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=3Dy
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=3Dy
CONFIG_SPARSEMEM_VMEMMAP=3Dy
CONFIG_HAVE_MEMBLOCK=3Dy
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=3Dy
CONFIG_SPLIT_PTLOCK_CPUS=3D4
CONFIG_COMPACTION=3Dy
CONFIG_MIGRATION=3Dy
CONFIG_PHYS_ADDR_T_64BIT=3Dy
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_BOUNCE=3Dy
CONFIG_VIRT_TO_BUS=3Dy
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=3D4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=3Dy
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=3Dy
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=3Dy
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=3D64
CONFIG_MTRR=3Dy
CONFIG_MTRR_SANITIZER=3Dy
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=3D0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=3D1
CONFIG_X86_PAT=3Dy
CONFIG_ARCH_USES_PG_UNCACHED=3Dy
# CONFIG_EFI is not set
CONFIG_SECCOMP=3Dy
CONFIG_CC_STACKPROTECTOR=3Dy
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=3Dy
CONFIG_HZ=3D1000
CONFIG_SCHED_HRTICK=3Dy
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=3D0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=3D0x1000000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=3Dy
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=3Dy
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=3Dy
CONFIG_ACPI_BATTERY=3Dy
CONFIG_ACPI_BUTTON=3Dy
CONFIG_ACPI_FAN=3Dy
CONFIG_ACPI_DOCK=3Dy
CONFIG_ACPI_PROCESSOR=3Dy
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=3Dy
CONFIG_ACPI_CUSTOM_DSDT_FILE=3D""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=3Dy
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=3Dy
CONFIG_CPU_IDLE_GOV_LADDER=3Dy
CONFIG_INTEL_IDLE=3Dy

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=3Dy
CONFIG_I7300_IDLE=3Dy

#
# Bus options (PCI etc.)
#
CONFIG_PCI=3Dy
CONFIG_PCI_DIRECT=3Dy
CONFIG_PCI_MMCONFIG=3Dy
CONFIG_PCI_DOMAINS=3Dy
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_DMAR=3Dy
CONFIG_DMAR_DEFAULT_ON=3Dy
CONFIG_DMAR_FLOPPY_WA=3Dy
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=3Dy
CONFIG_PCIEAER=3Dy
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=3Dy
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=3Dy
CONFIG_PCI_MSI=3Dy
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=3Dy
CONFIG_PCI_IOV=3Dy
CONFIG_PCI_IOAPIC=3Dy
CONFIG_PCI_LABEL=3Dy
CONFIG_ISA_DMA_API=3Dy
CONFIG_AMD_NB=3Dy
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_COMPAT_BINFMT_ELF=3Dy
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=3Dy
CONFIG_IA32_EMULATION=3Dy
CONFIG_IA32_AOUT=3Dy
CONFIG_COMPAT=3Dy
CONFIG_COMPAT_FOR_U64_ALIGNMENT=3Dy
CONFIG_SYSVIPC_COMPAT=3Dy
CONFIG_KEYS_COMPAT=3Dy
CONFIG_HAVE_TEXT_POKE_SMP=3Dy
CONFIG_NET=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dy
CONFIG_UNIX=3Dy
# CONFIG_NET_KEY is not set
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
CONFIG_IP_ADVANCED_ROUTER=3Dy
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=3Dy
CONFIG_IP_ROUTE_MULTIPATH=3Dy
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_ROUTE_CLASSID=3Dy
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=3Dy
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=3Dy
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=3Dy
CONFIG_IP_PIMSM_V2=3Dy
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=3Dy
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=3Dy
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=3Dy
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=3Dy
CONFIG_TCP_CONG_BIC=3Dy
CONFIG_TCP_CONG_CUBIC=3Dy
CONFIG_TCP_CONG_WESTWOOD=3Dy
CONFIG_TCP_CONG_HTCP=3Dy
CONFIG_TCP_CONG_HSTCP=3Dy
CONFIG_TCP_CONG_HYBLA=3Dy
CONFIG_TCP_CONG_VEGAS=3Dy
CONFIG_TCP_CONG_SCALABLE=3Dy
CONFIG_TCP_CONG_LP=3Dy
CONFIG_TCP_CONG_VENO=3Dy
CONFIG_TCP_CONG_YEAH=3Dy
CONFIG_TCP_CONG_ILLINOIS=3Dy
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=3Dy
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG=3D"cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=3Dy
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=3Dy
CONFIG_BRIDGE_NETFILTER=3Dy

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=3Dy
CONFIG_NETFILTER_NETLINK_QUEUE=3Dy
CONFIG_NETFILTER_NETLINK_LOG=3Dy
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_TPROXY=3Dy
CONFIG_NETFILTER_XTABLES=3Dy

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=3Dy
CONFIG_NETFILTER_XT_SET=3Dy

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=3Dy
CONFIG_NETFILTER_XT_TARGET_DSCP=3Dy
CONFIG_NETFILTER_XT_TARGET_HL=3Dy
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
CONFIG_NETFILTER_XT_TARGET_IMQ=3Dy
CONFIG_NETFILTER_XT_TARGET_MARK=3Dy
CONFIG_NETFILTER_XT_TARGET_NFLOG=3Dy
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=3Dy
CONFIG_NETFILTER_XT_TARGET_RATEEST=3Dy
CONFIG_NETFILTER_XT_TARGET_TEE=3Dy
CONFIG_NETFILTER_XT_TARGET_TPROXY=3Dy
CONFIG_NETFILTER_XT_TARGET_TRACE=3Dy
CONFIG_NETFILTER_XT_TARGET_TCPMSS=3Dy
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=3Dy

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=3Dy
CONFIG_NETFILTER_XT_MATCH_COMMENT=3Dy
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=3Dy
CONFIG_NETFILTER_XT_MATCH_DSCP=3Dy
CONFIG_NETFILTER_XT_MATCH_ESP=3Dy
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=3Dy
CONFIG_NETFILTER_XT_MATCH_HL=3Dy
CONFIG_NETFILTER_XT_MATCH_IPRANGE=3Dy
CONFIG_NETFILTER_XT_MATCH_LENGTH=3Dy
CONFIG_NETFILTER_XT_MATCH_LIMIT=3Dy
CONFIG_NETFILTER_XT_MATCH_MAC=3Dy
CONFIG_NETFILTER_XT_MATCH_MARK=3Dy
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=3Dy
CONFIG_NETFILTER_XT_MATCH_OSF=3Dy
CONFIG_NETFILTER_XT_MATCH_OWNER=3Dy
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=3Dy
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=3Dy
CONFIG_NETFILTER_XT_MATCH_QUOTA=3Dy
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
CONFIG_NETFILTER_XT_MATCH_REALM=3Dy
CONFIG_NETFILTER_XT_MATCH_RECENT=3Dy
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_SOCKET is not set
CONFIG_NETFILTER_XT_MATCH_STATISTIC=3Dy
CONFIG_NETFILTER_XT_MATCH_STRING=3Dy
CONFIG_NETFILTER_XT_MATCH_TCPMSS=3Dy
CONFIG_NETFILTER_XT_MATCH_TIME=3Dy
CONFIG_NETFILTER_XT_MATCH_U32=3Dy
CONFIG_IP_SET=3Dy
CONFIG_IP_SET_MAX=3D256
CONFIG_IP_SET_BITMAP_IP=3Dy
CONFIG_IP_SET_BITMAP_IPMAC=3Dy
CONFIG_IP_SET_BITMAP_PORT=3Dy
CONFIG_IP_SET_HASH_IP=3Dy
CONFIG_IP_SET_HASH_IPPORT=3Dy
CONFIG_IP_SET_HASH_IPPORTIP=3Dy
CONFIG_IP_SET_HASH_IPPORTNET=3Dy
CONFIG_IP_SET_HASH_NET=3Dy
CONFIG_IP_SET_HASH_NETPORT=3Dy
CONFIG_IP_SET_LIST_SET=3Dy
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=3Dy
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=3Dy
CONFIG_IP_NF_MATCH_AH=3Dy
CONFIG_IP_NF_MATCH_ECN=3Dy
CONFIG_IP_NF_MATCH_TTL=3Dy
CONFIG_IP_NF_FILTER=3Dy
CONFIG_IP_NF_TARGET_REJECT=3Dy
CONFIG_IP_NF_TARGET_LOG=3Dy
CONFIG_IP_NF_TARGET_ULOG=3Dy
CONFIG_IP_NF_MANGLE=3Dy
CONFIG_IP_NF_TARGET_ECN=3Dy
CONFIG_IP_NF_TARGET_TTL=3Dy
CONFIG_IP_NF_RAW=3Dy
CONFIG_IP_NF_ARPTABLES=3Dy
CONFIG_IP_NF_ARPFILTER=3Dy
CONFIG_IP_NF_ARP_MANGLE=3Dy
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=3Dy
CONFIG_BRIDGE=3Dy
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=3Dy
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=3Dy
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=3Dy

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=3Dy
CONFIG_NET_SCH_HTB=3Dy
CONFIG_NET_SCH_HFSC=3Dy
CONFIG_NET_SCH_PRIO=3Dy
CONFIG_NET_SCH_MULTIQ=3Dy
CONFIG_NET_SCH_RED=3Dy
CONFIG_NET_SCH_SFB=3Dy
CONFIG_NET_SCH_SFQ=3Dy
CONFIG_NET_SCH_TEQL=3Dy
CONFIG_NET_SCH_TBF=3Dy
CONFIG_NET_SCH_GRED=3Dy
CONFIG_NET_SCH_DSMARK=3Dy
CONFIG_NET_SCH_NETEM=3Dy
CONFIG_NET_SCH_DRR=3Dy
CONFIG_NET_SCH_MQPRIO=3Dy
CONFIG_NET_SCH_CHOKE=3Dy
CONFIG_NET_SCH_QFQ=3Dy
CONFIG_NET_SCH_INGRESS=3Dy

#
# Classification
#
CONFIG_NET_CLS=3Dy
CONFIG_NET_CLS_BASIC=3Dy
CONFIG_NET_CLS_TCINDEX=3Dy
CONFIG_NET_CLS_ROUTE4=3Dy
CONFIG_NET_CLS_FW=3Dy
CONFIG_NET_CLS_U32=3Dy
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=3Dy
CONFIG_NET_CLS_RSVP=3Dy
CONFIG_NET_CLS_RSVP6=3Dy
CONFIG_NET_CLS_FLOW=3Dy
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=3Dy
CONFIG_NET_EMATCH_STACK=3D32
CONFIG_NET_EMATCH_CMP=3Dy
CONFIG_NET_EMATCH_NBYTE=3Dy
CONFIG_NET_EMATCH_U32=3Dy
CONFIG_NET_EMATCH_META=3Dy
CONFIG_NET_EMATCH_TEXT=3Dy
CONFIG_NET_CLS_ACT=3Dy
CONFIG_NET_ACT_POLICE=3Dy
CONFIG_NET_ACT_GACT=3Dy
CONFIG_GACT_PROB=3Dy
CONFIG_NET_ACT_MIRRED=3Dy
CONFIG_NET_ACT_IPT=3Dy
CONFIG_NET_ACT_NAT=3Dy
CONFIG_NET_ACT_PEDIT=3Dy
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=3Dy
# CONFIG_NET_ACT_CSUM is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=3Dy
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=3Dy
# CONFIG_BATMAN_ADV is not set
CONFIG_RPS=3Dy
CONFIG_RFS_ACCEL=3Dy
CONFIG_XPS=3Dy
CONFIG_HAVE_BPF_JIT=3Dy

#
# Network testing
#
CONFIG_NET_PKTGEN=3Dy
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=3Dy
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=3D""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
CONFIG_FW_LOADER=3Dy
CONFIG_FIRMWARE_IN_KERNEL=3Dy
CONFIG_EXTRA_FIRMWARE=3D""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=3Dy
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=3Dy
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=3Dy
CONFIG_PARPORT_PC=3Dy
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=3Dy
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
CONFIG_BLK_CPQ_DA=3Dy
CONFIG_BLK_CPQ_CISS_DA=3Dy
# CONFIG_CISS_SCSI_TAPE is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dy
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=3Dy
CONFIG_IDE=3Dy

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=3Dy
CONFIG_IDE_TIMINGS=3Dy
CONFIG_IDE_ATAPI=3Dy
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=3Dy
CONFIG_IDE_GD_ATA=3Dy
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=3Dy
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=3Dy
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=3Dy
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=3Dy

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=3Dy
CONFIG_IDEPCI_PCIBUS_ORDER=3Dy
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=3Dy
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=3Dy
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=3Dy
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=3Dy
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=3Dy
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=3Dy
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=3Dy

#
# SCSI device support
#
CONFIG_SCSI_MOD=3Dy
CONFIG_RAID_ATTRS=3Dy
CONFIG_SCSI=3Dy
CONFIG_SCSI_DMA=3Dy
CONFIG_SCSI_TGT=3Dy
CONFIG_SCSI_NETLINK=3Dy
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dy
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=3Dy
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=3Dy

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dy
CONFIG_SCSI_FC_ATTRS=3Dy
# CONFIG_SCSI_FC_TGT_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=3Dy
CONFIG_SCSI_SAS_LIBSAS=3Dy
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=3Dy
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=3Dy
CONFIG_SCSI_AACRAID=3Dy
CONFIG_SCSI_AIC7XXX=3Dy
CONFIG_AIC7XXX_CMDS_PER_DEVICE=3D32
CONFIG_AIC7XXX_RESET_DELAY_MS=3D5000
CONFIG_AIC7XXX_DEBUG_ENABLE=3Dy
CONFIG_AIC7XXX_DEBUG_MASK=3D0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=3Dy
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=3Dy
CONFIG_AIC79XX_CMDS_PER_DEVICE=3D32
CONFIG_AIC79XX_RESET_DELAY_MS=3D5000
CONFIG_AIC79XX_DEBUG_ENABLE=3Dy
CONFIG_AIC79XX_DEBUG_MASK=3D0
CONFIG_AIC79XX_REG_PRETTY_PRINT=3Dy
CONFIG_SCSI_AIC94XX=3Dy
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=3Dy
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_DPT_I2O=3Dy
CONFIG_SCSI_ADVANSYS=3Dy
CONFIG_SCSI_ARCMSR=3Dy
# CONFIG_SCSI_ARCMSR_AER is not set
CONFIG_MEGARAID_NEWGEN=3Dy
CONFIG_MEGARAID_MM=3Dy
CONFIG_MEGARAID_MAILBOX=3Dy
CONFIG_MEGARAID_LEGACY=3Dy
CONFIG_MEGARAID_SAS=3Dy
CONFIG_SCSI_MPT2SAS=3Dy
CONFIG_SCSI_MPT2SAS_MAX_SGE=3D128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_HPTIOP=3Dy
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
CONFIG_SCSI_IPS=3Dy
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=3Dy
CONFIG_SCSI_IPR_TRACE=3Dy
CONFIG_SCSI_IPR_DUMP=3Dy
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=3Dy
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=3Dy
CONFIG_SATA_PMP=3Dy

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=3Dy
CONFIG_SATA_AHCI_PLATFORM=3Dy
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=3Dy
CONFIG_SATA_SIL24=3Dy
CONFIG_ATA_SFF=3Dy

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=3Dy

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=3Dy
CONFIG_SATA_MV=3Dy
CONFIG_SATA_NV=3Dy
# CONFIG_SATA_PROMISE is not set
CONFIG_SATA_SIL=3Dy
CONFIG_SATA_SIS=3Dy
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=3Dy
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=3Dy
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=3Dy
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=3Dy
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=3Dy
CONFIG_BLK_DEV_MD=3Dy
CONFIG_MD_AUTODETECT=3Dy
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=3Dy
CONFIG_MD_RAID1=3Dy
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
CONFIG_MD_MULTIPATH=3Dy
# CONFIG_MD_FAULTY is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=3Dy
CONFIG_FUSION_SPI=3Dy
CONFIG_FUSION_FC=3Dy
CONFIG_FUSION_SAS=3Dy
CONFIG_FUSION_MAX_SGE=3D128
CONFIG_FUSION_CTL=3Dy
CONFIG_FUSION_LOGGING=3Dy

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=3Dy
CONFIG_IFB=3Dy
CONFIG_DUMMY=3Dy
CONFIG_BONDING=3Dy
CONFIG_MACVLAN=3Dy
CONFIG_MACVTAP=3Dy
# CONFIG_EQUALIZER is not set
CONFIG_IMQ=3Dy
# CONFIG_IMQ_BEHAVIOR_AA is not set
CONFIG_IMQ_BEHAVIOR_AB=3Dy
# CONFIG_IMQ_BEHAVIOR_BA is not set
# CONFIG_IMQ_BEHAVIOR_BB is not set
CONFIG_IMQ_NUM_DEVS=3D8
CONFIG_TUN=3Dy
CONFIG_VETH=3Dy
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_MII=3Dy
CONFIG_PHYLIB=3Dy

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=3Dy
CONFIG_DAVICOM_PHY=3Dy
CONFIG_QSEMI_PHY=3Dy
CONFIG_LXT_PHY=3Dy
CONFIG_CICADA_PHY=3Dy
CONFIG_VITESSE_PHY=3Dy
CONFIG_SMSC_PHY=3Dy
CONFIG_BROADCOM_PHY=3Dy
CONFIG_ICPLUS_PHY=3Dy
CONFIG_REALTEK_PHY=3Dy
CONFIG_NATIONAL_PHY=3Dy
CONFIG_STE10XP=3Dy
CONFIG_LSI_ET1011C_PHY=3Dy
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=3Dy
CONFIG_MDIO_BITBANG=3Dy
CONFIG_NET_ETHERNET=3Dy
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=3Dy
CONFIG_VORTEX=3Dy
CONFIG_TYPHOON=3Dy
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
CONFIG_NET_TULIP=3Dy
CONFIG_DE2104X=3Dy
CONFIG_DE2104X_DSL=3D0
CONFIG_TULIP=3Dy
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
CONFIG_TULIP_NAPI=3Dy
# CONFIG_TULIP_NAPI_HW_MITIGATION is not set
CONFIG_DE4X5=3Dy
CONFIG_WINBOND_840=3Dy
CONFIG_DM9102=3Dy
CONFIG_ULI526X=3Dy
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=3Dy
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_B44=3Dy
CONFIG_B44_PCI_AUTOSELECT=3Dy
CONFIG_B44_PCICORE_AUTOSELECT=3Dy
CONFIG_B44_PCI=3Dy
CONFIG_FORCEDETH=3Dy
CONFIG_E100=3Dy
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=3Dy
CONFIG_8139TOO_PIO=3Dy
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
CONFIG_SIS900=3Dy
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
CONFIG_VIA_RHINE=3Dy
CONFIG_VIA_RHINE_MMIO=3Dy
# CONFIG_SC92031 is not set
# CONFIG_NET_POCKET is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=3Dy
CONFIG_ACENIC=3Dy
CONFIG_ACENIC_OMIT_TIGON_I=3Dy
CONFIG_DL2K=3Dy
CONFIG_E1000=3Dy
CONFIG_E1000E=3Dy
CONFIG_IP1000=3Dy
CONFIG_IGB=3Dy
CONFIG_IGB_DCA=3Dy
CONFIG_IGBVF=3Dy
CONFIG_NS83820=3Dy
CONFIG_HAMACHI=3Dy
CONFIG_YELLOWFIN=3Dy
CONFIG_R8169=3Dy
CONFIG_SIS190=3Dy
CONFIG_SKGE=3Dy
CONFIG_SKY2=3Dy
CONFIG_VIA_VELOCITY=3Dy
CONFIG_TIGON3=3Dy
CONFIG_BNX2=3Dy
CONFIG_CNIC=3Dy
CONFIG_QLA3XXX=3Dy
CONFIG_ATL1=3Dy
CONFIG_ATL1E=3Dy
CONFIG_ATL1C=3Dy
CONFIG_JME=3Dy
# CONFIG_STMMAC_ETH is not set
# CONFIG_PCH_GBE is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_WAN is not set

#
# CAIF transport drivers
#
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=3Dy
CONFIG_PPP_MULTILINK=3Dy
CONFIG_PPP_FILTER=3Dy
CONFIG_PPP_ASYNC=3Dy
CONFIG_PPP_SYNC_TTY=3Dy
CONFIG_PPP_DEFLATE=3Dy
CONFIG_PPP_BSDCOMP=3Dy
CONFIG_PPP_MPPE=3Dy
CONFIG_PPPOE=3Dy
# CONFIG_SLIP is not set
CONFIG_SLHC=3Dy
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=3Dy
CONFIG_NETCONSOLE_DYNAMIC=3Dy
CONFIG_NETPOLL=3Dy
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=3Dy
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=3Dy
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=3Dy
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
CONFIG_INPUT_MOUSEDEV_PSAUX=3Dy
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=3Dy
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dy
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=3Dy
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_CONSOLE_TRANSLATIONS=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=3Dy
CONFIG_DEVPTS_MULTIPLE_INSTANCES=3Dy
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=3Dy
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=3Dy
CONFIG_SERIAL_8250_PCI=3Dy
CONFIG_SERIAL_8250_PNP=3Dy
CONFIG_SERIAL_8250_NR_UARTS=3D4
CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=3Dy
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_PRINTER=3Dy
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=3Dy
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=3Dy
CONFIG_HW_RANDOM_AMD=3Dy
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=3Dy
CONFIG_RTC=3Dy
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=3Dy
# CONFIG_RAMOOPS is not set
CONFIG_I2C=3Dy
CONFIG_I2C_BOARDINFO=3Dy
CONFIG_I2C_COMPAT=3Dy
CONFIG_I2C_CHARDEV=3Dy
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=3Dy
CONFIG_I2C_SMBUS=3Dy
CONFIG_I2C_ALGOBIT=3Dy
CONFIG_I2C_ALGOPCA=3Dy

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=3Dy
CONFIG_I2C_ALI1563=3Dy
CONFIG_I2C_ALI15X3=3Dy
CONFIG_I2C_AMD756=3Dy
CONFIG_I2C_AMD756_S4882=3Dy
CONFIG_I2C_AMD8111=3Dy
CONFIG_I2C_I801=3Dy
CONFIG_I2C_ISCH=3Dy
CONFIG_I2C_PIIX4=3Dy
CONFIG_I2C_NFORCE2=3Dy
CONFIG_I2C_NFORCE2_S4985=3Dy
CONFIG_I2C_SIS5595=3Dy
CONFIG_I2C_SIS630=3Dy
CONFIG_I2C_SIS96X=3Dy
CONFIG_I2C_VIA=3Dy
CONFIG_I2C_VIAPRO=3Dy

#
# ACPI drivers
#
CONFIG_I2C_SCMI=3Dy

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_INTEL_MID=3Dy
CONFIG_I2C_OCORES=3Dy
CONFIG_I2C_PCA_PLATFORM=3Dy
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=3Dy
CONFIG_I2C_XILINX=3Dy
CONFIG_I2C_EG20T=3Dy

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=3Dy
CONFIG_I2C_PARPORT=3Dy
CONFIG_I2C_PARPORT_LIGHT=3Dy
CONFIG_I2C_TAOS_EVM=3Dy
CONFIG_I2C_TINY_USB=3Dy

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=3Dy
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=3Dy
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_HWMON=3Dy
CONFIG_HWMON_VID=3Dy
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=3Dy
CONFIG_SENSORS_ABITUGURU3=3Dy
CONFIG_SENSORS_AD7414=3Dy
CONFIG_SENSORS_AD7418=3Dy
CONFIG_SENSORS_ADM1021=3Dy
CONFIG_SENSORS_ADM1025=3Dy
CONFIG_SENSORS_ADM1026=3Dy
CONFIG_SENSORS_ADM1029=3Dy
CONFIG_SENSORS_ADM1031=3Dy
CONFIG_SENSORS_ADM9240=3Dy
CONFIG_SENSORS_ADT7411=3Dy
CONFIG_SENSORS_ADT7462=3Dy
CONFIG_SENSORS_ADT7470=3Dy
CONFIG_SENSORS_ADT7475=3Dy
CONFIG_SENSORS_ASC7621=3Dy
CONFIG_SENSORS_K8TEMP=3Dy
CONFIG_SENSORS_K10TEMP=3Dy
CONFIG_SENSORS_FAM15H_POWER=3Dy
CONFIG_SENSORS_ASB100=3Dy
CONFIG_SENSORS_ATXP1=3Dy
CONFIG_SENSORS_DS620=3Dy
CONFIG_SENSORS_DS1621=3Dy
CONFIG_SENSORS_I5K_AMB=3Dy
CONFIG_SENSORS_F71805F=3Dy
CONFIG_SENSORS_F71882FG=3Dy
CONFIG_SENSORS_F75375S=3Dy
CONFIG_SENSORS_FSCHMD=3Dy
CONFIG_SENSORS_G760A=3Dy
CONFIG_SENSORS_GL518SM=3Dy
CONFIG_SENSORS_GL520SM=3Dy
CONFIG_SENSORS_CORETEMP=3Dy
CONFIG_SENSORS_IT87=3Dy
CONFIG_SENSORS_JC42=3Dy
CONFIG_SENSORS_LINEAGE=3Dy
CONFIG_SENSORS_LM63=3Dy
CONFIG_SENSORS_LM73=3Dy
CONFIG_SENSORS_LM75=3Dy
CONFIG_SENSORS_LM77=3Dy
CONFIG_SENSORS_LM78=3Dy
CONFIG_SENSORS_LM80=3Dy
CONFIG_SENSORS_LM83=3Dy
CONFIG_SENSORS_LM85=3Dy
CONFIG_SENSORS_LM87=3Dy
CONFIG_SENSORS_LM90=3Dy
CONFIG_SENSORS_LM92=3Dy
CONFIG_SENSORS_LM93=3Dy
CONFIG_SENSORS_LTC4151=3Dy
CONFIG_SENSORS_LTC4215=3Dy
CONFIG_SENSORS_LTC4245=3Dy
CONFIG_SENSORS_LTC4261=3Dy
CONFIG_SENSORS_LM95241=3Dy
CONFIG_SENSORS_MAX16065=3Dy
CONFIG_SENSORS_MAX1619=3Dy
CONFIG_SENSORS_MAX6639=3Dy
CONFIG_SENSORS_MAX6642=3Dy
CONFIG_SENSORS_MAX6650=3Dy
CONFIG_SENSORS_PC87360=3Dy
CONFIG_SENSORS_PC87427=3Dy
CONFIG_SENSORS_PCF8591=3Dy
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT21=3Dy
CONFIG_SENSORS_SIS5595=3Dy
CONFIG_SENSORS_SMM665=3Dy
CONFIG_SENSORS_DME1737=3Dy
CONFIG_SENSORS_EMC1403=3Dy
CONFIG_SENSORS_EMC2103=3Dy
CONFIG_SENSORS_EMC6W201=3Dy
CONFIG_SENSORS_SMSC47M1=3Dy
CONFIG_SENSORS_SMSC47M192=3Dy
CONFIG_SENSORS_SMSC47B397=3Dy
CONFIG_SENSORS_SCH5627=3Dy
CONFIG_SENSORS_ADS1015=3Dy
CONFIG_SENSORS_ADS7828=3Dy
CONFIG_SENSORS_AMC6821=3Dy
CONFIG_SENSORS_THMC50=3Dy
CONFIG_SENSORS_TMP102=3Dy
CONFIG_SENSORS_TMP401=3Dy
CONFIG_SENSORS_TMP421=3Dy
CONFIG_SENSORS_VIA_CPUTEMP=3Dy
CONFIG_SENSORS_VIA686A=3Dy
CONFIG_SENSORS_VT1211=3Dy
CONFIG_SENSORS_VT8231=3Dy
CONFIG_SENSORS_W83781D=3Dy
CONFIG_SENSORS_W83791D=3Dy
CONFIG_SENSORS_W83792D=3Dy
CONFIG_SENSORS_W83793=3Dy
CONFIG_SENSORS_W83795=3Dy
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=3Dy
CONFIG_SENSORS_W83L786NG=3Dy
CONFIG_SENSORS_W83627HF=3Dy
CONFIG_SENSORS_W83627EHF=3Dy
CONFIG_SENSORS_APPLESMC=3Dy

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=3Dy
CONFIG_SENSORS_ATK0110=3Dy
CONFIG_THERMAL=3Dy
CONFIG_THERMAL_HWMON=3Dy
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=3Dy

#
# Sonics Silicon Backplane
#
CONFIG_SSB=3Dy
CONFIG_SSB_SPROM=3Dy
CONFIG_SSB_PCIHOST_POSSIBLE=3Dy
CONFIG_SSB_PCIHOST=3Dy
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=3Dy
CONFIG_SSB_DRIVER_PCICORE=3Dy
CONFIG_BCMA_POSSIBLE=3Dy

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set
# CONFIG_MFD_SUPPORT is not set
CONFIG_MFD_CORE=3Dy
CONFIG_LPC_SCH=3Dy
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=3Dy
CONFIG_VGA_ARB_MAX_GPUS=3D16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=3Dy
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=3Dy
CONFIG_HID=3Dy
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=3Dy
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=3Dy
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=3Dy
CONFIG_HID_BELKIN=3Dy
CONFIG_HID_CHERRY=3Dy
CONFIG_HID_CHICONY=3Dy
CONFIG_HID_CYPRESS=3Dy
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_EZKEY=3Dy
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=3Dy
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=3Dy
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=3Dy
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWII_FF is not set
CONFIG_HID_MICROSOFT=3Dy
CONFIG_HID_MONTEREY=3Dy
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_ARVO is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_ROCCAT_KONEPLUS is not set
# CONFIG_HID_ROCCAT_KOVAPLUS is not set
# CONFIG_HID_ROCCAT_PYRA is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=3Dy
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB=3Dy
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_MON=3Dy
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=3Dy
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=3Dy
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=3Dy
CONFIG_USB_UHCI_HCD=3Dy
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=3Dy
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=3Dy
CONFIG_USB_SERIAL_CONSOLE=3Dy
# CONFIG_USB_EZUSB is not set
CONFIG_USB_SERIAL_GENERIC=3Dy
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=3Dy
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=3Dy
CONFIG_USB_SERIAL_OPTION=3Dy
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_ZIO is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=3Dy
CONFIG_LEDS_CLASS=3Dy

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
# CONFIG_NFC_DEVICES is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=3Dy
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=3Dy
CONFIG_INTEL_IOATDMA=3Dy
CONFIG_TIMB_DMA=3Dy
CONFIG_PCH_DMA=3Dy
CONFIG_DMA_ENGINE=3Dy

#
# DMA Clients
#
CONFIG_NET_DMA=3Dy
CONFIG_ASYNC_TX_DMA=3Dy
# CONFIG_DMATEST is not set
CONFIG_DCA=3Dy
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=3Dy
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=3Dy
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_SIGMA is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_EXT2_FS=3Dy
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=3Dy
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=3Dy
CONFIG_EXT4_FS_XATTR=3Dy
CONFIG_EXT4_FS_POSIX_ACL=3Dy
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=3Dy
CONFIG_JBD2=3Dy
CONFIG_FS_MBCACHE=3Dy
CONFIG_REISERFS_FS=3Dy
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=3Dy
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=3Dy
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=3Dy
CONFIG_EXPORTFS=3Dy
CONFIG_FILE_LOCKING=3Dy
CONFIG_FSNOTIFY=3Dy
CONFIG_DNOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
CONFIG_FANOTIFY=3Dy
CONFIG_QUOTA=3Dy
CONFIG_QUOTA_NETLINK_INTERFACE=3Dy
CONFIG_PRINT_QUOTA_WARNING=3Dy
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=3Dy
CONFIG_QFMT_V1=3Dy
CONFIG_QFMT_V2=3Dy
CONFIG_QUOTACTL=3Dy
CONFIG_QUOTACTL_COMPAT=3Dy
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=3Dy
CONFIG_CUSE=3Dy

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dy
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_UDF_FS=3Dy
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dy
CONFIG_MSDOS_FS=3Dy
CONFIG_VFAT_FS=3Dy
CONFIG_FAT_DEFAULT_CODEPAGE=3D437
CONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-1"
CONFIG_NTFS_FS=3Dy
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=3Dy
CONFIG_PROC_PAGE_MONITOR=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=3Dy
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=3Dy
CONFIG_NFS_FS=3Dy
CONFIG_NFS_V3=3Dy
CONFIG_NFS_V3_ACL=3Dy
CONFIG_NFS_V4=3Dy
# CONFIG_NFS_V4_1 is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=3Dy
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
CONFIG_NFSD=3Dy
# CONFIG_NFSD_DEPRECATED is not set
CONFIG_NFSD_V2_ACL=3Dy
CONFIG_NFSD_V3=3Dy
CONFIG_NFSD_V3_ACL=3Dy
CONFIG_NFSD_V4=3Dy
CONFIG_LOCKD=3Dy
CONFIG_LOCKD_V4=3Dy
CONFIG_NFS_ACL_SUPPORT=3Dy
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dy
CONFIG_SUNRPC_GSS=3Dy
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=3Dy
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"iso8859-1"
CONFIG_NLS_CODEPAGE_437=3Dy
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=3Dy
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
# CONFIG_PRINTK_TIME is not set
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=3D4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=3D1024
CONFIG_MAGIC_SYSRQ=3Dy
CONFIG_STRIP_ASM_SYMS=3Dy
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=3Dy
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=3Dy
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=3Dy
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=3Dy
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=3D60
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_FUNCTION_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=3Dy
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=3Dy
CONFIG_HAVE_DYNAMIC_FTRACE=3Dy
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=3Dy
CONFIG_HAVE_SYSCALL_TRACEPOINTS=3Dy
CONFIG_HAVE_C_RECORDMCOUNT=3Dy
CONFIG_RING_BUFFER=3Dy
CONFIG_RING_BUFFER_ALLOW_SWAP=3Dy
CONFIG_TRACING_SUPPORT=3Dy
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=3Dy
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=3Dy
# CONFIG_KMEMCHECK is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=3Dy
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=3Dy
CONFIG_IO_DELAY_TYPE_0X80=3D0
CONFIG_IO_DELAY_TYPE_0XED=3D1
CONFIG_IO_DELAY_TYPE_UDELAY=3D2
CONFIG_IO_DELAY_TYPE_NONE=3D3
CONFIG_IO_DELAY_0X80=3Dy
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=3D0
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=3Dy
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=3Dy
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_INTEL_TXT is not set
CONFIG_DEFAULT_SECURITY_DAC=3Dy
CONFIG_DEFAULT_SECURITY=3D""
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=3Dy
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=3Dy
CONFIG_CRYPTO=3Dy

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_ALGAPI2=3Dy
CONFIG_CRYPTO_AEAD2=3Dy
CONFIG_CRYPTO_BLKCIPHER=3Dy
CONFIG_CRYPTO_BLKCIPHER2=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_HASH2=3Dy
CONFIG_CRYPTO_RNG2=3Dy
CONFIG_CRYPTO_PCOMP2=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
CONFIG_CRYPTO_MANAGER2=3Dy
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=3Dy
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=3Dy
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=3Dy
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=3Dy
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=3Dy
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=3Dy
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=3Dy
CONFIG_CRYPTO_MD5=3Dy
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=3Dy
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=3Dy
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=3Dy
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=3Dy
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=3Dy
CONFIG_GENERIC_FIND_FIRST_BIT=3Dy
CONFIG_CRC_CCITT=3Dy
CONFIG_CRC16=3Dy
CONFIG_CRC_T10DIF=3Dy
CONFIG_CRC_ITU_T=3Dy
CONFIG_CRC32=3Dy
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=3Dy
CONFIG_ZLIB_INFLATE=3Dy
CONFIG_ZLIB_DEFLATE=3Dy
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_TEXTSEARCH=3Dy
CONFIG_TEXTSEARCH_KMP=3Dy
CONFIG_TEXTSEARCH_BM=3Dy
CONFIG_TEXTSEARCH_FSM=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_CHECK_SIGNATURE=3Dy
CONFIG_CPU_RMAP=3Dy
CONFIG_NLATTR=3Dy
# CONFIG_AVERAGE is not set


--=20
Andrei Popa
(+4) 0741.57.80.90

--=-yf9Tk2a3JDXMYfKNNJXf
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCDu0w
ggSdMIIDhaADAgECAhA0PekrrCc0/4/LNJT7zHBUMA0GCSqGSIb3DQEBBQUAMG8xCzAJBgNVBAYT
AlNFMRQwEgYDVQQKEwtBZGRUcnVzdCBBQjEmMCQGA1UECxMdQWRkVHJ1c3QgRXh0ZXJuYWwgVFRQ
IE5ldHdvcmsxIjAgBgNVBAMTGUFkZFRydXN0IEV4dGVybmFsIENBIFJvb3QwHhcNMDUwNjA3MDgw
OTEwWhcNMjAwNTMwMTA0ODM4WjCBrjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQH
Ew5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQL
ExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xpZW50
IEF1dGhlbnRpY2F0aW9uIGFuZCBFbWFpbDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
ALI5haTyfatBO2JGN67NwWB1vDll+UoaR6K5zEjMapjVTTUZuaRC5c5J4oovHnzSMQfHTrSDZJ0u
KdWiZMSFvYVRNXmkTmiQexx6pJKoF/KYFfKTzMmkMpW7DE8wvZigC4vlbhuiRvp4vKJvq1lepS/P
ytptqi/rrKGzaqq3Lmc1i3nhHmmI4uZGzaCl6r4LznY6eg6b6vzaJ1s9cx8i5khhxkzzabGoLhu2
1DEgLLyCio6kDqXXiUP8FlqvHXHXEVnauocNr/rz4cLwpMVnjNbWVDreCqS6A3ezZcj9HtN0YqoY
ymiTHqGFfvVHZcv4TVcodNI0/zC27vZiMBSMLOsCAwEAAaOB9DCB8TAfBgNVHSMEGDAWgBStvZh6
NLQm9/rEJlTvA73gJMtUGjAdBgNVHQ4EFgQUiYJnfcSdJnAAS7RQSHzePa4Ebn0wDgYDVR0PAQH/
BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wEQYDVR0gBAowCDAGBgRVHSAAMEQGA1UdHwQ9MDswOaA3
oDWGM2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9BZGRUcnVzdEV4dGVybmFsQ0FSb290LmNybDA1
BggrBgEFBQcBAQQpMCcwJQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5jb20wDQYJ
KoZIhvcNAQEFBQADggEBAAG8nONjKLDzMQHC33vdYqABnSMxD5ySc1NR6h9M+tafxMovZ354Mw90
FrmRh5H1iib6ZHAA2B75CwRiUIeTgdTa9SPbNLuFVrRwNG54gzcehRzFERWSX4cXvaxq/fHC0cyJ
X7F88D5R8jXzfOxgmGs6K+Dv37N9huu1G/Vb7KJ8mBPXAFC50S1z3gN4dOEFhTFey5q5nZTGuZQ3
dXLcRPtn6PD6JR5Sp9ol6UfgoMc8oE6xCjb7d0if75eK+7T+45QUqIO8XC0/0mBxYO7CcYIM6Yg2
49ogtKOgbKqWS7iAjnXKSQf2OxS639wF2Z/b4LLmTaB4JufnLW5/X8YeiBUwggUaMIIEAqADAgEC
AhBtGeqnGU9qMyLmIjJ6qnHeMA0GCSqGSIb3DQEBBQUAMIGuMQswCQYDVQQGEwJVUzELMAkGA1UE
CBMCVVQxFzAVBgNVBAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5l
dHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTE2MDQGA1UEAxMtVVROLVVT
RVJGaXJzdC1DbGllbnQgQXV0aGVudGljYXRpb24gYW5kIEVtYWlsMB4XDTExMDQyODAwMDAwMFoX
DTIwMDUzMDEwNDgzOFowgZMxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0
ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMTkwNwYDVQQD
EzBDT01PRE8gQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCShIRbS1eY1F4vi6ThQMijU1hfZmXxMk73nzJ9VdB4
TFW3QpTg+SdxB8XGaaS5MsTxQBqQzCdWYn8XtXFpruUgG+TLY15gyqJB9mrho/+43x9IbWVDjCou
K2M4d9+xF6zC2oIC1tQyatRnbyATj1w1+uVUgK/YcQodNwoCUFNslR2pEBS0mZVZEjH/CaLSTNxS
297iQAFbSGjdxUq04O0kHzqvcV8H46y/FDuwJXFoPfQP1hdYRhWBPGiLi4MPbXohV+Y0sNsyfuNK
4aVScmQmkU6lkg//4LFg/RpvaFGZY40ai6XMQpubfSJj06mg/M6ekN9EGfRcWzW6FvOnm//BAgMB
AAGjggFLMIIBRzAfBgNVHSMEGDAWgBSJgmd9xJ0mcABLtFBIfN49rgRufTAdBgNVHQ4EFgQUehNO
AHRbxnhjZCfBL+KgW7x5xXswDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEQYD
VR0gBAowCDAGBgRVHSAAMFgGA1UdHwRRME8wTaBLoEmGR2h0dHA6Ly9jcmwudXNlcnRydXN0LmNv
bS9VVE4tVVNFUkZpcnN0LUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kRW1haWwuY3JsMHQGCCsGAQUF
BwEBBGgwZjA9BggrBgEFBQcwAoYxaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VUTkFkZFRydXN0
Q2xpZW50X0NBLmNydDAlBggrBgEFBQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0LmNvbTANBgkq
hkiG9w0BAQUFAAOCAQEAhda+eFdVbTN/RFL+QtUGqAEDgIr7DbL9Sr/2r0FJ9RtaxdKtG3NuPukm
fOZMmMEwKN/L+0I8oSU+CnXW0D05hmbRoZu1TZtvryhsHa/l6nRaqNqxwPF1ei+eupN5yv7ikR5W
dLL4jdPgQ3Ib7Y/9YDkgR/uLrzplSDyYPaUlv73vYOBJ5RbI6z9Dg/Dg7g3B080zX5vQvWBqszv+
+tTJOjwf7Zv/m0kzvkIpOYPuM2kugp1FTahp2oAbHj3SGl18R5mlmwhtEpmG1l1XBxunML5LSUS4
kH7K0Xk467Qz+qA6XSZYnmFVGLQh1ZnV4ENAQjC+6qXnlNKw/vN1+X9u5zCCBSowggQSoAMCAQIC
EQCC1iLWCNlC//08NoDW0yDKMA0GCSqGSIb3DQEBBQUAMIGTMQswCQYDVQQGEwJHQjEbMBkGA1UE
CBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE5MDcGA1UEAxMwQ09NT0RPIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2Vj
dXJlIEVtYWlsIENBMB4XDTExMDczMDAwMDAwMFoXDTEyMDcyOTIzNTk1OVowJTEjMCEGCSqGSIb3
DQEJARYUYW5kcmVpLnBvcGFAaS1uZW8ucm8wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
AQDC7/8Wo7gDAqT2EkXadu9fEj4lW88MRYTy3axwSw8xnKZjAEK7opewFhj+a5VgXwS5yTSfbBl1
8wwSoApW2trvCZeUHJvQ0XTXJvfEzCjz8vJkqUu/3qNBLkxWQGq/7ZIDF7oi8fUi8qUQJutfMl9O
qfjscSAhCsbBy/Z2y3cijVVSkOJSpe7YTfO8FeOEGOR0xf2AiZ2K/4kJHNRB94L6Np7AgzAWaK/I
7kRVjnaR2ToltdvwVEwpCyLAIwdhb/M7HfpiB4pdx3zUagnF3deK+2/DpbqxkBVzIb/Jl9tC8qA5
kqcxtRBqGBQsQyj9ixaAXuxnozgl/hYulf2fcMLRAgMBAAGjggHkMIIB4DAfBgNVHSMEGDAWgBR6
E04AdFvGeGNkJ8Ev4qBbvHnFezAdBgNVHQ4EFgQUNOswJ18cdPpt45Hjk7cuY+8mZIcwDgYDVR0P
AQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwIAYDVR0lBBkwFwYIKwYBBQUHAwQGCysGAQQBsjEBAwUC
MBEGCWCGSAGG+EIBAQQEAwIFIDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATArMCkGCCsGAQUF
BwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBXBgNVHR8EUDBOMEygSqBIhkZodHRw
Oi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9DbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVt
YWlsQ0EuY3JsMIGIBggrBgEFBQcBAQR8MHowUgYIKwYBBQUHMAKGRmh0dHA6Ly9jcnQuY29tb2Rv
Y2EuY29tL0NPTU9ET0NsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAfBgNVHREEGDAWgRRhbmRyZWkucG9w
YUBpLW5lby5ybzANBgkqhkiG9w0BAQUFAAOCAQEAO7mdp0TD7EDtK8g3pBvTLB6RyFeN9kuskL9y
V7LSd3XMRM6nFQXDXY44mTMBKfMqIxzWdO8TNvkuBDeUsRS2XpgoHmaVYXrYOZbtTHsbDjYvOOG4
PtTqF3gvUooC3a7TylM3TdIAm4I3DFKxDDh3uJGh7d+G1tgjC0iCEh/xquZLpj/B3Mahp8QWODWb
u6Nzql/2ar8cz66JGjEjrOcSTB+zKVN6YY8o1JscMYsjKe1g4Dq0kq3NkFpSvgBzerdT7Au5haLY
+vw6WZwhMPjLdWRqd8Lk5vB0PGNOU1HpoQhsE8Wd0dr5t8S3lTnWmlHy4G6+H1XmwSkm8RxHEjAt
DzGCAmEwggJdAgEBMIGpMIGTMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE5MDcGA1UE
AxMwQ09NT0RPIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAgtYi
1gjZQv/9PDaA1tMgyjANBglghkgBZQMEAgMFAKCBiTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0xMjAzMDcwODE2MDlaME8GCSqGSIb3DQEJBDFCBEAfpGi6yvDlYEmq
MVaaKN/IlBXhW3/eNiRKUYTQzMQeCDMR/ukWJa/xwTONFDRHMIf/gHKa9Ecph3vFkGpIZnRmMA0G
CSqGSIb3DQEBAQUABIIBABj+8/3SYKwUlOtvY73YcjG/za2kEAipqxotji97WjpedCZAip+9t/sk
x4Lz02N97wWIJ3XtksWtPGvt9yzR+blwVWH16yU9IJIBwpA9I8RdevIvXucFjP2h07J9rOMgSbh6
jCsIVs8cJ2ZDLXfWvFe1xMsWfbeiy8d0MpS4JedUITfZCtBjwbuDLqTSJ43wMjCZJICb1238PMP7
7PC8kWx3j6uIl2+VpeiJfbglf9qM6Sf8dYq3s1gat3SBXAZcc7kb/9CBUTpz6crOP2AKd296kfg8
aFj2xQGcdk18PgJ/1rQyijPXHO55ObuVOQdSjlLkwpwrg8s5G84hc4uAjn0AAAAAAAA=


--=-yf9Tk2a3JDXMYfKNNJXf--

