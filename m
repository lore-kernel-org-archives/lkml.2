Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab1AEPqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:46:30 -0500
Received: from nm28-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.234]:39406 "HELO
	nm28-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751231Ab1AEPq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:46:28 -0500
X-Yahoo-Newman-Id: 768531.30730.bm@smtp147.mail.mud.yahoo.com
X-Yahoo-SMTP: izt95ZKswBDBT1bN16dPvD5jLHMKn5IFkJA-
X-YMail-OSG: fQlCUdkVM1lOSMdkeR0QScKar0xfVsydJfGIc3clwP0TGxk
 IK932I6ojlK_WFfemmT1dELFl29HsIg4xRdAt36EA7WKnXddyRgP52IpEcV9
 vzi.w_wjdd8GMhTbu0EdEZumbyfr256kBeNuH_fiFrHQktyyx7YlkUu7kjLd
 S9ol9lJEP5njlrjOr6kQ8tUn6rc681_D66RIGQZqsOxAl6_x.mUv8hUAWV25
 cCd8HQZ89UaIX4n4m9DDTPyzQeSkkP2NBW52vd4JOIobr5qclEZzZ__B7CmD
 0bHb8qE0NWOF4pPt.3c0JNwQTlhQZ9pZKmedH53nW7qC8yvJf57xlLGoMlM8
 -
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [Bulk] Re: can't resume from ACPI S3 with TICK_ONESHOT
From: "James C. Georgas" <james.georgas@yahoo.ca>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <20110105120959.GB4927@kryptos.osrc.amd.com>
References: <1294191939.3889.49.camel@Tachyon>
	 <20110105120959.GB4927@kryptos.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 08:46:25 -0700
Message-ID: <1294242385.3650.38.camel@Tachyon>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 13:09 +0100, Borislav Petkov wrote:
> Can you try booting with "nohpet" on the kernel command line?
> 

I updated to 2.6.37; same behaviour. Booting with "nohpet" on the
command line does allow the system to resume.
> ..
> 
> > Linux version 2.6.36.2-s2ram (root@Tachyon) (gcc version 4.4.4 (Gentoo 4.4.4-r2 p1.2, pie-0.4.5) ) #7 PREEMPT Tue Jan 4 17:43:43 MST 2011
> 
> Is that a vanilla kernel from kernel.org or is it a gentoo one with some
> patches ontop?

It's the vanilla kernel. I first saw the problem with the gentoo kernel,
so I switched to vanilla to see if it was because of the patches, but
the problem exists also on the vanilla kernels.
> 
> More questions:
> 
> Can you try the freshly released 2.6.37 to see whether you see different
> results with it.

Done. Same issue, but disabling the HPET timer on the kernel command
line works around it, as cited above.
> 
> Also, are you running the latest BIOS from your chipset vendor? Can you
> send dmidecode and "lspci -v" output too?
> 

As far as I can tell, the BIOS is up to date. At least, I couldn't find
an update on the vendor's website...

lspci -v:

00:00.0 Host bridge: Advanced Micro Devices [AMD] RS880 Host Bridge
	Subsystem: Acer Incorporated [ALI] Device 040d
	Flags: bus master, 66MHz, medium devsel, latency 0
	Capabilities: [c4] HyperTransport: Slave or Primary Interface
	Capabilities: [54] HyperTransport: UnitID Clumping
	Capabilities: [40] HyperTransport: Retry Mode
	Capabilities: [9c] HyperTransport: #1a
	Capabilities: [f8] HyperTransport: #1c

00:01.0 PCI bridge: Acer Incorporated [ALI] Device 9602 (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: d0000000-d01fffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
	Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [b0] Subsystem: Acer Incorporated [ALI] Device 040d

00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 0) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: d0200000-d02fffff
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Root Port (Slot+), MSI 00
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [b0] Subsystem: Acer Incorporated [ALI] Device 040d
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information <?>
	Capabilities: [110] Virtual Channel <?>
	Kernel driver in use: pcieport

00:05.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	Memory behind bridge: d0300000-d03fffff
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Root Port (Slot+), MSI 00
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [b0] Subsystem: Acer Incorporated [ALI] Device 040d
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information <?>
	Capabilities: [110] Virtual Channel <?>
	Kernel driver in use: pcieport

00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode] (prog-if 01 [AHCI 1.0])
	Subsystem: Acer Incorporated [ALI] Device 040d
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 42
	I/O ports at 8440 [size=8]
	I/O ports at 8430 [size=4]
	I/O ports at 8420 [size=8]
	I/O ports at 8410 [size=4]
	I/O ports at 8400 [size=16]
	Memory at d0607c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] MSI: Enable+ Count=1/4 Maskable- 64bit+
	Capabilities: [70] SATA HBA <?>
	Capabilities: [a4] PCI Advanced Features
	Kernel driver in use: ahci

00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Acer Incorporated [ALI] Device 040d
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 18
	Memory at d0404000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Acer Incorporated [ALI] Device 040d
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
	Memory at d0607000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Acer Incorporated [ALI] Device 040d
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 18
	Memory at d0405000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Acer Incorporated [ALI] Device 040d
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
	Memory at d0607400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 41)
	Flags: 66MHz, medium devsel

00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller (rev 40) (prog-if 8a [Master SecP PriP])
	Subsystem: Acer Incorporated [ALI] Device 040d
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 10
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 8450 [size=16]

00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA) (rev 40)
	Subsystem: Acer Incorporated [ALI] Device 040d
	Flags: bus master, slow devsel, latency 64, IRQ 16
	Memory at d0400000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller (rev 40)
	Subsystem: Acer Incorporated [ALI] Device 040d
	Flags: bus master, 66MHz, medium devsel, latency 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])
	Flags: bus master, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=64

00:16.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Acer Incorporated [ALI] Device 040d
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 18
	Memory at d0406000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:16.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Acer Incorporated [ALI] Device 040d
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
	Memory at d0607800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Address Map
	Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
	Flags: fast devsel
	Kernel modules: amd64_edac_mod

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
	Flags: fast devsel
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k10temp
	Kernel modules: k10temp

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Link Control
	Flags: fast devsel

01:05.0 VGA compatible controller: ATI Technologies Inc M880G [Mobility Radeon HD 4200] (prog-if 00 [VGA controller])
	Subsystem: Acer Incorporated [ALI] Device 040d
	Flags: bus master, fast devsel, latency 0, IRQ 18
	Memory at c0000000 (32-bit, prefetchable) [size=256M]
	I/O ports at 9000 [size=256]
	Memory at d0100000 (32-bit, non-prefetchable) [size=64K]
	Memory at d0000000 (32-bit, non-prefetchable) [size=1M]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [50] Power Management version 3
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
	Kernel driver in use: radeon
	Kernel modules: radeon, fglrx

01:05.1 Audio device: ATI Technologies Inc RS880 Audio Device [Radeon HD 4200]
	Subsystem: Acer Incorporated [ALI] Device 040d
	Flags: bus master, fast devsel, latency 0, IRQ 19
	Memory at d0110000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

03:00.0 Ethernet controller: Atheros Communications AR8151 v1.0 Gigabit Ethernet (rev c0)
	Subsystem: Acer Incorporated [ALI] Device 040d
	Flags: bus master, fast devsel, latency 0, IRQ 43
	Memory at d0200000 (64-bit, non-prefetchable) [size=256K]
	I/O ports at a000 [size=128]
	Capabilities: [40] Power Management version 3
	Capabilities: [48] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [58] Express Endpoint, MSI 00
	Capabilities: [6c] Vital Product Data
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [180] Device Serial Number ff-ad-51-f4-00-26-2d-ff
	Kernel driver in use: atl1c
	Kernel modules: atl1c

06:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
	Subsystem: Lite-On Communications Inc Device 6632
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at d0300000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 2
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [60] Express Legacy Endpoint, MSI 00
	Capabilities: [90] MSI-X: Enable- Count=1 Masked-
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: ath9k
	Kernel modules: ath9k


# dmidecode 3.10
SMBIOS 2.6 present.
25 structures occupying 1220 bytes.
Table at 0xAFEC5000.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Phoenix Technologies LTD
	Version: V1.07          
	Release Date: 04/15/2010
	Address: 0xE2640
	Runtime Size: 121280 bytes
	ROM Size: 2048 kB
	Characteristics:
		PCI is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/360 kB floppy services are supported (int 13h)
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		LS-120 boot is supported
		ATAPI Zip drive boot is supported
		BIOS boot specification is supported
		Targeted content distribution is supported

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: Gateway        
	Product Name: LT32                           
	Version: V1.07          
	Serial Number: LUWL802002022BB5A62200        
	UUID: 80C68EF4-5A72-DF11-BE5A-B990B0AF33A4
	Wake-up Type: Power Switch
	SKU Number: Not Specified
	Family: Not Specified

Handle 0x0002, DMI type 2, 17 bytes
Base Board Information
	Manufacturer: Gateway        
	Product Name: LT32                           
	Version: V1.07          
	Serial Number: LUWL802002022BB5A62200        
	Asset Tag: No Asset Tag                    
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: Not Applicable
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 1
		0x0000

Handle 0x0003, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: Gateway        
	Type: Notebook
	Lock: Not Present
	Version: V1.07          
	Serial Number: LUWL802002022BB5A62200        
	Asset Tag: No Asset Tag                    
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00001234
	Height: Unspecified
	Number Of Power Cords: Unspecified
	Contained Elements: 0

Handle 0x0004, DMI type 4, 42 bytes
Processor Information
	Socket Designation: Socket ASB2
	Type: Central Processor
	Family: <OUT OF SPEC>
	Manufacturer: AMD
	ID: 63 0F 10 00 FF FB 8B 07
	Version: New Processor Technology                        
	Voltage: 1.1 V
	External Clock: 200 MHz
	Max Speed: 1700 MHz
	Current Speed: 1700 MHz
	Status: Populated, Enabled
	Upgrade: None
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified
	Core Count: 1
	Core Enabled: 1
	Thread Count: 1
	Characteristics:
		64-bit capable

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1 Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 128 kB
	Maximum Size: 128 kB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: 1 ns
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 2-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 1024 kB
	Maximum Size: 1024 kB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: 1 ns
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 16-way Set-associative

Handle 0x0007, DMI type 9, 17 bytes
System Slot Information
	Designation: MINI PCI1
	Type: 32-bit PCI
	Current Usage: Available
	Length: Other
	ID: 1
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PME signal is supported
	Bus Address: 0000:44:01.0

Handle 0x0008, DMI type 9, 17 bytes
System Slot Information
	Designation: MINI PCI2
	Type: 32-bit PCI
	Current Usage: Available
	Length: Other
	ID: 2
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PME signal is supported
	Bus Address: 0000:44:02.0

Handle 0x0009, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Disabled
	Description: AMD RS880M

Handle 0x000A, DMI type 10, 6 bytes
On Board Device Information
	Type: Sound
	Status: Disabled
	Description: ESS 1869

Handle 0x000B, DMI type 11, 5 bytes
OEM Strings
	String 1:  
	String 2:  
	String 3:  

Handle 0x000C, DMI type 12, 5 bytes
System Configuration Options
	Option 1: J13 1-2 Normal Operation, 2-3 Clear CMOS

Handle 0x000D, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: Single-bit ECC
	Maximum Capacity: 32 GB
	Error Information Handle: Not Provided
	Number Of Devices: 4

Handle 0x000E, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x000D
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 1
	Locator: S1
	Bank Locator: DIMM1
	Type: <OUT OF SPEC>
	Type Detail: Synchronous
	Speed: 533 MHz
	Manufacturer: 80CE            
	Serial Number: 97CC6284
	Asset Tag: 1015
	Part Number: M471B2873EH1-CF8  
	Rank: Unknown

Handle 0x000F, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x000D
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 2
	Locator: S2
	Bank Locator: DIMM2
	Type: <OUT OF SPEC>
	Type Detail: Synchronous
	Speed: 667 MHz
	Manufacturer: 02FE            
	Serial Number: AC0937DA
	Asset Tag: 1017
	Part Number: EBJ21UE8BDS0-DJ-F 
	Rank: Unknown

Handle 0x0010, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000BFFFFFFF
	Range Size: 3 GB
	Physical Array Handle: 0x000D
	Partition Width: 0

Handle 0x0011, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x000E
	Memory Array Mapped Address Handle: 0x0010
	Partition Row Position: 2
	Interleave Position: 1
	Interleaved Data Depth: 6

Handle 0x0012, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00040000000
	Ending Address: 0x000BFFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x000F
	Memory Array Mapped Address Handle: 0x0010
	Partition Row Position: 2
	Interleave Position: 1
	Interleaved Data Depth: 6

Handle 0x0013, DMI type 32, 20 bytes
System Boot Information
	Status: <OUT OF SPEC>

Handle 0x0014, DMI type 170, 78 bytes
OEM-specific Type
	Header and Data:
		AA 4E 14 00 01 00 09 00 7F 00 0F 00 06 00 04 02
		01 00 21 02 01 00 24 02 08 00 41 02 01 00 42 02
		02 00 43 02 04 00 44 02 08 00 45 02 10 00 46 02
		20 00 47 02 40 00 61 02 01 00 62 02 02 00 63 02
		04 00 64 02 08 00 82 02 02 00 83 02 04 00

Handle 0x0015, DMI type 171, 24 bytes
OEM-specific Type
	Header and Data:
		AB 18 15 00 01 02 10 12 97 02 69 19 73 10 05 02
		10 83 43 07 8C 16 2A 00

Handle 0x0016, DMI type 172, 6 bytes
OEM-specific Type
	Header and Data:
		AC 06 16 00 01 00

Handle 0x0017, DMI type 200, 7 bytes
OEM-specific Type
	Header and Data:
		C8 07 17 00 01 02 03
	Strings:
		17C0
		             
		0001

Handle 0x0018, DMI type 127, 4 bytes
End Of Table


> How exactly do you suspend to RAM? Using pm-suspend from pm-utils?
> 

Yes, pm-suspend from the command line, as root. To resume, I can either
push the blinking power button or mash the keyboard.

> That should be it for now.
> 
> Thanks.
> 

Let me know if you need more.

James


