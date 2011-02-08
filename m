Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1BHMXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:23:42 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48060 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab1BHMXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:23:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=DV9pYXEAJ7gdfe4FRnns5CVptqUDq5/5xvfBZTsFX10QnuxBrec92+RcvmXbJt4PjA
         RYTnfbO6x7t44QSIjkqpe1cVlwiKS/u/vtcqg7GAuh6xGFG08GnVzhK8KBT/APYCWw8G
         Rg3yw1NA6Tz1QlcSjhq5ioyxzAhF8RDw/gL20=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 13:23:14 +0100
Message-Id: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
Subject: [PATCHSET] ata: rework support for PIIX-alike PATA controllers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The following patchset reworks support for PIIX-alike PATA controllers.

The first part rewrites code for programming PIO and MWDMA timings in the
affected host drivers, while also fixing other issues discovered during
the main task.  Then the second part adds support for non-Intel PIIX-alike
controllers to ata_piix host driver and removes separate host drivers.

All in all this greatly simplifies the total code needed for all PIIX-alikes
support (~1400 LOC are gone and 5 host drivers are removed) and hopefully
makes it easier to maintain it in the long-term (some drivers already got
slightly out-of-sync with ata_piix host driver, i.e. pata_rdc lacked locking
fixes and Power Management support, both issues are fixed by patchset).

All testing was done using QEMU's PIIX3 controller emulation so any testing
with real EFAR, IT8213, old PIIX, RDC and Radisys R82600 PATA controllers
would be really appreciated..

 -- Bartlomiej


The following changes since commit 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5:

  Linux 2.6.37 (2011-01-04 16:50:19 -0800)

are available:

Bartlomiej Zolnierkiewicz (20):
      ata_piix: SITRE handling fix
      ata_piix: unify code for programming PIO and MWDMA timings
      pata_efar: fix register naming used in efar_set_piomode()
      pata_efar: unify code for programming PIO and MWDMA timings
      pata_efar: always program master_data before slave_data
      pata_it8213: fix register naming used in it8213_set_piomode()
      pata_it8213: unify code for programming PIO and MWDMA timings
      pata_it8213: add UDMA100 and UDMA133 support
      pata_oldpiix: unify code for programming PIO and MWDMA timings
      pata_radisys: unify code for programming PIO and MWDMA timings
      pata_rdc: unify code for programming PIO and MWDMA timings
      pata_rdc: parallel scanning needs an extra locking
      pata_rdc: add Power Management support
      pata_oldpiix: add locking for parallel scanning
      pata_oldpiix: enable parallel scan
      ata_piix: add EFAR SLC90E66 support
      ata_piix: add IT8213 support
      ata_piix: add RDC support
      ata_piix: add Intel old PIIX support
      ata_piix: add Radisys R82600 support

 drivers/ata/Kconfig        |    5 +
 drivers/ata/Makefile       |    5 -
 drivers/ata/ata_piix.c     |  410 +++++++++++++++++++++++++++++++++-----------
 drivers/ata/pata_efar.c    |  319 ----------------------------------
 drivers/ata/pata_it8213.c  |  313 ---------------------------------
 drivers/ata/pata_oldpiix.c |  289 -------------------------------
 drivers/ata/pata_radisys.c |  268 -----------------------------
 drivers/ata/pata_rdc.c     |  401 -------------------------------------------
 8 files changed, 315 insertions(+), 1695 deletions(-)
 delete mode 100644 drivers/ata/pata_efar.c
 delete mode 100644 drivers/ata/pata_it8213.c
 delete mode 100644 drivers/ata/pata_oldpiix.c
 delete mode 100644 drivers/ata/pata_radisys.c
 delete mode 100644 drivers/ata/pata_rdc.c
