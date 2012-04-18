Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab2DRJWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:22:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47241 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2DRJWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:22:22 -0400
X-AuditID: cbfee61b-b7cb4ae000000d81-b7-4f8e87cd1112
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: k.lewandowsk@samsung.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, broonie@opensource.wolfsonmicro.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Subject: [PATCH v5 0/2] regulator: add irq domain and device tree support for
 MAX8997
Date: Wed, 18 Apr 2012 15:01:01 +0530
Message-id: <1334741463-25058-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v4:
- Removed redundant irq_to_max8997_irq function.
- Fixed the bug in lookup of regulator names
- Inculded documentation of additional regulators supported.
- Rebased to Mark's latest 'for-next' branch

Changes since v3:
- Fixed all comments from Grant Likely.
  - In patch 1/2, since linear mapping is used, the handle_nested_irq() is
    called only for allocated irq's.
  - In patch 2/2, the incorrect assignment of platform data pointer to
    dev->platform_data is reworked and fixed.

Changes since v2:
- Atleast one voltage level has to be specfied for Buck 1/2/5 even if GPIO
  DVS option is not used (suggested by MyungJoo Ham).
- Reworked the irq_domain support based the v5 of irq_domain generalization
  patches.

MAX8997 is a multi-function device which includes support for regulators, rtc,
battery charger and other sub-blocks. This patchset adds device tree support
for the pmic (regulators) sub-block.

The first patch adds irq domain support for the interrupts supported by max8997
mainly for removing the need to pass a irq_base from the platform code. The
irq_base could not anyway be passed in case of device tree based instantiation.
The reverse mapping method used is linear since the sub-drivers of max8997 has
access to the max8997 irq_domain from which the linux irq number can be
obtained.

The second patch adds device tree support for max8997. This patch modifies both
mfd and regulator portions of the max8997 code.

This patchset is based on the following tree.
http://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git [for-next]

with all patches merged from
http://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git [for-next]
http://git.secretlab.ca/git/linux-2.6.git [irqdomain/next]

This patchset has been tested on Origen board.

Thomas Abraham (2):
  mfd: add irq domain support for max8997 interrupts
  regulator: add device tree support for max8997

 .../devicetree/bindings/regulator/max8997-pmic.txt |  147 +++++++++++++++++++
 arch/arm/mach-exynos/mach-nuri.c                   |    4 -
 arch/arm/mach-exynos/mach-origen.c                 |    1 -
 drivers/mfd/max8997-irq.c                          |   70 +++++-----
 drivers/mfd/max8997.c                              |   74 ++++++++++-
 drivers/regulator/max8997.c                        |  148 +++++++++++++++++++-
 include/linux/mfd/max8997-private.h                |    5 +-
 include/linux/mfd/max8997.h                        |    2 +-
 8 files changed, 406 insertions(+), 45 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/max8997-pmic.txt

