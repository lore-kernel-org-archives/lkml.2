Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab2DPUi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:38:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab2DPUiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:38:55 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [EDAC ABI v13 00/25] Fix EDAC userspace ABI
Date: Mon, 16 Apr 2012 17:38:24 -0300
Message-Id: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the remaining EDAC patches needed to fix the EDAC userspace
ABI.

They add a trace-based mechanism for error report (HERM), convert
the EDAC MC kobj into struct devices and adds a new ABI capable
of properly work with FB-DIMMs and RAMBUSes memory controllers,
as well as with Nehalem/Sandy Bridge ones.

>From what it was planned originally for this patch series, a few
things are left from this series, because of all upstream noise
on getting it merged:
	- Docbook patches;
	- Error Counters: they deserve a separate patch series;
	- a MCE-based trace event;

I'll write the Docbook patch in the sequence, just after having this
series merged at -next.

The other two items deserve some discussions upstream.

Regards,
Mauro.

Mauro Carvalho Chehab (25):
  edac: Initialize the dimm label with the known information
  edac: Cleanup the logs for i7core and sb edac drivers
  i5400_edac: improve debug messages to better represent the filled
    memory
  events/hw_event: Create a Hardware Events Report Mecanism (HERM)
  i5000_edac: Fix the logic that retrieves memory information
  e752x_edac: provide more info about how DIMMS/ranks are mapped
  edac: Rename the parent dev to pdev
  edac: use Documentation-nano format for some data structs
  edac: rewrite the sysfs code to use struct device
  mpc85xx_edac: convert sysfs logic to use struct device
  amd64_edac: convert sysfs logic to use struct device
  i7core_edac: convert it to use struct device
  edac: Get rid of the old kobj's from the edac mc code
  edac: add a new per-dimm API and make the old per-virtual-rank API
    obsolete
  edac: add a sysfs node to report the maximum location for the system
  edac: Add debufs nodes to allow doing fake error inject
  edac: Create a per-Memory Controller bus
  edac: Move grain/dtype/edac_type calculus to be out of channel loop
  i82975x_edac: Test nr_pages earlier to save a few CPU cycles
  i5100_edac: Fix a warning when compiled with 32 bits
  i7300_edac: Get rid of some wrongly-solved rebase conflict
  edac: Only expose csrows/channels on legacy API if they're populated
  edac: Fix a typo at edac_mc_sysfs
  edac: change the mem allocation scheme to make
    Documentation/kobject.txt happy
  i7core_edac: change the mem allocation scheme to make
    Documentation/kobject.txt happy

 drivers/edac/Kconfig            |    8 +
 drivers/edac/amd64_edac.c       |   53 +-
 drivers/edac/amd64_edac.h       |   29 +-
 drivers/edac/amd64_edac_dbg.c   |   89 ++--
 drivers/edac/amd64_edac_inj.c   |  128 +++--
 drivers/edac/amd76x_edac.c      |   12 +-
 drivers/edac/cell_edac.c        |   20 +-
 drivers/edac/cpc925_edac.c      |   64 +-
 drivers/edac/e752x_edac.c       |   63 ++-
 drivers/edac/e7xxx_edac.c       |   38 +-
 drivers/edac/edac_core.h        |    2 +-
 drivers/edac/edac_mc.c          |  195 ++++--
 drivers/edac/edac_mc_sysfs.c    | 1355 ++++++++++++++++++++-------------------
 drivers/edac/edac_module.c      |   13 +-
 drivers/edac/edac_module.h      |    9 +-
 drivers/edac/i3000_edac.c       |   10 +-
 drivers/edac/i3200_edac.c       |   10 +-
 drivers/edac/i5000_edac.c       |  155 +++---
 drivers/edac/i5100_edac.c       |    6 +-
 drivers/edac/i5400_edac.c       |   23 +-
 drivers/edac/i7300_edac.c       |    5 +-
 drivers/edac/i7core_edac.c      |  365 +++++++----
 drivers/edac/i82443bxgx_edac.c  |    8 +-
 drivers/edac/i82860_edac.c      |   10 +-
 drivers/edac/i82875p_edac.c     |   14 +-
 drivers/edac/i82975x_edac.c     |   23 +-
 drivers/edac/mpc85xx_edac.c     |  103 ++--
 drivers/edac/mv64x60_edac.c     |    6 +-
 drivers/edac/pasemi_edac.c      |   14 +-
 drivers/edac/ppc4xx_edac.c      |    8 +-
 drivers/edac/r82600_edac.c      |    8 +-
 drivers/edac/sb_edac.c          |   33 +-
 drivers/edac/tile_edac.c        |    8 +-
 drivers/edac/x38_edac.c         |   10 +-
 include/linux/edac.h            |  180 ++++--
 include/trace/events/hw_event.h |  107 +++
 36 files changed, 1810 insertions(+), 1374 deletions(-)
 create mode 100644 include/trace/events/hw_event.h

-- 
1.7.8

