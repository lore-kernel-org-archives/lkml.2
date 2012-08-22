Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab2HVFmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:42:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39496 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab2HVFmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:42:40 -0400
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Benoit Cousson <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: [PATCH 0/2] OMAP: hwmod: fix hardreset handling
Date: Wed, 22 Aug 2012 00:42:28 -0500
Message-Id: <1345614150-25723-1-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Omar Ramirez Luna <omar.ramirez@ti.com>

The patch to expose hwmod assert/deassert functions through omap_device
has been accepted and queued for 3.7[1], however these two patches are
needed to make the API functional. Hence a revised version is being sent
according to previous comments:

- ARM: OMAP: hwmod: revise deassert sequence
Now it uses enable|disable_module to handle the configuration of the
modulemode inside CLKCTRL. As part of the cleanup of leaf clocks, the
one associated with ipu_mmu will be removed along with the iommu hwmod
migration[2].

- ARM: OMAP: hwmod: partially un-reset hwmods might not be properly
  enabled
More infomation added in the patch description[3].

[1] http://patchwork.kernel.org/patch/1266731/
[2] http://patchwork.kernel.org/patch/1201791/
[3] http://patchwork.kernel.org/patch/1201801/

Omar Ramirez Luna (2):
  ARM: OMAP: hwmod: partially un-reset hwmods might not be properly
    enabled
  ARM: OMAP: hwmod: revise deassert sequence

 arch/arm/mach-omap2/omap_hwmod.c |   74 ++++++++++++++++++++++++++++++--------
 1 file changed, 59 insertions(+), 15 deletions(-)

-- 
1.7.9.5

