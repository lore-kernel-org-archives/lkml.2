Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab1AFS3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:29:42 -0500
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:36450 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752444Ab1AFS3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:29:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=UTKp+PCPdKNk8lV/RQvEiUM4r/MI6MT4BpmragSk8ZJ6clNZ919ZIOOV2DN3sksB;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4D260A11.2040102@earthlink.net>
Date: Thu, 06 Jan 2011 13:29:37 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel 2.6.37 erroneously limiting to UDMA/33
References: <4D24B98D.6080307@earthlink.net> <4D2503B1.4080500@gmail.com>
In-Reply-To: <4D2503B1.4080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79db06d6c85c94da490e55818ed176abd2350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 06:50 PM, Robert Hancock wrote:
> (CCing linux-ide)
>
> On 01/05/2011 12:33 PM, Stephen Clark wrote:
>> Hello,
>>
>> Why is the kernel limiting me to udma/33 when the device says it can do
>> ata2.01: CFA: TRANSCEND, 20070831, max UDMA/66
>>
>> There is no cable the compact flash is a socket on the motherboard!
>
> The kernel has no way to know that, and presumably the board isn't 
> connecting the signal for IDE pin 34 to ground in order to properly 
> signal that an 80-wire cable (or equivalent) is connected so that 
> speeds over UDMA33 can be used.
>
> You should be able to use the libata.force=80c option on the kernel 
> command line to override the cable detection.
>
>>
>> Loading sd_mod.ko module
>> Loading libata.ko module
>> Loading ata_generic.ko module
>> Loading pata_acpi.ko module
>> pata_acpi 0000:00:0f.0: PCI INT B -> GSI 21 (level, low) -> IRQ 21
>> pata_acpi 0000:00:0f.0: PCI INT B disabled
>> Loading pata_via.ko module
>> scsi0 : pata_via
>> scsi1 : pata_via
>> ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
>> ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
>> ata2.01: CFA: TRANSCEND, 20070831, max UDMA/66
>> ata2.01: 7962192 sectors, multi 0: LBA
>> ata2.01: limited to UDMA/33 due to 40-wire cable
>> ata2.01: configured for UDMA/33
>> scsi 1:0:1:0: Direct-Access ATA TRANSCEND 2007 PQ: 0 ANSI: 5
>> sd 1:0:1:0: [sda] 7962192 512-byte logical blocks: (4.07 GB/3.79 GiB)
>> sd 1:0:1:0: [sda] Write Protect is off
>> sd 1:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't
>> support DA
>> sda: sda1 sda2 sda3
>> sd 1:0:1:0: [sda] Attached SCSI disk
>> Loading ata_piix.ko module
>>
>> Thanks,
>> Steve
>>
>

Hmm... libata.force=80c - didn't seem to work.

   Booting command-list

root (hd0,0)
  Filesystem type is ext2fs, partition type 0x83
kernel /vmlinuz-2.6.37 ro root=LABEL=/ console=ttyS0,115200n8 
libata.force=80c
    [Linux-bzImage, setup=0x3c00, size=0x2ad060]
initrd /initrd-2.6.37.img
    [Linux-initrd @ 0x1fd59000, 0x286776 bytes]
...
Loading pata_via.ko module
scsi0 : pata_via
scsi1 : pata_via
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
ata2.01: CFA: TRANSCEND, 20070831, max UDMA/66
ata2.01: 7962192 sectors, multi 0: LBA
ata2.01: limited to UDMA/33 due to 40-wire cable
ata2.01: configured for UDMA/33
scsi 1:0:1:0: Direct-Access     ATA      TRANSCEND        2007 PQ: 0 ANSI: 5
sd 1:0:1:0: [sda] 7962192 512-byte logical blocks: (4.07 GB/3.79 GiB)
sd 1:0:1:0: [sda] Write Protect is off
sd 1:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't 
support DA
  sda: sda1 sda2 sda3
sd 1:0:1:0: [sda] Attached SCSI disk

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



