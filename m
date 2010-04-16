Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab0DPWbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 18:31:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:59620 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655Ab0DPWby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 18:31:54 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] iBFT features.
Date: Fri, 16 Apr 2010 22:31:13 +0000
Message-Id: <1271457077-9607-1-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.0.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 16 Apr 2010 22:31:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iBFT firmware driver has seen some action this last month.
Here is a short primer on what it is:
The iBFT is an equivalant to the Boot Flag, except that its geared
towards iSCSI and hence requires much more information (such as
the IP of target, passwords, which device to login, etc). iBFT
is a data structure populated by the BIOS or the NIC to contain this
so that the OS can read it and login to the iSCSI and present
the boot device to the initrd for mounting / FS.

There has been two big features added in:

1) Updated to support the 1.03 of the spec:
ftp://ftp.software.ibm.com/systems/support/bladecenter/iscsi_boot_firmware_table_v1.03.pdf

2) Split in two modules: one presentation that exports SysFS
entries and the other that actually contains the iBFT data. The
presentation driver paves the road for iSCSI hardware drivers
(QLogic iSCSI HBA for example) to present the boot information
they contain via this SysFS interface as they don't put the
data in iBFT format.

Please pull the 'for-linus' branch of 
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git for-linus

Thank you!

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


