Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0KZTIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:08:18 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46300 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab0KZTFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:19 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 00/16] amd64_edac stuff for .38
Date: Fri, 26 Nov 2010 20:04:07 +0100
Message-Id: <1290798263-13074-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

here's my patchqueue with amd64_edac improvements/fixes for .38. What
stands out is the removal of the two-staged driver initialization.
Also, the scrubrate interface is a bit more sane now. The rest is a lot
of dead/unused code removal (diffstat says it all) in preparation for
Bulldozer support.

Also, it needs tip:amd-nb to be present on the branch before merging the
series ontop.

Borislav Petkov (16):
  amd64_edac: Remove F11h support
  amd64_edac: Use cached extended CPU model
  amd64_edac: Add per-family init function
  amd64_edac: Simplify CPU family detection
  amd64_edac: Cleanup the CPU PCI device reservation
  amd64_edac: Concentrate per-family init even more
  amd64_edac: Rename CPU PCI devices
  amd64_edac: Rework printk macros
  amd64_edac: Allocate driver instances dynamically
  amd64_edac: Remove explicit Kconfig PCI dependency
  amd64_edac: Remove PCI ECS enabling functions
  amd64_edac: Carve out ECC-related hw settings
  amd64_edac: Check ECC capabilities initially
  amd64_edac: Remove two-stage initialization
  EDAC: Fixup scrubrate manipulation
  amd64_edac: Disable DRAM ECC injection on K8

 drivers/edac/Kconfig          |    8 +-
 drivers/edac/amd64_edac.c     |  823 +++++++++++++++++------------------------
 drivers/edac/amd64_edac.h     |   86 ++---
 drivers/edac/amd64_edac_inj.c |   25 +-
 drivers/edac/cpc925_edac.c    |    9 +-
 drivers/edac/e752x_edac.c     |    8 +-
 drivers/edac/edac_core.h      |    5 +-
 drivers/edac/edac_mc.c        |    4 +-
 drivers/edac/edac_mc_sysfs.c  |   57 ++--
 drivers/edac/i5100_edac.c     |    9 +-
 10 files changed, 436 insertions(+), 598 deletions(-)

-- 
1.7.3.1.50.g1e633

