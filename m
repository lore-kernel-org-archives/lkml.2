Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab1AEXuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:50:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65456 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1AEXuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:50:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=b0l8c8K+hMXVTkHdOYnUYx7vi21HJAhJF0cklA1GKd1nqmKu6vqpynXtpro+dVbcx3
         8jV0WKYOIj9l7e2O9BJpQE4fm9/fEVBqMtlU+yA5ij+Hd99IzkNXnAVFcDA8KEPCi9Z+
         yG2lDHbOQD4Y4f5Q0dhO3apToLRd0GVb2gONY=
Message-ID: <4D2503B1.4080500@gmail.com>
Date: Wed, 05 Jan 2011 17:50:09 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: sclark46@earthlink.net
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel 2.6.37 erroneously limiting to UDMA/33
References: <4D24B98D.6080307@earthlink.net>
In-Reply-To: <4D24B98D.6080307@earthlink.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCing linux-ide)

On 01/05/2011 12:33 PM, Stephen Clark wrote:
> Hello,
>
> Why is the kernel limiting me to udma/33 when the device says it can do
> ata2.01: CFA: TRANSCEND, 20070831, max UDMA/66
>
> There is no cable the compact flash is a socket on the motherboard!

The kernel has no way to know that, and presumably the board isn't 
connecting the signal for IDE pin 34 to ground in order to properly 
signal that an 80-wire cable (or equivalent) is connected so that speeds 
over UDMA33 can be used.

You should be able to use the libata.force=80c option on the kernel 
command line to override the cable detection.

>
> Loading sd_mod.ko module
> Loading libata.ko module
> Loading ata_generic.ko module
> Loading pata_acpi.ko module
> pata_acpi 0000:00:0f.0: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> pata_acpi 0000:00:0f.0: PCI INT B disabled
> Loading pata_via.ko module
> scsi0 : pata_via
> scsi1 : pata_via
> ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
> ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
> ata2.01: CFA: TRANSCEND, 20070831, max UDMA/66
> ata2.01: 7962192 sectors, multi 0: LBA
> ata2.01: limited to UDMA/33 due to 40-wire cable
> ata2.01: configured for UDMA/33
> scsi 1:0:1:0: Direct-Access ATA TRANSCEND 2007 PQ: 0 ANSI: 5
> sd 1:0:1:0: [sda] 7962192 512-byte logical blocks: (4.07 GB/3.79 GiB)
> sd 1:0:1:0: [sda] Write Protect is off
> sd 1:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't
> support DA
> sda: sda1 sda2 sda3
> sd 1:0:1:0: [sda] Attached SCSI disk
> Loading ata_piix.ko module
>
> Thanks,
> Steve
>

