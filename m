Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab0EKUtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:49:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:39503 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab0EKUtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:49:39 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] iBFT features: Update to iBFT 1.03 and separate ibft parsing from sysfs interface
Date: Tue, 11 May 2010 18:04:13 +0000
Message-Id: <1273601057-5907-1-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 May 2010 20:49:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit 94b849aaf6e22ab7bf54b0d0377a882d4892396d

    Merge branch 'fix/hda' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
    
are available in the git repository at:

	git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git for-akpm

Konrad Rzeszutek Wilk (1):
      ibft: For UEFI machines actually do scan ACPI for iBFT.

Mike Christie (2):
      ibft: separate ibft parsing from sysfs interface
      ibft: convert iscsi_ibft module to iscsi boot lib

Peter Jones (1):
      ibft: Update iBFT handling for v1.03 of the spec.

 drivers/firmware/Kconfig            |    9 +
 drivers/firmware/Makefile           |    1 +
 drivers/firmware/iscsi_boot_sysfs.c |  481 +++++++++++++++++++++++
 drivers/firmware/iscsi_ibft.c       |  726 +++++++++++++----------------------
 drivers/firmware/iscsi_ibft_find.c  |   55 ++-
 include/linux/iscsi_boot_sysfs.h    |  123 ++++++
 include/linux/iscsi_ibft.h          |   12 +-
 7 files changed, 923 insertions(+), 484 deletions(-)
 create mode 100644 drivers/firmware/iscsi_boot_sysfs.c
 create mode 100644 include/linux/iscsi_boot_sysfs.h

This pull requests consists of features to the iBFT driver. Specifically:

 - support v1.03 of the spec. The spec in question is available at:
   ftp://ftp.software.ibm.com/systems/support/bladecenter/iscsi_boot_firmware_table_v1.03.pdf
 - separate the iBFT parsing from the SysFS interface.


What is iBFT?
The iBFT is an equivalent to the Boot Flag, except that its geared
towards iSCSI and hence requires much more information (such as
the IP of target, passwords, which device to login, etc). iBFT
is a data structure populated by the BIOS or the NIC to contain this
so that the OS can read it and login to the iSCSI and present
the boot device to the initrd for mounting / FS.

Thanks,

	Konrad
