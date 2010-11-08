Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab0KHUVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 15:21:46 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:33198 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab0KHUVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 15:21:45 -0500
To: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
Cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [E1000-devel] 2.6.36 abrupt total e1000e carrier loss (cured by reboot)
References: <87ocaaszx1.fsf@spindle.srvr.nix>
	<EA929A9653AAE14F841771FB1DE5A136602815A3C7@rrsmsx501.amr.corp.intel.com>
	<87zktsskua.fsf@spindle.srvr.nix>
	<1288837586.2835.3.camel@jbrandeb-mobl2>
	<87wrooi6qu.fsf@spindle.srvr.nix>
	<EA929A9653AAE14F841771FB1DE5A13660283A6815@rrsmsx501.amr.corp.intel.com>
From: Nix <nix@esperi.org.uk>
Emacs: more than just a Lisp interpreter, a text editor as well!
Date: Mon, 08 Nov 2010 20:21:27 +0000
In-Reply-To: <EA929A9653AAE14F841771FB1DE5A13660283A6815@rrsmsx501.amr.corp.intel.com> (Emil S. Tantilov's message of "Mon, 8 Nov 2010 11:11:57 -0700")
Message-ID: <87sjzbin20.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: spindle 1245; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Nov 2010, Emil S. Tantilov verbalised:

> Nix wrote:
>> For the record, cherry-picking
>> ff10e13cd06f3dbe90e9fffc3c2dd2057a116e4b (the periodic
>> phy-crash-and-reset check) atop 2.6.36 seems to have fixed it: at
>> least, the machine has been up for a day now without trouble. This
>> commit doesn't seem to be in Greg's stable-queue yet, but seems like
>> a good candidate. 
>
> This patch should have no effect on your issue if it is indeed ASPM related.

Interesting. I just noticed that it was testing for exactly the same
symptoms as I was observing (registers suddenly filled with 0xff) and
resetting the card, and thought it might help (plus it's easier than
installing an out-of-tree module and I'm lazy so I tried it first).

> The ASPM issue can be intermittent and I have seen systems run for 3-5
> days until the failure occurs, so one day doesn't necessarily rule it
> out.

Oh. Blast. It took an hour last time, so I assumed a day proved
it. Obviously I was just unlucky last time.

Let's see if it dies again :) it's still humming along now, for what
it's worth...

> BTW - what is the exact make/model of your system (dmidecode).

It's a DNUK Netserver G550e. Complete dmidecode attached, even though
you're probably uninterested in 90% of it (as usual, half of it is
unhelpfully blank: I've never actually seen a vendor fill in the DMI
data, not even Dell do it).

# dmidecode 2.10
SMBIOS 2.5 present.
73 structures occupying 3147 bytes.
Table at 0x0009AC00.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: 'V1.01    '
	Release Date: 04/21/2009
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 2048 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
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
	BIOS Revision: 8.15

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: empty
	Product Name: empty
	Version: empty
	Serial Number: empty
	UUID: 00020003-0004-0005-0006-000700080009
	Wake-up Type: Power Switch
	SKU Number: To Be Filled By O.E.M.
	Family: Server

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: TYAN
	Product Name: S7010
	Version: empty
	Serial Number: empty
	Asset Tag: To Be Filled By O.E.M.
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: To Be Filled By O.E.M.
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: empty
	Type: Desktop
	Lock: Not Present
	Version: empty
	Serial Number: empty
	Asset Tag: empty
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0

Handle 0x0004, DMI type 4, 40 bytes
Processor Information
	Socket Designation: CPU 1
	Type: Central Processor
	Family: Xeon
	Manufacturer: Intel            
	ID: A5 06 01 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 26, Stepping 5
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
	Version: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz     
	Voltage: Unknown
	External Clock: 133 MHz
	Max Speed: 2266 MHz
	Current Speed: 2266 MHz
	Status: Populated, Enabled
	Upgrade: Other
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: 0x0007
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Part Number: To Be Filled By O.E.M.
	Core Count: 4
	Core Enabled: 4
	Thread Count: 8
	Characteristics:
		64-bit capable

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1-Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Through
	Location: Internal
	Installed Size: 128 kB
	Maximum Size: 128 kB
	Supported SRAM Types:
		Other
	Installed SRAM Type: Other
	Speed: Unknown
	Error Correction Type: Parity
	System Type: Data
	Associativity: 8-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2-Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Through
	Location: Internal
	Installed Size: 1024 kB
	Maximum Size: 1024 kB
	Supported SRAM Types:
		Other
	Installed SRAM Type: Other
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x0007, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L3-Cache
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 8192 kB
	Maximum Size: 8192 kB
	Supported SRAM Types:
		Other
	Installed SRAM Type: Other
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 16-way Set-associative

Handle 0x0008, DMI type 4, 40 bytes
Processor Information
	Socket Designation: CPU 2
	Type: Central Processor
	Family: Xeon
	Manufacturer:                  
	ID: 00 00 00 00 00 00 00 00
	Signature: Type 0, Family 0, Model 0, Stepping 0
	Flags: None
	Version:                                                     
	Voltage: 3.3 V 2.9 V
	External Clock: Unknown
	Max Speed: 2000 MHz
	Current Speed: Unknown
	Status: Unpopulated
	Upgrade: Other
	L1 Cache Handle: 0x0009
	L2 Cache Handle: 0x000A
	L3 Cache Handle: 0x000B
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Part Number: To Be Filled By O.E.M.
	Characteristics: None

Handle 0x0009, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1-Cache
	Configuration: Disabled, Not Socketed, Level 1
	Operational Mode: Unknown
	Location: Internal
	Installed Size: 0 kB
	Maximum Size: 0 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x000A, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2-Cache
	Configuration: Disabled, Not Socketed, Level 2
	Operational Mode: Unknown
	Location: Internal
	Installed Size: 0 kB
	Maximum Size: 0 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x000B, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L3-Cache
	Configuration: Disabled, Not Socketed, Level 3
	Operational Mode: Unknown
	Location: Internal
	Installed Size: 0 kB
	Maximum Size: 0 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1A1
	Internal Connector Type: None
	External Reference Designator: PS2Mouse
	External Connector Type: PS/2
	Port Type: Mouse Port

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1A1
	Internal Connector Type: None
	External Reference Designator: Keyboard
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2A2
	Internal Connector Type: None
	External Reference Designator: USB1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2A2
	Internal Connector Type: None
	External Reference Designator: USB2
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J4A1
	Internal Connector Type: None
	External Reference Designator: LPT 1
	External Connector Type: DB-25 male
	Port Type: Parallel Port ECP/EPP

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2A1
	Internal Connector Type: None
	External Reference Designator: COM A
	External Connector Type: DB-9 male
	Port Type: Serial Port 16550A Compatible

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J6A1
	Internal Connector Type: None
	External Reference Designator: Audio Mic In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J6A1
	Internal Connector Type: None
	External Reference Designator: Audio Line In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J6B1 - AUX IN
	Internal Connector Type: On Board Sound Input From CD-ROM
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J6B2 - CDIN
	Internal Connector Type: On Board Sound Input From CD-ROM
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J6J2 - PRI IDE
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J6J1 - SEC IDE
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J4J1 - FLOPPY
	Internal Connector Type: On Board Floppy
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J9H1 - FRONT PNL
	Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1B1 - CHASSIS REAR FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2F1 - CPU FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J8B4 - FRONT FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J9G2 - FNT USB
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J6C3 - FP AUD
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J9G1 - CONFIG
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0020, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J8C1 - SCSI LED
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0021, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J9J2 - INTRUDER
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0022, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J9G4 - ITP
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0023, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2H1 - MAIN POWER
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0024, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI1
	Type: 32-bit PCI
	Current Usage: Available
	Length: Short
	ID: 1
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x0025, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIE2
	Type: x4 PCI Express
	Current Usage: Available
	Length: Short
	ID: 2
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x0026, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIE3
	Type: x16 PCI Express
	Current Usage: Available
	Length: Long
	ID: 3
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x0027, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIE4
	Type: x4 PCI Express
	Current Usage: Available
	Length: Short
	ID: 4
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x0028, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIE5
	Type: x16 PCI Express
	Current Usage: Available
	Length: Long
	ID: 5
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x0029, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Enabled
	Description:   To Be Filled By O.E.M.

Handle 0x002A, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 1
		en|US|iso8859-1
	Currently Installed Language: en|US|iso8859-1

Handle 0x002B, DMI type 15, 55 bytes
System Event Log
	Area Length: 1008 bytes
	Header Start Offset: 0x0810
	Data Start Offset: 0x0810
	Access Method: General-purpose non-volatile data functions
	Access Address: 0x0001
	Status: Valid, Not Full
	Change Token: 0x00000000
	Header Format: No Header
	Supported Log Type Descriptors: 13
	Descriptor 1: Single-bit ECC memory error
	Data Format 1: Multiple-event handle
	Descriptor 2: Multi-bit ECC memory error
	Data Format 2: Multiple-event handle
	Descriptor 3: Parity memory error
	Data Format 3: Multiple-event
	Descriptor 4: I/O channel block
	Data Format 4: Multiple-event
	Descriptor 5: POST error
	Data Format 5: POST results bitmap
	Descriptor 6: PCI parity error
	Data Format 6: Multiple-event handle
	Descriptor 7: PCI system error
	Data Format 7: Multiple-event handle
	Descriptor 8: System limit exceeded
	Data Format 8: Multiple-event system management
	Descriptor 9: OEM-specific
	Data Format 9: POST results bitmap
	Descriptor 10: OEM-specific
	Data Format 10: Multiple-event handle
	Descriptor 11: OEM-specific
	Data Format 11: Multiple-event handle
	Descriptor 12: OEM-specific
	Data Format 12: Multiple-event handle
	Descriptor 13: OEM-specific
	Data Format 13: Multiple-event handle

Handle 0x002C, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: Multi-bit ECC
	Maximum Capacity: 96 GB
	Error Information Handle: Not Provided
	Number Of Devices: 12

Handle 0x002D, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Array Handle: 0x002C
	Partition Width: 0

Handle 0x002E, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM0
	Bank Locator: BANK0
	Type: Other
	Type Detail: Other
	Speed: Unknown
	Manufacturer: Manufacturer00
	Serial Number: SerNum00
	Asset Tag: AssetTagNum0
	Part Number: ModulePartNumber00

Handle 0x002F, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x002E
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1
	Interleave Position: Unknown
	Interleaved Data Depth: 2

Handle 0x0030, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM1
	Bank Locator: BANK1
	Type: Other
	Type Detail: Other
	Speed: Unknown
	Manufacturer: Manufacturer01
	Serial Number: SerNum01
	Asset Tag: AssetTagNum1
	Part Number: ModulePartNumber01

Handle 0x0031, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x0030
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1
	Interleave Position: Unknown
	Interleaved Data Depth: 2

Handle 0x0032, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM2
	Bank Locator: BANK2
	Type: Other
	Type Detail: Other
	Speed: Unknown
	Manufacturer: Manufacturer02
	Serial Number: SerNum02
	Asset Tag: AssetTagNum2
	Part Number: ModulePartNumber02

Handle 0x0033, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x0032
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1
	Interleave Position: Unknown
	Interleaved Data Depth: 2

Handle 0x0034, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM3
	Bank Locator: BANK3
	Type: Other
	Type Detail: Other
	Speed: Unknown
	Manufacturer: Manufacturer03
	Serial Number: SerNum03
	Asset Tag: AssetTagNum3
	Part Number: ModulePartNumber03

Handle 0x0035, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x0034
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1
	Interleave Position: Unknown
	Interleaved Data Depth: 2

Handle 0x0036, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM4
	Bank Locator: BANK4
	Type: Other
	Type Detail: Other
	Speed: Unknown
	Manufacturer: Manufacturer04
	Serial Number: SerNum04
	Asset Tag: AssetTagNum4
	Part Number: ModulePartNumber04

Handle 0x0037, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x0036
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1
	Interleave Position: Unknown
	Interleaved Data Depth: 2

Handle 0x0038, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM5
	Bank Locator: BANK5
	Type: Other
	Type Detail: Other
	Speed: Unknown
	Manufacturer: Manufacturer05
	Serial Number: SerNum05
	Asset Tag: AssetTagNum5
	Part Number: ModulePartNumber05

Handle 0x0039, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x0038
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1
	Interleave Position: Unknown
	Interleaved Data Depth: 2

Handle 0x003A, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM6
	Bank Locator: BANK6
	Type: Other
	Type Detail: Other
	Speed: 1067 MHz
	Manufacturer: Manufacturer06
	Serial Number: SerNum06
	Asset Tag: AssetTagNum6
	Part Number: ModulePartNumber06

Handle 0x003B, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x003A
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1
	Interleave Position: Unknown
	Interleaved Data Depth: 2

Handle 0x003C, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM7
	Bank Locator: BANK7
	Type: Other
	Type Detail: Other
	Speed: 1067 MHz
	Manufacturer: Manufacturer07
	Serial Number: SerNum07
	Asset Tag: AssetTagNum7
	Part Number: ModulePartNumber07

Handle 0x003D, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x003C
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1
	Interleave Position: Unknown
	Interleaved Data Depth: 2

Handle 0x003E, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM8
	Bank Locator: BANK8
	Type: Other
	Type Detail: Other
	Speed: 1067 MHz
	Manufacturer: Manufacturer08
	Serial Number: SerNum08
	Asset Tag: AssetTagNum8
	Part Number: ModulePartNumber08

Handle 0x003F, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x003E
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1
	Interleave Position: Unknown
	Interleaved Data Depth: 2

Handle 0x0040, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM9
	Bank Locator: BANK9
	Type: Other
	Type Detail: Other
	Speed: 1067 MHz
	Manufacturer: Manufacturer09
	Serial Number: SerNum09
	Asset Tag: AssetTagNum9
	Part Number: ModulePartNumber09

Handle 0x0041, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x0040
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1
	Interleave Position: Unknown
	Interleaved Data Depth: 2

Handle 0x0042, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM10
	Bank Locator: BANK10
	Type: Other
	Type Detail: Other
	Speed: 1067 MHz
	Manufacturer: Manufacturer10
	Serial Number: SerNum10
	Asset Tag: AssetTagNum10
	Part Number: ModulePartNumber10

Handle 0x0043, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x0042
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1
	Interleave Position: Unknown
	Interleaved Data Depth: 2

Handle 0x0044, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM11
	Bank Locator: BANK11
	Type: Other
	Type Detail: Other
	Speed: 1067 MHz
	Manufacturer: Manufacturer11
	Serial Number: SerNum11
	Asset Tag: AssetTagNum11
	Part Number: ModulePartNumber11

Handle 0x0045, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x0044
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1
	Interleave Position: Unknown
	Interleaved Data Depth: 2

Handle 0x0046, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x0047, DMI type 38, 18 bytes
IPMI Device Information
	Interface Type: KCS (Keyboard Control Style)
	Specification Version: 2.0
	I2C Slave Address: 0x10
	NV Storage Device: Not Present
	Base Address: 0x0000000000000CA8 (I/O)
	Register Spacing: 32-bit Boundaries

Handle 0x0048, DMI type 127, 4 bytes
End Of Table

