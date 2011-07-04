Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab1GDLKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 07:10:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60643 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab1GDLKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 07:10:05 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: paul@pwsan.com, b-cousson@ti.com, vishwanath.bs@ti.com, p-basak2@ti.com,
        peter.ujfalusi@ti.com, jhnikula@gmail.com, kishon@ti.com, charu@ti.com
Subject: [PATCH v3 0/2] OMAP: omap_device: API to modify SYSCONFIG register
Date: Mon, 4 Jul 2011 16:38:31 +0530
Message-ID: <1309777713-17528-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain peripherals require autoidle bits to be disabled before performing
some operations. This patch series provides APIs in omap_device layer and 
omap_hwmod layer to modify the SYSCONFIG register.

Since current implementation of PM run time framework does not support
changing sysconfig settings during middle of the on going operation,
these APIs will support the same.

For e.g McBSP 2 and 3 in OMAP3 has sidetone feature which requires
autoidle to be disabled before starting the sidetone.

McBSP also requires the SYSCONFIG to be in NOIDLE when ELEMENTSYNCH
mode is selected for DMA operation.

Created on top of linux OMAP master (linux-omap-2.6 :master)
commit-id: d9be6df1331f8078618745298d38ed619729ec91
Tested on OMAP4430 and OMAP3430 SDP boards. Verified that this patch
series does not break the OMAP1 build.

V3:
created one-one mapping between omap_device APIs and omap_hwmod APIs to
modify the sysconfig register.

V2:
Mutex is replaced with spinlock.

V1:
* Creates 3 separate API's to change the idle mode to NOIDLE, SMARTIDLE
 and FORCEIDLE and one more API to change the idlemode to default value
 based on the hwmod flag. This change is done to align with the discussion
 on [3]

* Added hwmod mutex in omap hwmod APIs that modifies SYSCONFIG register.

* omap_hwmod_set_slave_idlemode() is not modified to take true/false kind-of
argument since 3 states are associated with SIDLE bits (force, no and smart).

These changes were made to align with Benoit's and Paul's comments for a
similar patch written by Manjunath [1] for changing MSTANDBY bits.

The discussions that happened for the RFC patch can be found at [2]

[1]: http://www.mail-archive.com/linux-omap <at> vger.kernel.org/msg39647.html
[2]: https://patchwork.kernel.org/patch/134371/
[3]: http://www.mail-archive.com/linux-omap <at> vger.kernel.org/msg39615.html

Kishon Vijay Abraham I (2):
  OMAP: omap_hwmod: API to modify AUTOIDLE and SMARTIDLE bits
  OMAP: omap_device: API to modify AUTOIDLE and SMARTIDLE bits

 arch/arm/mach-omap2/omap_hwmod.c              |   93 ++++++++++++++
 arch/arm/plat-omap/include/plat/omap_device.h |    6 +
 arch/arm/plat-omap/include/plat/omap_hwmod.h  |   11 ++
 arch/arm/plat-omap/omap_device.c              |  165 +++++++++++++++++++++++++
 4 files changed, 275 insertions(+), 0 deletions(-)

