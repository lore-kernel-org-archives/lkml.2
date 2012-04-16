Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2DPUMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:12:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab2DPUMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:12:21 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [EDAC PATCH v13 0/7] Convert EDAC core to work with non-csrow-based memory controllers
Date: Mon, 16 Apr 2012 17:12:06 -0300
Message-Id: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is the first patchset for the EDAC rewrite. On this patchset,
there are all the internal changes at the EDAC core, needed
to properly represent memories at modern memory controllers that
aren't oriented per rank/channel.

Drivers will be changed by the next changeset.

This series is needed in order to fix a long-term bug at the EDAC drivers
for the Intel memory controllers deployed since 2005 (well, in fact,
there is one Rambus that it is older, but also suffers from the same
syndrome), including the drivers for the recent Intel Nehalem and
Sandy Bridge architectures.

The new EDAC architecture supports both per rank/channel memory
controllers and per-DIMM ones.

On this changeset, there are no changes at the Kernel-Userspace
API. All changes are at the EDAC kernel API used by the drivers.

Mauro Carvalho Chehab (7):
  edac: Create a dimm struct and move the labels into it
  edac: move dimm properties to struct dimm_info
  edac: Don't initialize csrow's first_page & friends when not needed
  edac: move nr_pages to dimm struct
  edac: rewrite edac_align_ptr()
  edac.h: Prepare to handle with generic layers
  edac: Change internal representation to work with layers

 drivers/edac/amd64_edac.c      |   66 +---
 drivers/edac/amd76x_edac.c     |   14 +-
 drivers/edac/cell_edac.c       |   18 +-
 drivers/edac/cpc925_edac.c     |   70 +++--
 drivers/edac/e752x_edac.c      |   48 ++--
 drivers/edac/e7xxx_edac.c      |   49 ++--
 drivers/edac/edac_core.h       |   92 +++++-
 drivers/edac/edac_device.c     |   27 +-
 drivers/edac/edac_mc.c         |  691 ++++++++++++++++++++++++++--------------
 drivers/edac/edac_mc_sysfs.c   |   62 +++--
 drivers/edac/edac_module.h     |    2 +-
 drivers/edac/edac_pci.c        |    7 +-
 drivers/edac/i3000_edac.c      |   24 +-
 drivers/edac/i3200_edac.c      |   24 +-
 drivers/edac/i5000_edac.c      |   31 +-
 drivers/edac/i5100_edac.c      |   46 ++--
 drivers/edac/i5400_edac.c      |   38 +--
 drivers/edac/i7300_edac.c      |   40 +--
 drivers/edac/i7core_edac.c     |   40 +--
 drivers/edac/i82443bxgx_edac.c |   15 +-
 drivers/edac/i82860_edac.c     |   13 +-
 drivers/edac/i82875p_edac.c    |   22 +-
 drivers/edac/i82975x_edac.c    |   30 ++-
 drivers/edac/mpc85xx_edac.c    |   16 +-
 drivers/edac/mv64x60_edac.c    |   22 +-
 drivers/edac/pasemi_edac.c     |   24 +-
 drivers/edac/ppc4xx_edac.c     |   25 +-
 drivers/edac/r82600_edac.c     |   13 +-
 drivers/edac/sb_edac.c         |   37 +--
 drivers/edac/tile_edac.c       |   17 +-
 drivers/edac/x38_edac.c        |   24 +-
 include/linux/edac.h           |  164 ++++++++--
 32 files changed, 1099 insertions(+), 712 deletions(-)

-- 
1.7.8

