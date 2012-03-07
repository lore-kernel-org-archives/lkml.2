Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab2CGLko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:40:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab2CGLkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:40:43 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] Add a per-dimm structure
Date: Wed,  7 Mar 2012 08:40:32 -0300
Message-Id: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare the internal structures to represent the memory properties per dimm, 
instead of per csrow. 

This is needed for modern controllers with more than 2 channels, as the memories 
at the same slot number but on different channels (or channel pairs) may be 
different.

Mauro Carvalho Chehab (6):
  edac: Create a dimm struct and move the labels into it
  edac: Add per dimm's sysfs nodes
  edac: move dimm properties to struct memset_info
  edac: Don't initialize csrow's first_page & friends when not needed
  edac: move nr_pages to dimm struct
  edac: Add per-dimm sysfs show nodes

 drivers/edac/amd64_edac.c      |   73 +++--------
 drivers/edac/amd76x_edac.c     |   14 ++-
 drivers/edac/cell_edac.c       |   18 ++-
 drivers/edac/cpc925_edac.c     |   70 ++++++-----
 drivers/edac/e752x_edac.c      |   48 ++++---
 drivers/edac/e7xxx_edac.c      |   49 ++++---
 drivers/edac/edac_mc.c         |   97 ++++++++++-----
 drivers/edac/edac_mc_sysfs.c   |  269 +++++++++++++++++++++++++++++++++++++---
 drivers/edac/i3000_edac.c      |   24 ++--
 drivers/edac/i3200_edac.c      |   24 ++--
 drivers/edac/i5000_edac.c      |   31 ++---
 drivers/edac/i5100_edac.c      |   56 ++++++---
 drivers/edac/i5400_edac.c      |   38 ++----
 drivers/edac/i7300_edac.c      |   40 +++----
 drivers/edac/i7core_edac.c     |   41 +++----
 drivers/edac/i82443bxgx_edac.c |   15 ++-
 drivers/edac/i82860_edac.c     |   13 ++-
 drivers/edac/i82875p_edac.c    |   22 +++-
 drivers/edac/i82975x_edac.c    |   28 +++--
 drivers/edac/mpc85xx_edac.c    |   16 ++-
 drivers/edac/mv64x60_edac.c    |   22 ++--
 drivers/edac/pasemi_edac.c     |   24 ++--
 drivers/edac/ppc4xx_edac.c     |   25 ++--
 drivers/edac/r82600_edac.c     |   13 ++-
 drivers/edac/sb_edac.c         |   39 +++---
 drivers/edac/tile_edac.c       |   17 ++--
 drivers/edac/x38_edac.c        |   24 ++--
 include/linux/edac.h           |  139 +++++++++++++++------
 28 files changed, 808 insertions(+), 481 deletions(-)

-- 
1.7.8

