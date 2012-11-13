Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab2KMItf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:49:35 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:59650 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab2KMItY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:49:24 -0500
X-AuditID: cbfee61b-b7f616d00000319b-9c-50a209930c09
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 3/3] mmc: sdhci: apply voltage range check only for non-fixed
 regulators
Date: Tue, 13 Nov 2012 09:48:53 +0100
Message-id: <1352796533-12350-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1352796533-12350-1-git-send-email-m.szyprowski@samsung.com>
References: <1352796533-12350-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jQd3JnIsCDG69VLC4vGsOm8WR//2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVsfLCGreAYW8WqxcsYGxj3sHYxcnJICJhIHF1/GcoW
	k7hwbz1bFyMXh5DAdEaJxT/+QjntTBIrfx1lBKliEzCU6HrbBZTg4BARsJbYu9AXpIZZ4DSj
	xKRZ29lAaoQFoiSOrrvBBGKzCKhKXFx4HczmFfCQePHsFTNIr4SAgsScSTYgYU4BT4lV/ZeY
	QWwhoJJ1y18zTWDkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMj2PfPpHcwrmqwOMQo
	wMGoxMOraLkwQIg1say4MvcQowQHs5IIr3k9UIg3JbGyKrUoP76oNCe1+BCjNAeLkjhvs0dK
	gJBAemJJanZqakFqEUyWiYNTqoHRadl1tbDf0lNeJ4qf5Z1wWCK0sl1pkUvmgWfvdtzg4+e0
	uV5tK8QbYucp4umyeWeP1eE228mTpE5U7XQw9fkbtHLngXauY6zfyzcGRe3kLN32ytVDYfbZ
	txs675+7yi6VvOG71e/X5/b5mNfrhO7vvHFFKqNpTW3Xdve3f3t+1qzOqcuzVC5UYinOSDTU
	Yi4qTgQAgIBDe/kBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed regulators cannot change their voltage, so disable all voltage range
checking for them, otherwise the driver fails to operate with fixed
regulators.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/mmc/host/sdhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index c7851c0..6f6534e 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2923,7 +2923,7 @@ int sdhci_add_host(struct sdhci_host *host)
 		regulator_enable(host->vmmc);
 
 #ifdef CONFIG_REGULATOR
-	if (host->vmmc) {
+	if (host->vmmc && regulator_count_voltages(host->vmmc) > 1) {
 		ret = regulator_is_supported_voltage(host->vmmc, 3300000,
 			3300000);
 		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
-- 
1.7.9.5

