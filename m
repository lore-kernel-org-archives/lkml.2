Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634Ab2C2QqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:46:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759577Ab2C2Qpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:45:52 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: [PATCH 00/13] Convert EDAC internal strutures to support all types of Memory Controllers
Date: Thu, 29 Mar 2012 13:45:33 -0300
Message-Id: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the 12th and final rebase of this patch series.

It is the first patchset for the EDAC rewrite. On this patchset,
there are all the internal changes at the EDAC core, needed
to properly represent memories at modern memory controllers that
aren't oriented per rank/channel.

It is needed in order to fix a long-term bug at the EDAC drivers
for the Intel memory controllers deployed since 2005 (well, in fact,
there is one Rambus that it is older, but also suffers from the same
syndrome), including the drivers for the recent Intel Nehalem and
Sandy Bridge architectures.

The new EDAC architecture supports both per rank/channel memory
controllers and per-DIMM ones.

On this changeset, there are no changes at the sysfs nodes. Just 
like before this changeset, non-per-rank memory controllers 
will expose memories as "virtual csrows/virtual channels[1].

[1] It sounds better to say "virtual" than to admit that all
EDAC Intel drivers since 2005 need to lie about their age to
the EDAC core, in order for the Kernel to accept them ;)

Mauro Carvalho Chehab (13):
  edac: Create a dimm struct and move the labels into it
  edac: move dimm properties to struct memset_info
  edac: Don't initialize csrow's first_page & friends when not needed
  edac: move nr_pages to dimm struct
  edac: Fix core support for MC's that see DIMMS instead of ranks
  edac: Initialize the dimm label with the known information
  edac: Cleanup the logs for i7core and sb edac drivers
  i5400_edac: improve debug messages to better represent the filled
    memory
  events/hw_event: Create a Hardware Events Report Mecanism (HERM)
  i5000_edac: Fix the logic that retrieves memory information
  e752x_edac: provide more info about how DIMMS/ranks are mapped
  edac: Rename the parent dev to pdev
  edac: use Documentation-nano format for some data structs

 drivers/edac/amd64_edac.c       |  210 +++++++------
 drivers/edac/amd76x_edac.c      |   48 ++-
 drivers/edac/cell_edac.c        |   54 ++-
 drivers/edac/cpc925_edac.c      |   95 ++++---
 drivers/edac/e752x_edac.c       |  121 +++++---
 drivers/edac/e7xxx_edac.c       |   90 ++++--
 drivers/edac/edac_core.h        |   48 +--
 drivers/edac/edac_device.c      |   27 +-
 drivers/edac/edac_mc.c          |  688 ++++++++++++++++++++++++---------------
 drivers/edac/edac_mc_sysfs.c    |  160 ++++++----
 drivers/edac/edac_module.h      |    2 +-
 drivers/edac/edac_pci.c         |    7 +-
 drivers/edac/i3000_edac.c       |   55 ++-
 drivers/edac/i3200_edac.c       |   64 ++--
 drivers/edac/i5000_edac.c       |  227 +++++++------
 drivers/edac/i5100_edac.c       |  108 +++----
 drivers/edac/i5400_edac.c       |  266 ++++++++-------
 drivers/edac/i7300_edac.c       |  119 +++----
 drivers/edac/i7core_edac.c      |  245 ++++----------
 drivers/edac/i82443bxgx_edac.c  |   47 ++-
 drivers/edac/i82860_edac.c      |   61 +++--
 drivers/edac/i82875p_edac.c     |   57 +++-
 drivers/edac/i82975x_edac.c     |   63 +++--
 drivers/edac/mpc85xx_edac.c     |   48 ++-
 drivers/edac/mv64x60_edac.c     |   49 ++-
 drivers/edac/pasemi_edac.c      |   57 ++--
 drivers/edac/ppc4xx_edac.c      |   66 ++--
 drivers/edac/r82600_edac.c      |   46 ++-
 drivers/edac/sb_edac.c          |  207 +++++--------
 drivers/edac/tile_edac.c        |   37 ++-
 drivers/edac/x38_edac.c         |   60 ++--
 include/linux/edac.h            |  244 +++++++++++---
 include/trace/events/hw_event.h |  107 ++++++
 33 files changed, 2195 insertions(+), 1588 deletions(-)
 create mode 100644 include/trace/events/hw_event.h

-- 
1.7.8

