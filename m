Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966902Ab2EQO5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 10:57:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65110 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966601Ab2EQO52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 10:57:28 -0400
X-AuditID: cbfee61b-b7bb6ae0000006fb-ca-4fb511d6aa9e
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH v2 0/6] mmc: dw_mmc: add support for device tree based
 instantiation
Date: Thu, 17 May 2012 20:40:05 +0530
Message-id: <1337267411-28226-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is the second version of the patches that adds device tree
support for Synopsis Designware Mobile Storage Host Controller.

The first patch converts the copy of controller device instance into a
reference. This is need to allow device resource management api to correctly
manage the resources allocated by the driver. The second patch fixes the
incorrect abort of the probe in case a slot initialization fails. This is
fixed by allowing as many slots to be initialized successfully and failing
only if there are no slots that were initialized.

The third patch adds clock lookup in the driver and this is optional. Platforms
that do not need any clock gating and control for the dw_mmc controllers will
not be affected with this change. The fourth patch adds a quirk to notify the
controller about the absence of the write protect line.

The fifth patch adds device tree based discovery support for the dw_mmc driver.
The sixth patch add Samsung Exynos5250 specific extentions to the driver.

Thomas Abraham (6):
  mmc: dw_mmc: convert copy of struct device in struct dw_mci to a reference
  mmc: dw_mmc: allow probe to succeed even if one slot is initialized
  mmc: dw_mmc: lookup for optional biu and ciu clocks
  mmc: dw_mmc: add quirk to indicate missing write protect line
  mmc: dw_mmc: add device tree support
  mmc: dw_mmc: add samsung exynos5250 specific extentions

 .../devicetree/bindings/mmc/synposis-dw-mshc.txt   |  139 ++++++++
 drivers/mmc/host/dw_mmc-pltfm.c                    |   41 +++-
 drivers/mmc/host/dw_mmc.c                          |  362 +++++++++++++++++---
 drivers/mmc/host/dw_mmc.h                          |   23 ++
 include/linux/mmc/dw_mmc.h                         |   17 +-
 5 files changed, 530 insertions(+), 52 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt

