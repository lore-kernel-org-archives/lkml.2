Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab0FBPQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:16:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:58274 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563Ab0FBPQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:16:22 -0400
Date: Wed, 2 Jun 2010 15:15:52 +0000
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, lenb@kernel.org,
       michaelc@cs.wisc.edu
Subject: [GIT PULL] iBFT features for 2.6.35-rc1
Message-ID: <20100602151552.GA18899@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Jun 2010 15:15:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

	git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git for-linus

Hopefully I am not too late with a git request for these features.
This pull requests consists of new features to the iBFT* driver. Specifically:

 - support v1.03 of the spec. The spec in question is available at:
   ftp://ftp.software.ibm.com/systems/support/bladecenter/iscsi_boot_firmware_table_v1.03.pdf
 - separate the iBFT parsing from the SysFS interface. Paves the road
   for the iSCSI hardware NICs to use the SysFS format for a unified look&feel.

These patches have been through a few rounds of review and have been in
linux-next for weeks now.

Thanks,
Konrad

Konrad Rzeszutek Wilk (1):
      ibft: For UEFI machines actually do scan ACPI for iBFT.

Mike Christie (2):
      ibft: separate ibft parsing from sysfs interface
      ibft: convert iscsi_ibft module to iscsi boot lib

Peter Jones (2):
      ibft: Update iBFT handling for v1.03 of the spec.
      ibft: Use IBFT_SIGN instead of open-coding the search string.

 drivers/firmware/Kconfig            |    9 +
 drivers/firmware/Makefile           |    1 +
 drivers/firmware/iscsi_boot_sysfs.c |  481 +++++++++++++++++++++++
 drivers/firmware/iscsi_ibft.c       |  726 +++++++++++++----------------------
 drivers/firmware/iscsi_ibft_find.c  |   56 +++-
 include/linux/iscsi_boot_sysfs.h    |  123 ++++++
 include/linux/iscsi_ibft.h          |   12 +-
 7 files changed, 924 insertions(+), 484 deletions(-)
 create mode 100644 drivers/firmware/iscsi_boot_sysfs.c
 create mode 100644 include/linux/iscsi_boot_sysfs.h

* What is iBFT?
The iBFT is an equivalent to the Boot Flag, except that its geared
towards iSCSI and hence requires much more information (such as
the IP of target, passwords, which device to login, etc). iBFT
is a data structure populated by the BIOS or the NIC to contain this
so that the OS can read it and login to the iSCSI and present
the boot device to the initrd for mounting / FS.

