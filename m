Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0LCNhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 08:37:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42645 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0LCNhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:37:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=A77puHbRzzrPmTs2TnqpwmkPpx/162+p/0215j70daq9Ykbp5XI/hkRKiCMUgK20ON
         Qr8fSQQ4LfSK6J4R/bud77H7TB+Fm7OlnxhtkB2atnrZ9ZkZF2eOa7TFLA+iHAJ9Z8Mz
         cKKUtVGnKouZwrNIWHQjjNyafkCNOUGSNoOw0=
Subject: sata_sil24: use of msi causes nmi
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Dec 2010 14:37:02 +0100
Message-ID: <1291383422.14396.13.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Using sata_sil24 with the module option msi=1 and writing some data
causes an nmi and lockups the module, it can't be removed and only a
reboot solves the problem.

[ 3563.902356] sata_sil24 0000:02:00.0: version 1.1
[ 3563.902379] sata_sil24 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 3563.902935]   alloc irq_desc for 43 on node -1
[ 3563.902938]   alloc kstat_irqs on node -1
[ 3563.902956] sata_sil24 0000:02:00.0: irq 43 for MSI/MSI-X
[ 3563.902967] sata_sil24 0000:02:00.0: Using MSI
[ 3563.902977] sata_sil24 0000:02:00.0: setting latency timer to 64
[ 3563.903298] scsi9 : sata_sil24
[ 3563.903488] scsi10 : sata_sil24
[ 3563.903615] ata9: SATA max UDMA/100 host m128@0xfadfbf80 port 0xfadfc000 irq 43
[ 3563.903621] ata10: SATA max UDMA/100 host m128@0xfadfbf80 port 0xfadfe000 irq 43
[ 3565.923032] ata9: SATA link down (SStatus 0 SControl 0)
[ 3567.943028] ata10: SATA link down (SStatus 0 SControl 0)
[ 3598.066772] ata9: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
[ 3598.066777] ata9: irq_stat 0x00b40090, PHY RDY changed
[ 3598.066785] ata9: hard resetting link
[ 3600.198018] ata9: softreset failed (SRST command error)
[ 3600.198025] ata9: reset failed (errno=-5), retrying in 8 secs
[ 3608.066019] ata9: hard resetting link
[ 3610.209029] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[ 3610.209095] ata9.00: ATA-6: External Disk 0, RGL10403, max UDMA/133
[ 3610.209099] ata9.00: 1953546336 sectors, multi 1: LBA48 
[ 3610.209184] ata9.00: configured for UDMA/100
[ 3610.209190] ata9: EH complete
[ 3610.209294] scsi 9:0:0:0: Direct-Access     ATA      External Disk 0  RGL1 PQ: 0 ANSI: 5
[ 3610.209502] sd 9:0:0:0: [sdh] 1953546336 512-byte logical blocks: (1.00 TB/931 GiB)
[ 3610.209528] sd 9:0:0:0: Attached scsi generic sg9 type 0
[ 3610.209579] sd 9:0:0:0: [sdh] Write Protect is off
[ 3610.209583] sd 9:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[ 3610.209615] sd 9:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 3610.347199]  sdh: unknown partition table
[ 3610.347431] sd 9:0:0:0: [sdh] Attached SCSI disk
[ 3615.859236] XFS mounting filesystem sdh
[ 3615.966683] Ending clean XFS mount for filesystem: sdh
[ 3622.635163] Uhhuh. NMI received for unknown reason a1 on CPU 0.
[ 3622.635168] You have some hardware problem, likely on the PCI bus.
[ 3622.635170] Dazed and confused, but trying to continue

-Tobias

