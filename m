Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051Ab0FKCIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 22:08:45 -0400
Received: from clueserver.org ([65.102.45.174]:56535 "EHLO clueserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab0FKCIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 22:08:44 -0400
Message-ID: <54318.10.6.6.23.1276222123.squirrel@10.6.6.2>
In-Reply-To: <4C10A81F.50801@garzik.org>
References: <34979.10.6.6.23.1276144792.squirrel@10.6.6.2>
    <4C10A81F.50801@garzik.org>
Date: Thu, 10 Jun 2010 19:08:43 -0700 (PDT)
Subject: Re: Question on siig sata 3 controller
From: "Alan" <alan@clueserver.org>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: "Alan" <alan@clueserver.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/10/2010 12:39 AM, Alan wrote:
>> Does anyone know the status of the SIIG DP SATA 6Gb/s 2S1P PCIe (Part
>> number: SC-SA0E12-S1)?
>>
>> I am encountering problems writing a large quantity through this
>> controller and I want to see if there is a way to fix this.  The pci ids
>> do not appear to be referenced in the kernel.
>>
>> Are any of the siig sata controllers supported? Is there some issue with
>> them supporting Linux that I am not aware of?
>>
>> Here is the lspci data:
>>
>> 05:00.0 SATA controller: Device 1b4b:9123 (rev 11) (prog-if 01 [AHCI
>> 1.0])
>> 	Subsystem: Device 1b4b:9123
>> 	Flags: bus master, fast devsel, latency 0, IRQ 30
>> 	I/O ports at dc00 [size=8]
>> 	I/O ports at d880 [size=4]
>> 	I/O ports at d800 [size=8]
>> 	I/O ports at d480 [size=4]
>> 	I/O ports at d400 [size=16]
>> 	Memory at f9fff800 (32-bit, non-prefetchable) [size=2K]
>> 	Expansion ROM at f9fe0000 [disabled] [size=64K]
>> 	Capabilities:<access denied>
>> 	Kernel driver in use: ahci
>
> What issues are you seeing?
>
> The 'ahci' driver is aware of this controller...

When writing large amounts of data I see messages like the following:

Jun  8 19:31:46 zowie kernel: ata2.00: exception Emask 0x0 SAct 0x3fffffff
SErr 0x0 action 0x6 frozen
Jun  8 19:31:46 zowie kernel: ata2.00: failed command: WRITE FPDMA QUEUED
Jun  8 19:31:46 zowie kernel: ata2.00: cmd
61/28:00:17:fb:06/00:00:04:00:00/40 tag 0 ncq 20480 out
Jun  8 19:31:46 zowie kernel:         res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun  8 19:31:46 zowie kernel: ata2.00: status: { DRDY }
Jun  8 19:31:46 zowie kernel: ata2.00: failed command: WRITE FPDMA QUEUED
Jun  8 19:31:46 zowie kernel: ata2.00: cmd
61/20:08:9f:db:06/00:00:04:00:00/40 tag 1 ncq 16384 out
Jun  8 19:31:46 zowie kernel:         res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun  8 19:31:46 zowie kernel: ata2.00: status: { DRDY }
Jun  8 19:31:46 zowie kernel: ata2.00: failed command: WRITE FPDMA QUEUED
Jun  8 19:31:46 zowie kernel: ata2.00: cmd
61/28:10:d7:df:06/00:00:04:00:00/40 tag 2 ncq 20480 out
Jun  8 19:31:46 zowie kernel:         res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun  8 19:31:46 zowie kernel: ata2.00: status: { DRDY }
Jun  8 19:31:46 zowie kernel: ata2.00: failed command: WRITE FPDMA QUEUED
Jun  8 19:31:46 zowie kernel: ata2.00: cmd
61/30:18:0f:e4:06/00:00:04:00:00/40 tag 3 ncq 24576 out
Jun  8 19:31:46 zowie kernel:         res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun  8 19:31:46 zowie kernel: ata2.00: status: { DRDY }
Jun  8 19:31:46 zowie kernel: ata2.00: failed command: WRITE FPDMA QUEUED
Jun  8 19:31:46 zowie kernel: ata2.00: cmd
61/28:20:17:fc:06/00:00:04:00:00/40 tag 4 ncq 20480 out
Jun  8 19:31:46 zowie kernel:         res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun  8 19:31:46 zowie kernel: ata2.00: status: { DRDY }
Jun  8 19:31:46 zowie kernel: ata2.00: failed command: WRITE FPDMA QUEUED
Jun  8 19:31:46 zowie kernel: ata2.00: cmd
61/08:28:b7:b7:06/00:00:04:00:00/40 tag 5 ncq 4096 out
Jun  8 19:31:46 zowie kernel:         res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun  8 19:31:46 zowie kernel: ata2.00: status: { DRDY }
Jun  8 19:31:46 zowie kernel: ata2.00: failed command: WRITE FPDMA QUEUED
Jun  8 19:31:46 zowie kernel: ata2.00: cmd
61/20:30:1f:d3:06/00:00:04:00:00/40 tag 6 ncq 16384 out
Jun  8 19:31:46 zowie kernel:         res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun  8 19:31:46 zowie kernel: ata2.00: status: { DRDY }
Jun  8 19:31:46 zowie kernel: ata2.00: failed command: WRITE FPDMA QUEUED

After a bit it does this:

Jun  8 19:31:46 zowie kernel: ata2: hard resetting link
Jun  8 19:31:48 zowie kernel: ata2: SATA link up 1.5 Gbps (SStatus 113
SControl 300)
Jun  8 19:31:53 zowie kernel: ata2.00: qc timeout (cmd 0xec)
Jun  8 19:31:53 zowie kernel: ata2.00: failed to IDENTIFY (I/O error,
err_mask=0x4)
Jun  8 19:31:53 zowie kernel: ata2.00: revalidation failed (errno=-5)
Jun  8 19:31:53 zowie kernel: ata2: hard resetting link
Jun  8 19:31:54 zowie kernel: ata2: SATA link up 1.5 Gbps (SStatus 113
SControl 300)
Jun  8 19:32:04 zowie kernel: ata2.00: qc timeout (cmd 0xec)
Jun  8 19:32:05 zowie kernel: ata2.00: failed to IDENTIFY (I/O error,
err_mask=0x4)
Jun  8 19:32:05 zowie kernel: ata2.00: revalidation failed (errno=-5)
Jun  8 19:32:05 zowie kernel: ata2: limiting SATA link speed to 1.5 Gbps
Jun  8 19:32:05 zowie kernel: ata2: hard resetting link
Jun  8 19:32:05 zowie kernel: ata2: SATA link up 1.5 Gbps (SStatus 113
SControl 310)
Jun  8 19:32:35 zowie kernel: ata2.00: qc timeout (cmd 0xec)
Jun  8 19:32:36 zowie kernel: ata2.00: failed to IDENTIFY (I/O error,
err_mask=0x4)
Jun  8 19:32:36 zowie kernel: ata2.00: revalidation failed (errno=-5)
Jun  8 19:32:36 zowie kernel: ata2.00: disabled
Jun  8 19:32:36 zowie kernel: ata2.00: device reported invalid CHS sector 0
Jun  8 19:32:36 zowie kernel: ata2.00: device reported invalid CHS sector 0
Jun  8 19:32:36 zowie kernel: ata2.00: device reported invalid CHS sector 0
Jun  8 19:32:36 zowie kernel: ata2.00: device reported invalid CHS sector 0

The drive goes into a read only state at this point.

It does not matter what drive I put on the controller.  The controller has
been replaced once already.

Double-plus ungood.

