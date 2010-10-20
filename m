Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0JTUDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:03:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38377 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab0JTUDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=KxCjBQerNerP4U56+CafAO0Krvy7SWrIZWBgWyOgNmoNtMTum3rRVtoHZ93WHaxYtV
         u3ec0BiBOhMn+Nd/ZNG457F/n/ykdQGZK4Daxt4MGZV2m2N5nhM+oXcJYlvTESZXkm6V
         RbztAnxsNwGWgfowxQrFhfFsYRoMZMKZC/jWI=
MIME-Version: 1.0
Date: Wed, 20 Oct 2010 21:03:44 +0100
Message-ID: <AANLkTik02CcVyzn+fMH+VxuUmwwNLZq9qM0MPz81E+1h@mail.gmail.com>
Subject: sata_mv and Highpoint RocketRAID 230x, corruption?
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi mailing list,

(please cc me as I'm not subscribed)

I'm currently migrating my system from pure LVM to HDD partitions >
mdadm RAID5 > lvm > filesystem(s). I got a bit worried when I saw this
in dmesg:

"sata_mv 0000:05:00.0: version 1.28
sata_mv 0000:05:00.0: PCI INT A -> Link[LN4A] -> GSI 19 (level, low) -> IRQ 19
sata_mv: Highpoint RocketRAID BIOS CORRUPTS DATA on all attached
drives, regardless of if/how they are configured. BEWARE!
sata_mv: For data safety, do not use sectors 8-9 on "Legacy" drives,
and avoid the final two gigabytes on all RocketRAID BIOS initialized
drives.
sata_mv 0000:05:00.0: Gen-IIE 32 slots 4 ports SCSI mode IRQ via INTx
sata_mv 0000:05:00.0: setting latency timer to 64
"

I'm currently not using the BIOS of the raid controller for anything
else then staggered disk spinup. The HDD partitions start at sector
2048 (to get a 1MB alignment since they're 4k sector drives, WD20EARS)
and end at the last sector.
What I'm worried about is the corruption mentioned in dmesg, is this
explained somewhere in more detail? Google didn't reveal much. Am I in
danger?

Thanks,

// Mathias on Archlinux
