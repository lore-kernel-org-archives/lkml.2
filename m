Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab0LNNGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 08:06:19 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:44504 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759205Ab0LNNGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 08:06:18 -0500
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <Hiroshi.DOYU@nokia.com>, <linux@arm.linux.org.uk>, <h-kanigeri2@ti.com>
Cc: <felipe.contreras@nokia.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <tony@atomide.com>, Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCH 0/4] omap: iovmm - fixes for iovmm module
Date: Tue, 14 Dec 2010 07:07:23 -0600
Message-Id: <1292332047-8206-1-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 6:
* Rebase on Russell King branch.
 - for details see:
 http://marc.info/?l=linux-omap&m=129228495723001&w=2

Version 5:
* Changes in "iommu: create new api to set valid da range"
 - Change range variables to platform data structure.

Version 4:
* Changes in "iommu: create new api to set valid da range"
 - Validate range for fixed address.
 - Change way of change boundaries to avoid possible overflow
   instead of style :
      start + bytes >= end     which start + end can overflow
   use style:
      end - start < bytes

Version 3:
* change patch 2 base on Felipe Contreras' comments,
 now it uses min_t and I deleted some blank lines.
* patch "create new api to set valid da range" is base on
 "iovmm: IVA2 MMU range is from 0x11000000 to 0xFFFFFFFF"
 patch and on Hiroshi's comments and now it is added to
 this set.

Version 2:
* Removed "iovmm: fixes for iovmm module" that patch was already
 sent.
* Modified "iovmm: fix roundup for next area and end check for the
 last area" patch, base on Davin Cohen's comments and rename it
 to a proper name that describes what it is doing now.

Guzman Lugo, Fernando (4):
  omap: iovmm - no gap checking for fixed address
  omap: iovmm - add superpages support to fixed da address
  omap: iovmm - replace __iounmap with iounmap
  omap: iommu - create new api to set valid da range

 arch/arm/plat-omap/include/plat/iommu.h |    3 +
 arch/arm/plat-omap/iommu.c              |   33 ++++++++++++
 arch/arm/plat-omap/iovmm.c              |   84 ++++++++++++++++++-------------
 3 files changed, 85 insertions(+), 35 deletions(-)

-- 
1.7.3.2

