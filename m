Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab2KMItS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:49:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:55213 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab2KMItQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:49:16 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-04-50a2098aeeb0
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 0/3] Fix fixed regulators support
Date: Tue, 13 Nov 2012 09:48:50 +0100
Message-id: <1352796533-12350-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJMWRmVeSWpSXmKPExsVy+t9jQd0uzkUBBvcuiFhc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDIWtcgVTOGqaDpxmr2BcQ1HFyMnh4SAicT2XffZIGwx
	iQv31gPZXBxCAtMZJQ7dXs4E4bQzSWx/9pIFpIpNwFCi620XUBUHh4iAtcTehb4gNcwCpxkl
	Js3aDjZJGKjmz9STrCA2i4CqxP0FnewgNq+Ah8T/Hw1gvRICChJzJtlMYORewMiwilE0tSC5
	oDgpPddQrzgxt7g0L10vOT93EyPYk8+kdjCubLA4xCjAwajEw3vDZWGAEGtiWXFl7iFGCQ5m
	JRFe83qgEG9KYmVValF+fFFpTmrxIUZpDhYlcd5mj5QAIYH0xJLU7NTUgtQimCwTB6dUA2Np
	bWKy2J6DGhKZEmdznpd6l5v/Vv8878SGu2vCih1embz9l+l+8WVvbWjoBa8l860dJ/blsin7
	rVipONVh4o3Jlg8ezzP6F6ZYc+n9XIE3DyP/3Xt+9Zov23LHX/+dMmdkX/qpdbnGY6dP2OGK
	U2vOv/+/817gLYYbRuyMFrfazouWGcpbn+1SYinOSDTUYi4qTgQA81n/auABAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've noticed that the voltage check in regulator_is_supported_voltage()
function was inverted, what resulted in strange side effects. One of
such side effects appeared in sdhci driver, which has some build-in
support for special case of fixed regulators. 

Now, after fixing regulator_is_supported_voltage(), the sdhci driver
stopped working with fixed regulators. The provided patch series fixes
regulator_is_supported_voltage() function and updates sdhci driver to
correctly operate with fixed voltage regulators. The second patch
unifies handling of fixed regulators and regulators with disabled
voltage change due to their constraints. This restores support for such
regulators in sdhci driver (such case is present on Samsung GONI board).

If possible, I would recomment to push those patches to v3.7-rc series.

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Marek Szyprowski (3):
  regulator: fix voltage check in regulator_is_supported_voltage()
  regulator: threat regulators with constant volatage as fixed
  mmc: sdhci: apply voltage range check only for non-fixed regulators

 drivers/mmc/host/sdhci.c |    2 +-
 drivers/regulator/core.c |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

-- 
1.7.9.5

