Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2LDOB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:01:29 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31788 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2LDOB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:01:26 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-9c-50be0234badf
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        Kevin Liu <keyuan.liu@gmail.com>
Subject: [PATCH v2 0/3] Fix fixed regulators support
Date: Tue, 04 Dec 2012 15:01:00 +0100
Message-id: <1354629663-29091-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t9jQV0Tpn0BBruW6llc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKmfr7EUjCHs2L61QNMDYyb2bsYOTkkBEwkHqx6wgZh
	i0lcuLceyObiEBKYzijRsWIFO4TTziTx8fETZpAqNgFDia63XUBVHBwiAtYSexf6gtQwC7xl
	lFh+azsLSI0w0NTvXbuYQGwWAVWJK003wLbxCnhIHPyxkh2kV0JAQWLOJJsJjNwLGBlWMYqm
	FiQXFCel5xrqFSfmFpfmpesl5+duYgT78pnUDsaVDRaHGAU4GJV4eGc83BMgxJpYVlyZe4hR
	goNZSYRX4cPeACHelMTKqtSi/Pii0pzU4kOM0hwsSuK8zR4pAUIC6YklqdmpqQWpRTBZJg5O
	qQZGu7Wm7dtsZtg4vLr/8vIGnrz7xcGGU6MeW+4O2v/h/LHKvDmv8k4t67uw8nKcn4xnTY2W
	19cFv9iNFn7JcsyIn7nj0Iup85ydQqQX/3lwfMqlE2e/bf0wsVddzYtVwOvvn77Lkxp2CnwN
	Wd37/o649ZwjvPeaGHwWlU1wu5qxbOKsVAU1vVNeR5VYijMSDbWYi4oTAbnZoWnhAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Commit f0f98b19e23d4426ca185e3d4ca80e6aff5ef51b revealed that the support for
fixed regulators in SDHCI driver was working only by pure luck. My previous
patch set for fixing this issue resulted in a discussion, which has been
concluded that this issue should by fixed by extending regulators core by
regualtor_can_change_voltage() function and using it in the mmc/sdhci drivers.

For more information, please refer to the following threads:
http://thread.gmane.org/gmane.linux.kernel.mmc/17643
https://patchwork.kernel.org/patch/1739061/

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Marek Szyprowski (3):
  regulators: add regulator_can_change_voltage() function
  mmc: use regulator_can_change_voltage() instead of
    regulator_count_voltages() hacks
  mmc: sdhci: check voltage range only on regulators aware of voltage
    value

 drivers/mmc/core/core.c            |    2 +-
 drivers/mmc/host/sdhci.c           |    6 +++++-
 drivers/regulator/core.c           |   22 ++++++++++++++++++++++
 include/linux/regulator/consumer.h |    1 +
 4 files changed, 29 insertions(+), 2 deletions(-)

-- 
1.7.9.5

