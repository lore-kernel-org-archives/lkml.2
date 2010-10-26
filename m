Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab0JZM3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 08:29:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933069Ab0JZM3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 08:29:53 -0400
Message-ID: <4CC6C99C.8040004@redhat.com>
Date: Tue, 26 Oct 2010 10:29:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>
Subject: [GIT PULL for 2.6.36-rc1] i7core/nehalem EDAC driver fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
   ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core.git linux_next

For a bunch of fixes at the i7core_edac driver probe/remove logic, and on the 
sysfs methods added at edac_core in order to simplify private sysfs nodes
(currently used only by i7core_edac).

The previous logic were leaving some things behind on module remove, so, after
removing/reinserting the driver a few times, an OOPS/Panic were produced. They
also do a cleanup at the driver probe/remove logic, making them simpler and easier
to analyse.

The following changes since commit f6f94e2ab1b33f0082ac22d71f66385a60d8157f:

  Linux 2.6.36 (2010-10-20 13:30:22 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core.git linux_next

Hidetoshi Seto (15):
      i7core_edac: Fix the logic in i7core_remove()
      i7core_edac: Reduce args of i7core_get_onedevice
      i7core_edac: Introduce alloc_i7core_dev
      i7core_edac: Introduce free_i7core_dev
      i7core_edac: Introduce i7core_pci_ctl_create/release
      i7core_edac: Always do get/put for all devices
      i7core_edac: Fix order of lines in i7core_register_mci
      i7core_edac: Fix error path of i7core_register_mci
      i7core_edac: Call pci_dev_put() when alloc_i7core_dev()  failed
      i7core_edac: Check probe counter in i7core_remove
      i7core_edac: Use saved pointers
      i7core_edac: Introduce i7core_unregister_mci
      i7core_edac: Reduce args of i7core_register_mci
      i7core_edac: Remove unused arg csrow from get_dimm_config
      i7core_edac: Remove unused member channels in i7core_pvt

Mauro Carvalho Chehab (19):
      i7core_edac: Be sure that the edac pci handler will be properly released
      i7core_edac: move static vars to the beginning of the file
      i7core_edac: Properly mark const static vars as such
      i7core_edac: move #if PAGE_SHIFT to edac_core.h
      i7core_edac: Improve debug to seek for register/remove errors
      i7core_edac: Initialize all priv vars before start polling
      i7core_edac: MCE NMI handling should stop first
      i7core_edac: explicitly remove PCI devices from the devices list
      edac_core: Do a better job with node removal
      edac_core: Don't let free(mci) happen while using it
      edac_core: Print debug messages at release calls
      i7core_edac: don't use a freed mci struct
      i7core_edac: Don't do the legacy PCI probe by default
      i7core_edac: Fix an oops at i7core probe
      i7core_edac: it is safe to i7core_unregister_mci() when mci=NULL
      i7core_edac: Fix refcount error at PCI devices
      i7core_edac: Avoid PCI refcount to reach zero on successive load/reload
      i7core_edac: properly terminate pci_dev_table
      i7core_edac: return -ENODEV when devices were already probed

 drivers/edac/edac_core.h     |   11 +-
 drivers/edac/edac_mc.c       |   12 +-
 drivers/edac/edac_mc_sysfs.c |   82 +++++----
 drivers/edac/i7core_edac.c   |  432 ++++++++++++++++++++++++------------------
 4 files changed, 313 insertions(+), 224 deletions(-)
