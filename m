Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab0FBGBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 02:01:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65404 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab0FBGBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 02:01:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=B0vw8YGrHLekar9Iasr7n5ln0BkrBmp3DJdW7yGgv3tiaI6LIBsNh98D3swdcbChRQ
         yFlgmv+Q354kr2Z40xhJCYPngQn02uhlMdRg+QdvwcOL8/RrHbpI+equKNRMWr0xSql4
         fCDEO8cj6A25Fj3RqUOMNwNQCHd1nOPn1577I=
Message-ID: <4C05F3BF.6090503@gmail.com>
Date: Tue, 01 Jun 2010 23:01:35 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, x86@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to pci_reboot_dmi_table.
References: <20100601192101.GA15086@srcf.ucam.org> <4C056839.8020605@gmail.com> <20100601200704.GA16091@srcf.ucam.org> <4C056AE6.3000409@gmail.com> <20100601202130.GA16391@srcf.ucam.org> <4C056E0C.2030709@gmail.com> <20100601203351.GA16575@srcf.ucam.org> <4C0572B4.6000201@gmail.com> <20100601211219.GA17719@srcf.ucam.org> <4C057AE9.9020307@gmail.com> <20100601212901.GA18390@srcf.ucam.org> <4C057EF0.2030808@gmail.com> <4C05E800.1010400@gmail.com>
In-Reply-To: <4C05E800.1010400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 10:11 PM, Robert Hancock wrote:
> On 06/01/2010 03:43 PM, Justin P. Mattock wrote:
>> On 06/01/2010 02:29 PM, Matthew Garrett wrote:
>>> On Tue, Jun 01, 2010 at 02:26:01PM -0700, Justin P. Mattock wrote:
>>>> On 06/01/2010 02:12 PM, Matthew Garrett wrote:
>>>>> some level. How about the following (again, run as root):
>>>>>
>>>>> #include<sys/io.h>
>>>>>
>>>>> int main() {
>>>>> iopl(3);
>>>>> outb(0xfe, 0x64);
>>>>> return 0;
>>>>> }
>>>>>
>>>
>>> So, just to be clear, you run this as root and it immediately returns
>>> you to the prompt? This seems unlikely.
>>
>> yep.. with the above code
>> I (save to a file) then
>> non-root gcc reboot.c -o reboot
>> then su
>> ./reboot
>> just bake to the command prompt
>
> Can you post the FACP section of the acpidump output from this machine?
>

here you go:

/*
  * Intel ACPI Component Architecture
  * AML Disassembler version 20090123
  *
  * Disassembly of FACP.dat, Tue Jun  1 22:58:36 2010
  *
  * ACPI Data Table [FACP]
  *
  * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
  */

[000h 000  4]                    Signature : "FACP"    /* Fixed ACPI
Description Table */
[004h 004  4]                 Table Length : 000000F4
[008h 008  1]                     Revision : 03
[009h 009  1]                     Checksum : 0B
[00Ah 010  6]                       Oem ID : "APPLE "
[010h 016  8]                 Oem Table ID : "Apple00 "
[018h 024  4]                 Oem Revision : 0000008D
[01Ch 028  4]              Asl Compiler ID : "Loki"
[020h 032  4]        Asl Compiler Revision : 0000005F

[024h 036  4]                 FACS Address : BFECD000
[028h 040  4]                 DSDT Address : BFEE0000
[02Ch 044  1]                        Model : 00
[02Dh 045  1]                   PM Profile : 01
[02Eh 046  2]                SCI Interrupt : 0009
[030h 048  4]             SMI Command Port : 0000052E
[034h 052  1]            ACPI Enable Value : F0
[035h 053  1]           ACPI Disable Value : F1
[036h 054  1]               S4BIOS Command : F2
[037h 055  1]              P-State Control : 80
[038h 056  4]     PM1A Event Block Address : 00000400
[03Ch 060  4]     PM1B Event Block Address : 00000000
[040h 064  4]   PM1A Control Block Address : 00000404
[044h 068  4]   PM1B Control Block Address : 00000000
[048h 072  4]    PM2 Control Block Address : 0000041C
[04Ch 076  4]       PM Timer Block Address : 00000408
[050h 080  4]           GPE0 Block Address : 00000420
[054h 084  4]           GPE1 Block Address : 000005A0
[058h 088  1]       PM1 Event Block Length : 04
[059h 089  1]     PM1 Control Block Length : 02
[05Ah 090  1]     PM2 Control Block Length : 01
[05Bh 091  1]        PM Timer Block Length : 04
[05Ch 092  1]            GPE0 Block Length : 08
[05Dh 093  1]            GPE1 Block Length : 10
[05Eh 094  1]             GPE1 Base Offset : 20
[05Fh 095  1]                 _CST Support : 00
[060h 096  2]                   C2 Latency : 0065
[062h 098  2]                   C3 Latency : 03E9
[064h 100  2]               CPU Cache Size : 0000
[066h 102  2]           Cache Flush Stride : 0000
[068h 104  1]            Duty Cycle Offset : 01
[069h 105  1]             Duty Cycle Width : 03
[06Ah 106  1]          RTC Day Alarm Index : 7D
[06Bh 107  1]        RTC Month Alarm Index : 7E
[06Ch 108  1]            RTC Century Index : 32
[06Dh 109  2]   Boot Flags (decoded below) : 0001
              Legacy Devices Supported (V2) : 1
           8042 Present on ports 60/64 (V2) : 0
                       VGA Not Present (V4) : 0
                     MSI Not Supported (V4) : 0
               PCIe ASPM Not Supported (V4) : 0
[06Fh 111  1]                     Reserved : 00
[070h 112  4]        Flags (decoded below) : 00008425
     WBINVD instruction is operational (V1) : 1
             WBINVD flushes all caches (V1) : 0
                   All CPUs support C1 (V1) : 1
                 C2 works on MP system (V1) : 0
           Control Method Power Button (V1) : 0
           Control Method Sleep Button (V1) : 1
     RTC wakeup reg not in fixed space (V1) : 0
           RTC can wake system from S4 (V1) : 0
                       32-bit PM Timer (V1) : 0
                     Docking Supported (V1) : 0
              Reset Register Supported (V2) : 1
                           Sealed Case (V3) : 0
                   Headless - No Video (V3) : 0
       Use native instr after SLP_TYPx (V3) : 0
             PCIEXP_WAK Bits Supported (V4) : 0
                    Use Platform Timer (V4) : 1
              RTC_STS valid on S4 wake (V4) : 0
               Remote Power-on capable (V4) : 0
                Use APIC Cluster Model (V4) : 0
    Use APIC Physical Destination Mode (V4) : 0

[074h 116 12]               Reset Register : <Generic Address Structure>
[074h 116  1]                     Space ID : 01 (SystemIO)
[075h 117  1]                    Bit Width : 08
[076h 118  1]                   Bit Offset : 00
[077h 119  1]                 Access Width : 00
[078h 120  8]                      Address : 0000000000000CF9

[080h 128  1]         Value to cause reset : 06
[081h 129  3]                     Reserved : 000000
[084h 132  8]                 FACS Address : 00000000BFECD000
[08Ch 140  8]                 DSDT Address : 00000000BFEE0000
[094h 148 12]             PM1A Event Block : <Generic Address Structure>
[094h 148  1]                     Space ID : 01 (SystemIO)
[095h 149  1]                    Bit Width : 20
[096h 150  1]                   Bit Offset : 00
[097h 151  1]                 Access Width : 00
[098h 152  8]                      Address : 0000000000000400

[0A0h 160 12]             PM1B Event Block : <Generic Address Structure>
[0A0h 160  1]                     Space ID : 01 (SystemIO)
[0A1h 161  1]                    Bit Width : 00
[0A2h 162  1]                   Bit Offset : 00
[0A3h 163  1]                 Access Width : 00
[0A4h 164  8]                      Address : 0000000000000000

[0ACh 172 12]           PM1A Control Block : <Generic Address Structure>
[0ACh 172  1]                     Space ID : 01 (SystemIO)
[0ADh 173  1]                    Bit Width : 10
[0AEh 174  1]                   Bit Offset : 00
[0AFh 175  1]                 Access Width : 00
[0B0h 176  8]                      Address : 0000000000000404

[0B8h 184 12]           PM1B Control Block : <Generic Address Structure>
[0B8h 184  1]                     Space ID : 01 (SystemIO)
[0B9h 185  1]                    Bit Width : 00
[0BAh 186  1]                   Bit Offset : 00
[0BBh 187  1]                 Access Width : 00
[0BCh 188  8]                      Address : 0000000000000000

[0C4h 196 12]            PM2 Control Block : <Generic Address Structure>
[0C4h 196  1]                     Space ID : 01 (SystemIO)
[0C5h 197  1]                    Bit Width : 08
[0C6h 198  1]                   Bit Offset : 00
[0C7h 199  1]                 Access Width : 00
[0C8h 200  8]                      Address : 000000000000041C

[0D0h 208 12]               PM Timer Block : <Generic Address Structure>
[0D0h 208  1]                     Space ID : 01 (SystemIO)
[0D1h 209  1]                    Bit Width : 20
[0D2h 210  1]                   Bit Offset : 00
[0D3h 211  1]                 Access Width : 00
[0D4h 212  8]                      Address : 0000000000000408

[0DCh 220 12]                   GPE0 Block : <Generic Address Structure>
[0DCh 220  1]                     Space ID : 01 (SystemIO)
[0DDh 221  1]                    Bit Width : 40
[0DEh 222  1]                   Bit Offset : 00
[0DFh 223  1]                 Access Width : 00
[0E0h 224  8]                      Address : 0000000000000420

[0E8h 232 12]                   GPE1 Block : <Generic Address Structure>
[0E8h 232  1]                     Space ID : 01 (SystemIO)
[0E9h 233  1]                    Bit Width : 80
[0EAh 234  1]                   Bit Offset : 00
[0EBh 235  1]                 Access Width : 00
[0ECh 236  8]                      Address : 00000000000005A0


Raw Table Data

   0000: 46 41 43 50 F4 00 00 00 03 0B 41 50 50 4C 45 20  FACP......APPLE
   0010: 41 70 70 6C 65 30 30 20 8D 00 00 00 4C 6F 6B 69  Apple00 ....Loki
   0020: 5F 00 00 00 00 D0 EC BF 00 00 EE BF 00 01 09 00  _...............
   0030: 2E 05 00 00 F0 F1 F2 80 00 04 00 00 00 00 00 00  ................
   0040: 04 04 00 00 00 00 00 00 1C 04 00 00 08 04 00 00  ................
   0050: 20 04 00 00 A0 05 00 00 04 02 01 04 08 10 20 00   ............. .
   0060: 65 00 E9 03 00 00 00 00 01 03 7D 7E 32 01 00 00  e.........}~2...
   0070: 25 84 00 00 01 08 00 00 F9 0C 00 00 00 00 00 00  %...............
   0080: 06 00 00 00 00 D0 EC BF 00 00 00 00 00 00 EE BF  ................
   0090: 00 00 00 00 01 20 00 00 00 04 00 00 00 00 00 00  ..... ..........
   00A0: 01 00 00 00 00 00 00 00 00 00 00 00 01 10 00 00  ................
   00B0: 04 04 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
   00C0: 00 00 00 00 01 08 00 00 1C 04 00 00 00 00 00 00  ................
   00D0: 01 20 00 00 08 04 00 00 00 00 00 00 01 40 00 00  . ...........@..
   00E0: 20 04 00 00 00 00 00 00 01 80 00 00 A0 05 00 00   ...............
   00F0: 00 00 00 00                                      ....


hopefully the table didnt get garbled by the mail client.

Justin P. Mattock
