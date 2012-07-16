Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab2GPTVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:21:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37725 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2GPTVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:21:34 -0400
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Paul Walmsley <paul@pwsan.com>
Cc: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Kevin Hilman <khilman@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@copitl.com>
Subject: [PATCH 0/3] OMAP: hwmod: reset API proposal
Date: Mon, 16 Jul 2012 14:21:22 -0500
Message-Id: <1342466485-1050-1-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Omar Ramirez Luna <omar.ramirez@copitl.com>

***
RESEND: http://bit.ly/PZDbcc
Needed for ipu, dsp and their mmu reset lines.
***

Recent changes in omap_hwmod framework have reworked the behaviour
towards hardreset handling, commit 747834a (ARM: OMAP2+: hwmod:
revise hardreset behavior) recommends for drivers to implement
their own reset sequences until code out-of-tree hits mainline
and then their needs and code can be reviewed.

Since it is not clear when this will occur for all drivers and
hwmod code was not deleted (presumably because at some point it
will handle the resets once again), this series exports functions
to handle hardreset lines in an attempt to reduce code duplication
for those who have a common reset sequence.

These APIs are intended to be used by iommu for now, but were
tested with IPU and remoteproc on Pandaboard.

Omar Ramirez Luna (3):
  ARM: OMAP: hwmod: partially un-reset hwmods might not be properly
    enabled
  ARM: OMAP: hwmod: revise deassert sequence
  ARM: OMAP: omap_device: expose hwmod assert/deassert to omap devices

 arch/arm/mach-omap2/omap_hwmod.c              |   70 +++++++++++++++++++-----
 arch/arm/plat-omap/include/plat/omap_device.h |    4 ++
 arch/arm/plat-omap/omap_device.c              |   45 ++++++++++++++++
 3 files changed, 104 insertions(+), 15 deletions(-)

-- 
1.7.4.1

