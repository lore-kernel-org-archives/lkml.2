Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390Ab0E0Rqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:46:40 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:57918 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab0E0Rqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:46:38 -0400
Date: Thu, 27 May 2010 13:46:35 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: sfi-devel@simplefirmware.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] SFI patches for 2.6.35-merge
Message-id: <alpine.LFD.2.00.1005271343050.4127@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git sfi-release

This will update the files shown below.

thanks!
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on sfi-devel@simplefirmware.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/sfi/patches/2.6.34/acpi-sfi-release-20100121-2.6.34.diff.gz

 Documentation/ABI/testing/sysfs-firmware-sfi |   15 ++++
 drivers/sfi/sfi_acpi.c                       |   41 ++++++++++
 drivers/sfi/sfi_core.c                       |  105 +++++++++++++++++++++++++-
 drivers/sfi/sfi_core.h                       |    8 ++
 include/linux/sfi.h                          |   24 ++++++-
 5 files changed, 191 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-sfi

through these commits:

Feng Tang (2):
      SFI: add support for v0.81 spec
      SFI: add sysfs interface for SFI tables.

with this log:

commit dce80a56268fffd6b5ea57b3f6ba3d027a68f05e
Author: Feng Tang <feng.tang@intel.com>
Date:   Wed May 26 11:28:08 2010 +0800

    SFI: add sysfs interface for SFI tables.
    
    Analogous to ACPI's /sys/firmware/acpi/tables/...
    
    create /sys/firmware/sfi/tables/
    
    The tables are primariy for the kernel,
    but sometimes it is useful for user-space to be
    able to read them.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5487ab4a5a71e955fef7094a0624df0542da91ef
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue May 25 16:40:47 2010 +0800

    SFI: add support for v0.81 spec
    
    There are 2 major changes from v0.81 to v0.7:
    1. Consolidating the SPIB/I2CB tables into a new DEVS table,
       which is more expandable and can support other bus types
       than spi/i2c.
    2. Creating a new GPIO table, which list all the GPIO pins
       used in the platform.
    
    However, to avoid breaking current platforms who use SFI v0.7
    version firmware, the definitions for SPIB/I2CB will still
    be kept for a while
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
