Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab2JKJP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 05:15:29 -0400
Received: from hotel311.server4you.de ([85.25.146.15]:36441 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2JKJPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 05:15:22 -0400
Message-ID: <50768E24.3020308@monom.org>
Date: Thu, 11 Oct 2012 17:15:16 +0800
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: cpufreq@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: ondemand 'regression' after firmware upgrade on MBA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I updated the firmware of Macbook Air Mid 2012 model to 
version 2.5. The changelog from Apple

http://support.apple.com/kb/DL1592

"This update fixes an issue where Turbo Boost does not
activate when using Boot Camp" 

indicates that they changed stuff on the ACPI tables.

Now I have noticed that after updating the firmware the CPU
frequency stays at 800 MHz even when compiling the kernel.

I tried to debug what's going on. Here is my current results
and I am kind of stuck how to proceed from here. Any ideas to
go on from here?

cheers,
daniel

And here the results:

(complete logs and tables are here: http://www.monom.org/misc/acpi/ )

- When I change the governor to 'conservative' the CPU will
  be run eventually on max speed.

- With lowering the threshold from 95 to 70, I see again clock
  speed changes

  echo 70 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold

- The ACPI tables seem to have changed. Unfortunately, I have
  only retrieved the new one.  I have an old dmesg 
  output (3.6.0-rc6+) compared with new dmesg output (3.6.0-rc7+):

Old:

ACPI: RSDP 000000008ad8e014 00024 (v02 APPLE )
ACPI: XSDT 000000008ad8e1c0 000B4 (v01 APPLE   Apple00 00000000      01000013)
ACPI: FACP 000000008ad8c000 000F4 (v04 APPLE   Apple00 00000000 Loki 0000005F)
ACPI: DSDT 000000008ad82000 04708 (v01 APPLE  MacBookA 00050001 INTL 20100915)
ACPI: FACS 000000008ad1c000 00040
ACPI: HPET 000000008ad8b000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: APIC 000000008ad8a000 000BC (v02 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: SBST 000000008ad88000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: ECDT 000000008ad87000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: SSDT 000000008ad7f000 001EE (v01 APPLE  SataAhci 00001000 INTL 20100915)
ACPI: SSDT 000000008ad7e000 00024 (v01 APPLE   SmcDppt 00001000 INTL 20100915)
ACPI: SSDT 000000008ad78000 00D74 (v01 APPLE  UsbSdPpt 00001000 INTL 20100915)
ACPI: SSDT 000000008ad77000 00159 (v02 APPLE     IGHda 00001000 INTL 20100915)
ACPI: SSDT 000000008ad75000 00032 (v01 APPLE    SsdtS3 00001000 INTL 20100915)
ACPI: SSDT 000000008ad73000 015EB (v02 APPLE  SsdtIGPU 00001000 INTL 20100915)
ACPI: SSDT 000000008ad72000 00F0D (v01 APPLE   PcieTbt 00001000 INTL 20100915)
ACPI: SSDT 000000008ad6f000 006DB (v01  PmRef  Cpu0Ist 00003000 INTL 20100915)
ACPI: SSDT 000000008ad6e000 00B3D (v01  PmRef    CpuPm 00003000 INTL 20100915)
ACPI: SSDT 000000008ad6d000 00315 (v01  PmRef  Cpu0Tst 00003000 INTL 20100915)
ACPI: SSDT 000000008ad6c000 0037A (v01  PmRef    ApTst 00003000 INTL 20100915)
ACPI: DMAR 000000008ad6b000 000B8 (v01 APPLE      IVB  00000001 AAPL 00000001)
ACPI: MCFG 000000008ad89000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)


New:

ACPI: RSDP 000000008ad8e014 00024 (v02 APPLE )
ACPI: XSDT 000000008ad8e1c0 000B4 (v01 APPLE   Apple00 00000000      01000013)
ACPI: FACP 000000008ad8c000 000F4 (v04 APPLE   Apple00 00000000 Loki 0000005F)
ACPI: DSDT 000000008ad82000 04708 (v01 APPLE  MacBookA 00050001 INTL 20100915)
ACPI: FACS 000000008ad1c000 00040
ACPI: HPET 000000008ad8b000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: APIC 000000008ad8a000 000BC (v02 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: SBST 000000008ad88000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: ECDT 000000008ad87000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
ACPI: SSDT 000000008ad7f000 001EE (v01 APPLE  SataAhci 00001000 INTL 20100915)
ACPI: SSDT 000000008ad7e000 00024 (v01 APPLE   SmcDppt 00001000 INTL 20100915)
ACPI: SSDT 000000008ad78000 00D74 (v01 APPLE  UsbSdPpt 00001000 INTL 20100915)
ACPI: SSDT 000000008ad77000 00159 (v02 APPLE     IGHda 00001000 INTL 20100915)
ACPI: SSDT 000000008ad75000 00032 (v01 APPLE    SsdtS3 00001000 INTL 20100915)
ACPI: SSDT 000000008ad73000 015EB (v02 APPLE  SsdtIGPU 00001000 INTL 20100915)
ACPI: SSDT 000000008ad72000 00F0D (v01 APPLE   PcieTbt 00001000 INTL 20100915)
ACPI: SSDT 000000008ad6f000 00615 (v01  PmRef  Cpu0Ist 00003000 INTL 20100915)
ACPI: SSDT 000000008ad6e000 00B3D (v01  PmRef    CpuPm 00003000 INTL 20100915)
ACPI: SSDT 000000008ad6d000 00315 (v01  PmRef  Cpu0Tst 00003000 INTL 20100915)
ACPI: SSDT 000000008ad6c000 0037A (v01  PmRef    ApTst 00003000 INTL 20100915)
ACPI: DMAR 000000008ad6b000 00088 (v01 APPLE      IVB  00000001 AAPL 00000001)
ACPI: MCFG 000000008ad89000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)

The first PmRef has changed in size. The rest looks pretty the same. So here
is the disassembly of this table. 

/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20100528
 *
 * Disassembly of SSDT8.dat, Wed Oct 10 15:24:22 2012
 *
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000615 (1557)
 *     Revision         0x01
 *     Checksum         0xC0
 *     OEM ID           "PmRef"
 *     OEM Table ID     "Cpu0Ist"
 *     OEM Revision     0x00003000 (12288)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20100915 (537921813)
 */
DefinitionBlock ("SSDT8.aml", "SSDT", 1, "PmRef", "Cpu0Ist", 0x00003000)
{
    External (PDC0)
    External (TCNT, IntObj)
    External (CPLT, IntObj)
    External (\_PR_.CPU0, DeviceObj)

    Scope (\_PR.CPU0)
    {
        Method (_PPC, 0, NotSerialized)
        {
            Return (CPLT)
        }

        Name (_PCT, Package (0x02)
        {
            ResourceTemplate ()
            {
                Register (FFixedHW, 
                    0x10,               // Bit Width
                    0x00,               // Bit Offset
                    0x0000000000000199, // Address
                    ,)
            }, 

            ResourceTemplate ()
            {
                Register (FFixedHW, 
                    0x10,               // Bit Width
                    0x00,               // Bit Offset
                    0x0000000000000198, // Address
                    ,)
            }
        })
        Name (_PSS, Package (0x0E)
        {
            Package (0x06)
            {
                0x000007D1, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00002000, 
                0x00002000
            }, 

            Package (0x06)
            {
                0x000007D0, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00001400, 
                0x00001400
            }, 

            Package (0x06)
            {
                0x0000076C, 
                0x00003E5E, 
                0x0000000A, 
                0x0000000A, 
                0x00001300, 
                0x00001300
            }, 

            Package (0x06)
            {
                0x00000708, 
                0x00003A69, 
                0x0000000A, 
                0x0000000A, 
                0x00001200, 
                0x00001200
            }, 

            Package (0x06)
            {
                0x000006A4, 
                0x00003688, 
                0x0000000A, 
                0x0000000A, 
                0x00001100, 
                0x00001100
            }, 

            Package (0x06)
            {
                0x00000640, 
                0x000032BA, 
                0x0000000A, 
                0x0000000A, 
                0x00001000, 
                0x00001000
            }, 

            Package (0x06)
            {
                0x000005DC, 
                0x00002F01, 
                0x0000000A, 
                0x0000000A, 
                0x00000F00, 
                0x00000F00
            }, 

            Package (0x06)
            {
                0x00000578, 
                0x00002B5E, 
                0x0000000A, 
                0x0000000A, 
                0x00000E00, 
                0x00000E00
            }, 

            Package (0x06)
            {
                0x00000514, 
                0x000027CB, 
                0x0000000A, 
                0x0000000A, 
                0x00000D00, 
                0x00000D00
            }, 

            Package (0x06)
            {
                0x000004B0, 
                0x0000244C, 
                0x0000000A, 
                0x0000000A, 
                0x00000C00, 
                0x00000C00
            }, 

            Package (0x06)
            {
                0x0000044C, 
                0x000020E1, 
                0x0000000A, 
                0x0000000A, 
                0x00000B00, 
                0x00000B00
            }, 

            Package (0x06)
            {
                0x000003E8, 
                0x00001D88, 
                0x0000000A, 
                0x0000000A, 
                0x00000A00, 
                0x00000A00
            }, 

            Package (0x06)
            {
                0x00000384, 
                0x00001A43, 
                0x0000000A, 
                0x0000000A, 
                0x00000900, 
                0x00000900
            }, 

            Package (0x06)
            {
                0x00000320, 
                0x00001710, 
                0x0000000A, 
                0x0000000A, 
                0x00000800, 
                0x00000800
            }
        })
        Name (APSS, Package (0x19)
        {
            Package (0x06)
            {
                0x00000C80, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00002000, 
                0x00002000
            }, 

            Package (0x06)
            {
                0x00000C1C, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00001F00, 
                0x00001F00
            }, 

            Package (0x06)
            {
                0x00000BB8, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00001E00, 
                0x00001E00
            }, 

            Package (0x06)
            {
                0x00000B54, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00001D00, 
                0x00001D00
            }, 

            Package (0x06)
            {
                0x00000AF0, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00001C00, 
                0x00001C00
            }, 

            Package (0x06)
            {
                0x00000A8C, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00001B00, 
                0x00001B00
            }, 

            Package (0x06)
            {
                0x00000A28, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00001A00, 
                0x00001A00
            }, 

            Package (0x06)
            {
                0x000009C4, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00001900, 
                0x00001900
            }, 

            Package (0x06)
            {
                0x00000960, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00001800, 
                0x00001800
            }, 

            Package (0x06)
            {
                0x000008FC, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00001700, 
                0x00001700
            }, 

            Package (0x06)
            {
                0x00000898, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00001600, 
                0x00001600
            }, 

            Package (0x06)
            {
                0x00000834, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00001500, 
                0x00001500
            }, 

            Package (0x06)
            {
                0x000007D0, 
                0x00004268, 
                0x0000000A, 
                0x0000000A, 
                0x00001400, 
                0x00001400
            }, 

            Package (0x06)
            {
                0x0000076C, 
                0x00003E5E, 
                0x0000000A, 
                0x0000000A, 
                0x00001300, 
                0x00001300
            }, 

            Package (0x06)
            {
                0x00000708, 
                0x00003A69, 
                0x0000000A, 
                0x0000000A, 
                0x00001200, 
                0x00001200
            }, 

            Package (0x06)
            {
                0x000006A4, 
                0x00003688, 
                0x0000000A, 
                0x0000000A, 
                0x00001100, 
                0x00001100
            }, 

            Package (0x06)
            {
                0x00000640, 
                0x000032BA, 
                0x0000000A, 
                0x0000000A, 
                0x00001000, 
                0x00001000
            }, 

            Package (0x06)
            {
                0x000005DC, 
                0x00002F01, 
                0x0000000A, 
                0x0000000A, 
                0x00000F00, 
                0x00000F00
            }, 

            Package (0x06)
            {
                0x00000578, 
                0x00002B5E, 
                0x0000000A, 
                0x0000000A, 
                0x00000E00, 
                0x00000E00
            }, 

            Package (0x06)
            {
                0x00000514, 
                0x000027CB, 
                0x0000000A, 
                0x0000000A, 
                0x00000D00, 
                0x00000D00
            }, 

            Package (0x06)
            {
                0x000004B0, 
                0x0000244C, 
                0x0000000A, 
                0x0000000A, 
                0x00000C00, 
                0x00000C00
            }, 

            Package (0x06)
            {
                0x0000044C, 
                0x000020E1, 
                0x0000000A, 
                0x0000000A, 
                0x00000B00, 
                0x00000B00
            }, 

            Package (0x06)
            {
                0x000003E8, 
                0x00001D88, 
                0x0000000A, 
                0x0000000A, 
                0x00000A00, 
                0x00000A00
            }, 

            Package (0x06)
            {
                0x00000384, 
                0x00001A43, 
                0x0000000A, 
                0x0000000A, 
                0x00000900, 
                0x00000900
            }, 

            Package (0x06)
            {
                0x00000320, 
                0x00001710, 
                0x0000000A, 
                0x0000000A, 
                0x00000800, 
                0x00000800
            }
        })
        Name (APSN, 0x0C)
        Name (APLF, 0x00)
        Name (PSDF, 0x00)
        Method (_PSD, 0, NotSerialized)
        {
            If (LNot (PSDF))
            {
                Store (TCNT, Index (DerefOf (Index (HPSD, 0x00)), 0x04))
                Store (TCNT, Index (DerefOf (Index (SPSD, 0x00)), 0x04))
                Store (Ones, PSDF)
            }

            If (And (PDC0, 0x0800))
            {
                Return (HPSD)
            }

            Return (SPSD)
        }

        Name (HPSD, Package (0x01)
        {
            Package (0x05)
            {
                0x05, 
                0x00, 
                0x00, 
                0xFE, 
                0x80
            }
        })
        Name (SPSD, Package (0x01)
        {
            Package (0x05)
            {
                0x05, 
                0x00, 
                0x00, 
                0xFC, 
                0x80
            }
        })
    }
}


