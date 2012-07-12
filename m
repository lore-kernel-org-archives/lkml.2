Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2GLMkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:40:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34014 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2GLMkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:40:41 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-02-4ffec5c8247c
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH v3 0/6] mmc: dw_mmc: add support for device tree based
 instantiation
Date: Thu, 12 Jul 2012 18:24:22 +0530
Message-id: <1342097668-25243-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKJMWRmVeSWpSXmKPExsVy+t9jAd0TR//5G1xdI2pxedccNosj//sZ
	LWac38fkwOzxeZNcAGMUl01Kak5mWWqRvl0CV0bn6wvMBe/4Ky7vfMPUwDiPp4uRk0NCwETi
	+qHfjBC2mMSFe+vZuhi5OIQEFjFK7Ph2hR3CaWOSmNVwlxWkik3AQOLRwnfsILaIgJPEkrkT
	mEGKmAXuMEo8mnUSbJSwQJjEvI9bwRpYBFQllp25DGbzCnhKND5tYoVYpySxofco0wRG7gWM
	DKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgj37TGoH48oGi0OMAhyMSjy8Hw788xdiTSwr
	rsw9xCjBwawkwtufCxTiTUmsrEotyo8vKs1JLT7EKM3BoiTOa+z91V9IID2xJDU7NbUgtQgm
	y8TBKdXAGJ8SWud0O+DKtAeXKzy+lmwwKTfM3h6ad+zYqVX2LPOnXglMaXnr/yBGfokO38a/
	E+X/rZq9qskureSmlyfPYmGF9s6vWm9+VKVvbnxy4WX158/z173LrurWEWy9aXCI+ciqXKVC
	t4wtX+rPv9j+0fPuivTi+YJv2J+9WX7Dd/KigLy8D+vk7ymxFGckGmoxFxUnAgCDYnjg6AEA	AA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds device tree support for Synopsis Designware Mobile
Storage Host Controller.

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

This patchset is based on Samsung kernel tree's for-next branch with the
mmc tree's mmc-next branch merged.

Thomas Abraham (6):
  mmc: dw_mmc: convert copy of struct device in struct dw_mci to a reference
  mmc: dw_mmc: allow probe to succeed even if one slot is initialized
  mmc: dw_mmc: lookup for optional biu and ciu clocks
  mmc: dw_mmc: add quirk to indicate missing write protect line
  mmc: dw_mmc: add device tree support
  mmc: dw_mmc: add samsung exynos5250 specific extentions

 .../devicetree/bindings/mmc/synposis-dw-mshc.txt   |  144 ++++++++
 drivers/mmc/host/dw_mmc-pci.c                      |    2 +-
 drivers/mmc/host/dw_mmc-pltfm.c                    |   41 +++-
 drivers/mmc/host/dw_mmc.c                          |  364 +++++++++++++++++---
 drivers/mmc/host/dw_mmc.h                          |   23 ++
 include/linux/mmc/dw_mmc.h                         |   17 +-
 6 files changed, 538 insertions(+), 53 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt

