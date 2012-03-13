Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab2CMPof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:44:35 -0400
Received: from dwdmx5.dwd.de ([141.38.3.242]:58175 "EHLO dwdmx5.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab2CMPod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:44:33 -0400
Date: Tue, 13 Mar 2012 15:44:27 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: Shaohua Li <shli@kernel.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "neilb@suse.de" <neilb@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
In-Reply-To: <CANejiEWYCxY_hLwgyN08_cXC64c82irkNPytTjOpYyER7pTGow@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1203131521190.29286@diagnostix.dwd.de>
References: <20120312030412.375458948@fusionio.com> <alpine.LRH.2.02.1203121806120.23719@diagnostix.dwd.de> <4F5EFEB6.4060402@kernel.org> <alpine.LRH.2.02.1203131213480.15848@diagnostix.dwd.de>
 <CANejiEWYCxY_hLwgyN08_cXC64c82irkNPytTjOpYyER7pTGow@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012, Shaohua Li wrote:

> Thanks for testing. This is very wield, the req->__data_len is wrong.
> Is this a clean build?
>
I just downloaded linux-3.3-rc7.tar.bz2 from kernel.org and applied
your patches again. The result is the same.

Am I the only one experiencing these problems?

This is on a fedora 16 system and it is NOT a virtual machine. It only has
3 SSD's and 6 GiB of ram. Below I have added some more information of the
system in case it helps.

Regards,
Holger


lscpu
=====
    Architecture:          x86_64
    CPU op-mode(s):        32-bit, 64-bit
    Byte Order:            Little Endian
    CPU(s):                4
    On-line CPU(s) list:   0-3
    Thread(s) per core:    1
    Core(s) per socket:    4
    Socket(s):             1
    NUMA node(s):          1
    Vendor ID:             GenuineIntel
    CPU family:            6
    Model:                 15
    Stepping:              11
    CPU MHz:               1596.000
    BogoMIPS:              5333.50
    Virtualization:        VT-x
    L1d cache:             32K
    L1i cache:             32K
    L2 cache:              4096K
    NUMA node0 CPU(s):     0-3


lspci
=====
    00:00.0 Host bridge: Intel Corporation 82975X Memory Controller Hub
    00:01.0 PCI bridge: Intel Corporation 82975X PCI Express Root Port
    00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 01)
    00:1c.0 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 1 (rev 01)
    00:1c.5 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI Express Port 6 (rev 01)
    00:1d.0 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 (rev 01)
    00:1d.1 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 (rev 01)
    00:1d.2 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 (rev 01)
    00:1d.3 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 (rev 01)
    00:1d.7 USB Controller: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller (rev 01)
    00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
    00:1f.0 ISA bridge: Intel Corporation 82801GH (ICH7DH) LPC Interface Bridge (rev 01)
    00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 01)
    00:1f.2 SATA controller: Intel Corporation N10/ICH7 Family SATA AHCI Controller (rev 01)
    00:1f.3 SMBus: Intel Corporation N10/ICH 7 Family SMBus Controller (rev 01)
    01:00.0 VGA compatible controller: ATI Technologies Inc RV730XT [Radeon HD 4670]
    01:00.1 Audio device: ATI Technologies Inc RV710/730
    02:00.0 PCI bridge: PLX Technology, Inc. PEX 8114 PCI Express-to-PCI/PCI-X Bridge (rev bc)
    03:04.0 SCSI storage controller: Adaptec ASC-29320ALP U320 (rev 10)
    04:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller
    05:04.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link


hdparm -I /dev/sda
==================
    /dev/sda:

    ATA device, with non-removable media
            Model Number:       OCZ-VERTEX2
            Serial Number:      OCZ-5036916D0T14323M
            Firmware Revision:  1.35
            Transport:          Serial
    Standards:
            Used: unknown (minor revision code 0x0028)
            Supported: 8 7 6 5
            Likely used: 8
    Configuration:
            Logical         max     current
            cylinders       16383   16383
            heads           16      16
            sectors/track   63      63
            --
            CHS current addressable sectors:   16514064
            LBA    user addressable sectors:  234441648
            LBA48  user addressable sectors:  234441648
            Logical  Sector size:                   512 bytes
            Physical Sector size:                   512 bytes
            Logical Sector-0 offset:                  0 bytes
            device size with M = 1024*1024:      114473 MBytes
            device size with M = 1000*1000:      120034 MBytes (120 GB)
            cache/buffer size  = unknown
            Nominal Media Rotation Rate: Solid State Device
    Capabilities:
            LBA, IORDY(can be disabled)
            Queue depth: 32
            Standby timer values: spec'd by Standard, no device specific minimum
            R/W multiple sector transfer: Max = 16  Current = 16
            DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
                 Cycle time: min=120ns recommended=120ns
            PIO: pio0 pio1 pio2 pio3 pio4
                 Cycle time: no flow control=120ns  IORDY flow control=120ns
    Commands/features:
            Enabled Supported:
               *    SMART feature set
                    Security Mode feature set
               *    Power Management feature set
               *    Write cache
               *    Look-ahead
                    Host Protected Area feature set
               *    WRITE_BUFFER command
               *    READ_BUFFER command
               *    NOP cmd
               *    DOWNLOAD_MICROCODE
                    SET_MAX security extension
               *    48-bit Address feature set
               *    Mandatory FLUSH_CACHE
               *    FLUSH_CACHE_EXT
               *    SMART error logging
               *    SMART self-test
               *    General Purpose Logging feature set
               *    WRITE_{DMA|MULTIPLE}_FUA_EXT
               *    64-bit World wide name
               *    IDLE_IMMEDIATE with UNLOAD
               *    WRITE_UNCORRECTABLE_EXT command
               *    Segmented DOWNLOAD_MICROCODE
               *    Gen1 signaling speed (1.5Gb/s)
               *    Gen2 signaling speed (3.0Gb/s)
               *    Native Command Queueing (NCQ)
               *    Host-initiated interface power management
               *    Phy event counters
               *    DMA Setup Auto-Activate optimization
                    Device-initiated interface power management
               *    Software settings preservation
               *    SMART Command Transport (SCT) feature set
               *    SCT LBA Segment Access (AC2)
               *    SCT Error Recovery Control (AC3)
               *    SCT Features Control (AC4)
               *    SCT Data Tables (AC5)
               *    Data Set Management TRIM supported (limit 1 block)
               *    Deterministic read data after TRIM
    Security:
                    supported
            not     enabled
            not     locked
                    frozen
            not     expired: security count
                    supported: enhanced erase
            400min for SECURITY ERASE UNIT. 400min for ENHANCED SECURITY ERASE UNIT.
    Logical Unit WWN Device Identifier: 5e83a97fe7238b7d
            NAA             : 5
            IEEE OUI        : e83a97
            Unique ID       : fe7238b7d
    Checksum: correct


hdparm -I /dev/sdb
==================
    /dev/sdb:

    ATA device, with non-removable media
            Model Number:       OCZ-VERTEX2
            Serial Number:      OCZ-JT00YSO1J56PNBG5
            Firmware Revision:  1.35
            Transport:          Serial
    Standards:
            Used: unknown (minor revision code 0x0028)
            Supported: 8 7 6 5
            Likely used: 8
    Configuration:
            Logical         max     current
            cylinders       16383   16383
            heads           16      16
            sectors/track   63      63
            --
            CHS current addressable sectors:   16514064
            LBA    user addressable sectors:  234441648
            LBA48  user addressable sectors:  234441648
            Logical  Sector size:                   512 bytes
            Physical Sector size:                   512 bytes
            Logical Sector-0 offset:                  0 bytes
            device size with M = 1024*1024:      114473 MBytes
            device size with M = 1000*1000:      120034 MBytes (120 GB)
            cache/buffer size  = unknown
            Nominal Media Rotation Rate: Solid State Device
    Capabilities:
            LBA, IORDY(can be disabled)
            Queue depth: 32
            Standby timer values: spec'd by Standard, no device specific minimum
            R/W multiple sector transfer: Max = 16  Current = 16
            DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
                 Cycle time: min=120ns recommended=120ns
            PIO: pio0 pio1 pio2 pio3 pio4
                 Cycle time: no flow control=120ns  IORDY flow control=120ns
    Commands/features:
            Enabled Supported:
               *    SMART feature set
                    Security Mode feature set
               *    Power Management feature set
               *    Write cache
               *    Look-ahead
                    Host Protected Area feature set
               *    WRITE_BUFFER command
               *    READ_BUFFER command
               *    NOP cmd
               *    DOWNLOAD_MICROCODE
                    SET_MAX security extension
               *    48-bit Address feature set
               *    Mandatory FLUSH_CACHE
               *    FLUSH_CACHE_EXT
               *    SMART error logging
               *    SMART self-test
               *    General Purpose Logging feature set
               *    WRITE_{DMA|MULTIPLE}_FUA_EXT
               *    64-bit World wide name
               *    IDLE_IMMEDIATE with UNLOAD
               *    WRITE_UNCORRECTABLE_EXT command
               *    Segmented DOWNLOAD_MICROCODE
               *    Gen1 signaling speed (1.5Gb/s)
               *    Gen2 signaling speed (3.0Gb/s)
               *    Native Command Queueing (NCQ)
               *    Host-initiated interface power management
               *    Phy event counters
               *    DMA Setup Auto-Activate optimization
                    Device-initiated interface power management
               *    Software settings preservation
               *    SMART Command Transport (SCT) feature set
               *    SCT LBA Segment Access (AC2)
               *    SCT Error Recovery Control (AC3)
               *    SCT Features Control (AC4)
               *    SCT Data Tables (AC5)
               *    Data Set Management TRIM supported (limit 1 block)
               *    Deterministic read data after TRIM
    Security:
                    supported
            not     enabled
            not     locked
                    frozen
            not     expired: security count
                    supported: enhanced erase
            400min for SECURITY ERASE UNIT. 400min for ENHANCED SECURITY ERASE UNIT.
    Logical Unit WWN Device Identifier: 5e83a97f98e23f26
            NAA             : 5
            IEEE OUI        : e83a97
            Unique ID       : f98e23f26
    Checksum: correct


hdparm -I /dev/sdc
==================
    /dev/sdc:

    ATA device, with non-removable media
            Model Number:       OCZ-VERTEX2
            Serial Number:      OCZ-1YJ3PX48285QOE4P
            Firmware Revision:  1.35
            Transport:          Serial
    Standards:
            Used: unknown (minor revision code 0x0028)
            Supported: 8 7 6 5
            Likely used: 8
    Configuration:
            Logical         max     current
            cylinders       16383   16383
            heads           16      16
            sectors/track   63      63
            --
            CHS current addressable sectors:   16514064
            LBA    user addressable sectors:  234441648
            LBA48  user addressable sectors:  234441648
            Logical  Sector size:                   512 bytes
            Physical Sector size:                   512 bytes
            Logical Sector-0 offset:                  0 bytes
            device size with M = 1024*1024:      114473 MBytes
            device size with M = 1000*1000:      120034 MBytes (120 GB)
            cache/buffer size  = unknown
            Nominal Media Rotation Rate: Solid State Device
    Capabilities:
            LBA, IORDY(can be disabled)
            Queue depth: 32
            Standby timer values: spec'd by Standard, no device specific minimum
            R/W multiple sector transfer: Max = 16  Current = 16
            DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
                 Cycle time: min=120ns recommended=120ns
            PIO: pio0 pio1 pio2 pio3 pio4
                 Cycle time: no flow control=120ns  IORDY flow control=120ns
    Commands/features:
            Enabled Supported:
               *    SMART feature set
                    Security Mode feature set
               *    Power Management feature set
               *    Write cache
               *    Look-ahead
                    Host Protected Area feature set
               *    WRITE_BUFFER command
               *    READ_BUFFER command
               *    NOP cmd
               *    DOWNLOAD_MICROCODE
                    SET_MAX security extension
               *    48-bit Address feature set
               *    Mandatory FLUSH_CACHE
               *    FLUSH_CACHE_EXT
               *    SMART error logging
               *    SMART self-test
               *    General Purpose Logging feature set
               *    WRITE_{DMA|MULTIPLE}_FUA_EXT
               *    64-bit World wide name
               *    IDLE_IMMEDIATE with UNLOAD
               *    WRITE_UNCORRECTABLE_EXT command
               *    Segmented DOWNLOAD_MICROCODE
               *    Gen1 signaling speed (1.5Gb/s)
               *    Gen2 signaling speed (3.0Gb/s)
               *    Native Command Queueing (NCQ)
               *    Host-initiated interface power management
               *    Phy event counters
               *    DMA Setup Auto-Activate optimization
                    Device-initiated interface power management
               *    Software settings preservation
               *    SMART Command Transport (SCT) feature set
               *    SCT LBA Segment Access (AC2)
               *    SCT Error Recovery Control (AC3)
               *    SCT Features Control (AC4)
               *    SCT Data Tables (AC5)
               *    Data Set Management TRIM supported (limit 1 block)
               *    Deterministic read data after TRIM
    Security:
                    supported
            not     enabled
            not     locked
                    frozen
            not     expired: security count
                    supported: enhanced erase
            400min for SECURITY ERASE UNIT. 400min for ENHANCED SECURITY ERASE UNIT.
    Logical Unit WWN Device Identifier: 5e83a97f87718aff
            NAA             : 5
            IEEE OUI        : e83a97
            Unique ID       : f87718aff
    Checksum: correct
