Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0FCHC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:02:29 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51257 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab0FCHC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:02:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=qut9Ncz1BpMGjVusk49S5/5HQm09k5dh82KEBfpGGQ66HYRFQRXPC7OLnvVAoxF7Y4
         DK+sSc6QQ122ZvYLJQIc7QHKGbWjkUOk8Mwege5eP//5tJzVCSlSVErzWOBaKr4CUMpQ
         XEjOIfPpJVSTMcyBjEjaFC1uesfMLdiFNVTMY=
MIME-Version: 1.0
Date: Thu, 3 Jun 2010 15:02:25 +0800
Message-ID: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
Subject: 2.6.25-rc1 ahci regression
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: avorontsov@ru.mvista.com, jgarzik@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I happened to notice that the commit 365cfa1ed5 caused the following
boot error with 2.6.25-rc1
on a system with ICH10 SATA AHCI controller. It's weird if there is
really no function changes in the patch.

Any ideas?


dracut: Starting plymouth daemon
pata_jmicron 0000:0f:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
scsi0 : pata_jmicron
Initializing USB Mass Storage driver...
scsi1 : usb-storage 1-5:1.0
scsi2 : pata_jmicron
ata1: PATA max UDMA/100 cmd 0xd040 ctl 0xd030 bmdma 0xd000 irq 16
ata2: PATA max UDMA/100 cmd 0xd020 ctl 0xd010 bmdma 0xd008 irq 16
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
scsi 1:0:0:0: CD-ROM            PepperC  Virtual Disc 1   0.01 PQ: 0 ANSI: 3
sr0: scsi-1 drive



commit 365cfa1ed5a36f9bcb9f64c9f0f52155af2e9fef
Author: Anton Vorontsov <avorontsov@ru.mvista.com>
Date:   Sun Mar 28 00:22:14 2010 -0400

    ahci: Move generic code into libahci

    This patch should contain no functional changes, just moves code
    around.

    Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
