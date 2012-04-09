Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2DIR5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:57:52 -0400
Received: from server1.neighborhoods.net ([207.154.13.48]:41905 "EHLO
	server1.neighborhoods.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab2DIR5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:57:50 -0400
Message-ID: <4F83231A.8040005@meetinghouse.net>
Date: Mon, 09 Apr 2012 13:57:46 -0400
From: Miles Fidelman <mfidelman@meetinghouse.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, peter.chubb@nicta.com.au,
        michael.d.labriola@gmail.com
Subject: Re: reboot via bios on X86_64?
References: <4F8302B4.8040901@meetinghouse.net> <20120409155155.GA22974@srcf.ucam.org> <4F831BD0.3010707@meetinghouse.net> <20120409173223.GA25717@srcf.ucam.org>
In-Reply-To: <20120409173223.GA25717@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Mon, Apr 09, 2012 at 01:26:40PM -0400, Miles Fidelman wrote:
>
>> No.  Tried all the combinations - w/ and w/o hypervisor, all the
>> available kernel options.  Seems
>> like the only thing that will reboot this particular hardware/bios
>> combo is via the bios.
> And this is with 3.3? Interesting. What's the exact behaviour you see,
> and what motherboard is this?
>

No.  2.6.32.5  (the one that currently ships with Debian stable).

This is a tower I built up several years ago, mostly as a sandbox - some 
aftermarket motherboard,
don't have the paperwork anymore, and I'd have to pull the machine apart 
to get details off the
board itself.  Phoenix BIOS, somewhat old.

Since this thing sits under my desk, with the reset button close at 
hand, this is more a curiosity
question - not as if this was one of our production servers sitting in a 
remote datacenter (those
reboot just fine).  An itch that wants to be scratched, an opportunity 
to learn a little about obsolete
hardware, but not something really meriting in-depth attention.

Still....
root@sandbox:~# cat /proc/cpuinfo
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 15
model        : 4
model name    : Intel(R) Celeron(R) CPU 2.53GHz
stepping    : 1
cpu MHz        : 2533.528
cache size    : 256 KB
fpu        : yes
fpu_exception    : yes
cpuid level    : 5
wp        : yes
flags        : fpu de tsc msr pae mce cx8 apic sep mtrr mca cmov pat 
clflush acpi mmx fxsr sse sse2 ss ht syscall nx lm constant_tsc up pni 
cid cx16 hypervisor
bogomips    : 5067.05
clflush size    : 64
cache_alignment    : 128
address sizes    : 36 bits physical, 48 bits virtual
power management:

root@sandbox:~# dmidecode
# dmidecode 2.9
SMBIOS 2.2 present.
40 structures occupying 1034 bytes.
Table at 0x000F0800.

Handle 0x0000, DMI type 0, 19 bytes
BIOS Information
     Vendor: Phoenix Technologies, LTD
     Version: 6.00 PG
     Release Date: 09/28/2005
     Address: 0xE0000
     Runtime Size: 128 kB
     ROM Size: 512 kB
     Characteristics:
         ISA is supported
         PCI is supported
         PNP is supported
         APM is supported
         BIOS is upgradeable
         BIOS shadowing is allowed
         ESCD support is available
         Boot from CD is supported
         Selectable boot is supported
         BIOS ROM is socketed
         EDD is supported
         5.25"/360 KB floppy services are supported (int 13h)
         5.25"/1.2 MB floppy services are supported (int 13h)
         3.5"/720 KB floppy services are supported (int 13h)
         3.5"/2.88 MB floppy services are supported (int 13h)
         Print screen service is supported (int 5h)
         8042 keyboard services are supported (int 9h)
         Serial services are supported (int 14h)
         Printer services are supported (int 17h)
         CGA/mono video services are supported (int 10h)
         ACPI is supported
         USB legacy is supported
         AGP is supported
         LS-120 boot is supported
         ATAPI Zip drive boot is supported

Handle 0x0001, DMI type 1, 25 bytes
System Information
     Manufacturer:
     Product Name:
     Version:
     Serial Number:
     UUID: Not Present
     Wake-up Type: Reserved

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
     Manufacturer: Foxconn
     Product Name: 661 7MI
     Version:
     Serial Number: UYDJ54510546

Handle 0x0003, DMI type 3, 13 bytes
Chassis Information
     Manufacturer:
     Type: Desktop
     Lock: Not Present
     Version:
     Serial Number:
     Asset Tag:
     Boot-up State: Unknown
     Power Supply State: Unknown
     Thermal State: Unknown
     Security Status: Unknown

Handle 0x0004, DMI type 4, 32 bytes
Processor Information
     Socket Designation: Socket 775
     Type: Central Processor
     Family: Celeron
     Manufacturer: Intel
     ID: 41 0F 00 00 FF FB EB BF
     Signature: Type 0, Family 15, Model 4, Stepping 1
     Flags:
         FPU (Floating-point unit on-chip)
         VME (Virtual mode extension)
         DE (Debugging extension)
         PSE (Page size extension)
         TSC (Time stamp counter)
         MSR (Model specific registers)
         PAE (Physical address extension)
         MCE (Machine check exception)
         CX8 (CMPXCHG8 instruction supported)
         APIC (On-chip APIC hardware supported)
         SEP (Fast system call)
         MTRR (Memory type range registers)
         PGE (Page global enable)
         MCA (Machine check architecture)
         CMOV (Conditional move instruction supported)
         PAT (Page attribute table)
         PSE-36 (36-bit page size extension)
         CLFSH (CLFLUSH instruction supported)
         DS (Debug store)
         ACPI (ACPI supported)
         MMX (MMX technology supported)
         FXSR (Fast floating-point save and restore)
         SSE (Streaming SIMD extensions)
         SSE2 (Streaming SIMD extensions 2)
         SS (Self-snoop)
         HTT (Hyper-threading technology)
         TM (Thermal monitor supported)
         PBE (Pending break enabled)
     Version: Intel(R) Celeron(R) CPU
     Voltage: 1.3 V
     External Clock: 133 MHz
     Max Speed: 1500 MHz
     Current Speed: 2533 MHz
     Status: Populated, Enabled
     Upgrade: ZIF Socket
     L1 Cache Handle: 0x000A
     L2 Cache Handle: 0x000B
     L3 Cache Handle: No L3 Cache

Handle 0x0005, DMI type 5, 24 bytes
Memory Controller Information
     Error Detecting Method: None
     Error Correcting Capabilities:
         None
     Supported Interleave: One-way Interleave
     Current Interleave: One-way Interleave
     Maximum Memory Module Size: 1024 MB
     Maximum Total Memory Size: 4096 MB
     Supported Speeds:
         Other
     Supported Memory Types:
         DIMM
         SDRAM
     Memory Module Voltage: 3.3 V
     Associated Memory Slots: 4
         0x0006
         0x0007
         0x0008
         0x0009
     Enabled Error Correcting Capabilities:
         None

Handle 0x0006, DMI type 6, 12 bytes
Memory Module Information
     Socket Designation: A0
     Bank Connections: 0 1
     Current Speed: Unknown
     Type: DIMM SDRAM
     Installed Size: 1024 MB (Double-bank Connection)
     Enabled Size: 1024 MB (Double-bank Connection)
     Error Status: OK

Handle 0x0007, DMI type 6, 12 bytes
Memory Module Information
     Socket Designation: A1
     Bank Connections: None
     Current Speed: Unknown
     Type: Unknown
     Installed Size: Not Installed
     Enabled Size: Not Installed
     Error Status: OK

Handle 0x0008, DMI type 6, 12 bytes
Memory Module Information
     Socket Designation: A2
     Bank Connections: None
     Current Speed: Unknown
     Type: Unknown
     Installed Size: Not Installed
     Enabled Size: Not Installed
     Error Status: OK

Handle 0x0009, DMI type 6, 12 bytes
Memory Module Information
     Socket Designation: A3
     Bank Connections: None
     Current Speed: Unknown
     Type: Unknown
     Installed Size: Not Installed
     Enabled Size: Not Installed
     Error Status: OK

Handle 0x000A, DMI type 7, 19 bytes
Cache Information
     Socket Designation: Internal Cache
     Configuration: Enabled, Not Socketed, Level 1
     Operational Mode: Write Back
     Location: Internal
     Installed Size: 32 KB
     Maximum Size: 32 KB
     Supported SRAM Types:
         Synchronous
     Installed SRAM Type: Synchronous
     Speed: Unknown
     Error Correction Type: Unknown
     System Type: Unknown
     Associativity: Unknown

Handle 0x000B, DMI type 7, 19 bytes
Cache Information
     Socket Designation: External Cache
     Configuration: Enabled, Not Socketed, Level 2
     Operational Mode: Write Back
     Location: External
     Installed Size: 256 KB
     Maximum Size: 256 KB
     Supported SRAM Types:
         Synchronous
     Installed SRAM Type: Synchronous
     Speed: Unknown
     Error Correction Type: Unknown
     System Type: Unknown
     Associativity: Unknown

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
     Internal Reference Designator: PRIMARY IDE
     Internal Connector Type: On Board IDE
     External Reference Designator: Not Specified
     External Connector Type: None
     Port Type: Other

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
     Internal Reference Designator: SECONDARY IDE
     Internal Connector Type: On Board IDE
     External Reference Designator: Not Specified
     External Connector Type: None
     Port Type: Other

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
     Internal Reference Designator: FDD
     Internal Connector Type: On Board Floppy
     External Reference Designator: Not Specified
     External Connector Type: None
     Port Type: 8251 FIFO Compatible

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
     Internal Reference Designator: COM1
     Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
     External Reference Designator:
     External Connector Type: DB-9 male
     Port Type: Serial Port 16450 Compatible

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
     Internal Reference Designator: COM2
     Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
     External Reference Designator:
     External Connector Type: DB-9 male
     Port Type: Serial Port 16450 Compatible

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
     Internal Reference Designator: LPT1
     Internal Connector Type: DB-25 female
     External Reference Designator:
     External Connector Type: DB-25 female
     Port Type: Parallel Port ECP/EPP

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
     Internal Reference Designator: Keyboard
     Internal Connector Type: PS/2
     External Reference Designator:
     External Connector Type: PS/2
     Port Type: Keyboard Port

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
     Internal Reference Designator: PS/2 Mouse
     Internal Connector Type: PS/2
     External Reference Designator:
     External Connector Type: PS/2
     Port Type: Mouse Port

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
     Internal Reference Designator: Not Specified
     Internal Connector Type: None
     External Reference Designator: USB0
     External Connector Type: Other
     Port Type: USB

Handle 0x0015, DMI type 9, 13 bytes
System Slot Information
     Designation: PCI0
     Type: 32-bit PCI
     Current Usage: Available
     Length: Long
     ID: 1
     Characteristics:
         5.0 V is provided
         PME signal is supported

Handle 0x0016, DMI type 9, 13 bytes
System Slot Information
     Designation: PCI1
     Type: 32-bit PCI
     Current Usage: In Use
     Length: Long
     ID: 2
     Characteristics:
         5.0 V is provided
         PME signal is supported

Handle 0x0017, DMI type 9, 13 bytes
System Slot Information
     Designation: PCI2
     Type: 32-bit PCI
     Current Usage: Available
     Length: Long
     ID: 3
     Characteristics:
         5.0 V is provided
         PME signal is supported

Handle 0x0018, DMI type 9, 13 bytes
System Slot Information
     Designation: PCI3
     Type: 32-bit PCI
     Current Usage: Available
     Length: Long
     ID: 4
     Characteristics:
         5.0 V is provided
         PME signal is supported

Handle 0x0019, DMI type 9, 13 bytes
System Slot Information
     Designation: AGP
     Type: 32-bit AGP
     Current Usage: In Use
     Length: Long
     ID: 8
     Characteristics:
         5.0 V is provided

Handle 0x001A, DMI type 13, 22 bytes
BIOS Language Information
     Installable Languages: 3
         n|US|iso8859-1
         n|US|iso8859-1
         r|CA|iso8859-1
     Currently Installed Language: n|US|iso8859-1

Handle 0x001B, DMI type 16, 15 bytes
Physical Memory Array
     Location: System Board Or Motherboard
     Use: System Memory
     Error Correction Type: None
     Maximum Capacity: 4 GB
     Error Information Handle: Not Provided
     Number Of Devices: 4

Handle 0x001C, DMI type 17, 21 bytes
Memory Device
     Array Handle: 0x001B
     Error Information Handle: Not Provided
     Total Width: 64 bits
     Data Width: 64 bits
     Size: 1024 MB
     Form Factor: DIMM
     Set: None
     Locator: A0
     Bank Locator: Bank0/1
     Type: SDRAM
     Type Detail: Synchronous

Handle 0x001D, DMI type 17, 21 bytes
Memory Device
     Array Handle: 0x001B
     Error Information Handle: Not Provided
     Total Width: Unknown
     Data Width: Unknown
     Size: No Module Installed
     Form Factor: DIMM
     Set: None
     Locator: A1
     Bank Locator: Bank2/3
     Type: Unknown
     Type Detail: Unknown

Handle 0x001E, DMI type 17, 21 bytes
Memory Device
     Array Handle: 0x001B
     Error Information Handle: Not Provided
     Total Width: Unknown
     Data Width: Unknown
     Size: No Module Installed
     Form Factor: DIMM
     Set: None
     Locator: A2
     Bank Locator: Bank4/5
     Type: Unknown
     Type Detail: Unknown

Handle 0x001F, DMI type 17, 21 bytes
Memory Device
     Array Handle: 0x001B
     Error Information Handle: Not Provided
     Total Width: Unknown
     Data Width: Unknown
     Size: No Module Installed
     Form Factor: DIMM
     Set: None
     Locator: A3
     Bank Locator: Bank6/7
     Type: Unknown
     Type Detail: Unknown

Handle 0x0020, DMI type 19, 15 bytes
Memory Array Mapped Address
     Starting Address: 0x00000000000
     Ending Address: 0x0003FFFFFFF
     Range Size: 1 GB
     Physical Array Handle: 0x001B
     Partition Width: 0

Handle 0x0021, DMI type 20, 19 bytes
Memory Device Mapped Address
     Starting Address: 0x00000000000
     Ending Address: 0x0003FFFFFFF
     Range Size: 1 GB
     Physical Device Handle: 0x001C
     Memory Array Mapped Address Handle: 0x0020
     Partition Row Position: 1

Handle 0x0022, DMI type 20, 19 bytes
Memory Device Mapped Address
     Starting Address: 0x00000000000
     Ending Address: 0x000000003FF
     Range Size: 1 kB
     Physical Device Handle: 0x001D
     Memory Array Mapped Address Handle: 0x0020
     Partition Row Position: 1

Handle 0x0023, DMI type 20, 19 bytes
Memory Device Mapped Address
     Starting Address: 0x00000000000
     Ending Address: 0x000000003FF
     Range Size: 1 kB
     Physical Device Handle: 0x001E
     Memory Array Mapped Address Handle: 0x0020
     Partition Row Position: 1

Handle 0x0024, DMI type 20, 19 bytes
Memory Device Mapped Address
     Starting Address: 0x00000000000
     Ending Address: 0x000000003FF
     Range Size: 1 kB
     Physical Device Handle: 0x001F
     Memory Array Mapped Address Handle: 0x0020
     Partition Row Position: 1

Handle 0x0025, DMI type 32, 11 bytes
System Boot Information
     Status: No errors detected

Handle 0x0026, DMI type 144, 12 bytes
OEM-specific Type
     Header and Data:
         90 0C 26 00 00 01 6C F4 B4 0F 24 01
     Strings:
         SiS630E-MAC

Handle 0x0027, DMI type 127, 4 bytes
End Of Table



root@sandbox:~# cat /proc/interrupts
            CPU0
   1:          8  xen-pirq-ioapic-edge  i8042
   6:          3  xen-pirq-ioapic-edge  floppy
   7:          0  xen-pirq-ioapic-edge  parport0
   8:          0  xen-pirq-ioapic-edge  rtc0
   9:          0  xen-pirq-ioapic-edge  acpi
  12:        220  xen-pirq-ioapic-edge  i8042
  14:      80345  xen-pirq-ioapic-edge  pata_sis
  15:         63  xen-pirq-ioapic-edge  pata_sis
  17:          0  xen-pirq-ioapic-level  sata_sis
  18:     890853  xen-pirq-ioapic-level  SiS SI7012, peth1
  20:          0  xen-pirq-ioapic-level  ohci_hcd:usb2
  21:          0  xen-pirq-ioapic-level  ohci_hcd:usb3
  22:          0  xen-pirq-ioapic-level  ohci_hcd:usb4
  23:          0  xen-pirq-ioapic-level  ehci_hcd:usb1
501:          0   xen-dyn-event     evtchn:xenstored
502:         42   xen-dyn-event     evtchn:xenstored
504:          0  xen-percpu-virq      mce
505:          0  xen-percpu-virq      pcpu
506:         91   xen-dyn-event     xenbus
507:          0  xen-percpu-ipi       callfuncsingle0
508:          0  xen-percpu-virq      debug0
509:          0  xen-percpu-ipi       callfunc0
510:          0  xen-percpu-ipi       resched0
511:    5681642  xen-percpu-virq      timer0
NMI:          0   Non-maskable interrupts
LOC:          0   Local timer interrupts
SPU:          0   Spurious interrupts
PMI:          0   Performance monitoring interrupts
PND:          0   Performance pending work
RES:          0   Rescheduling interrupts
CAL:          0   Function call interrupts
TLB:          0   TLB shootdowns
TRM:          0   Thermal event interrupts
THR:          0   Threshold APIC interrupts
MCE:          0   Machine check exceptions
MCP:       2031   Machine check polls
ERR:          0
MIS:          0

root@sandbox:~# lspci
00:00.0 Host bridge: Silicon Integrated Systems [SiS] 
661FX/M661FX/M661MX Host (rev 11)
00:01.0 PCI bridge: Silicon Integrated Systems [SiS] SiS AGP Port 
(virtual PCI-to-PCI bridge)
00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS964 [MuTIOL 
Media IO] (rev 36)
00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (rev 01)
00:02.7 Multimedia audio controller: Silicon Integrated Systems [SiS] 
AC'97 Sound Controller (rev a0)
00:03.0 USB Controller: Silicon Integrated Systems [SiS] USB 1.1 
Controller (rev 0f)
00:03.1 USB Controller: Silicon Integrated Systems [SiS] USB 1.1 
Controller (rev 0f)
00:03.2 USB Controller: Silicon Integrated Systems [SiS] USB 1.1 
Controller (rev 0f)
00:03.3 USB Controller: Silicon Integrated Systems [SiS] USB 2.0 Controller
00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900 PCI 
Fast Ethernet (rev 90)
00:05.0 IDE interface: Silicon Integrated Systems [SiS] RAID bus 
controller 180 SATA/PATA  [SiS] (rev 01)
00:09.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet 
Pro 100 (rev 10)
01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS] 
661/741/760 PCI/AGP or 662/761Gx PCIE VGA Display Adapter

Miles





-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra


