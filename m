Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118Ab2GPEqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 00:46:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9761 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2GPEqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 00:46:24 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-e2-50039c9dfb4d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: cbouatmailru@gmail.com, jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] charger-manager: Fix build break related to EXTCON
Date: Mon, 16 Jul 2012 13:46:14 +0900
Message-id: <1342413974-13219-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJMWRmVeSWpSXmKPExsVy+t9jAd25c5gDDKae17e4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZe2b8Ziro4KqYMWcRWwPjCY4uRg4OCQETiSObCroYOYFMMYkL
	99azgdhCAosYJZ6eSoGwlzJJzPoQAGKzCWhJ7H9xA6xGREBO4vXav0xdjFwczAKnGCUeXTzB
	DJIQFnCWmPryJzuIzSKgKjFvygRGEJtXwFViQ9dMJohlChKtyw6xT2DkXsDIsIpRNLUguaA4
	KT3XUK84Mbe4NC9dLzk/dxMj2H/PpHYwrmywOMQowMGoxMMr0MscIMSaWFZcmXuIUYKDWUmE
	t7MTKMSbklhZlVqUH19UmpNafIhRmoNFSZzX2Purv5BAemJJanZqakFqEUyWiYNTqoFRbva7
	tFVfih7/iqubf9+jVP7Qyv1z0zmUpWtMNDMuSobpLtFQv7wtkWFDx4xM+cK0xJsqcwqTV09o
	n/u/5rH9nuKMqotKHHMCfsqr2zmW6WR7yHDLZe828J/DLKEwXeCbjPlBSd/TZ4xUzcoU/B6u
	OVNSOJFtvdRRP9VpEroy63L8n36+FanEUpyRaKjFXFScCAAQbhyE2wEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch select CONFIG_EXTCON to resolve below build break of charger-manager
because charger-manager use API of EXTCON subsystem.

drivers/built-in.o: In function `charger_manager_probe':
charger-manager.c:(.text+0x11d61a): undefined reference to `extcon_register_interest'
charger-manager.c:(.text+0x11d7b6): undefined reference to `extcon_unregister_interest'
drivers/built-in.o: In function `charger_manager_remove':
charger-manager.c:(.devexit.text+0x8f3): undefined reference to `extcon_unregister_interest'

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index e3a3b49..064d6c1 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -268,6 +268,7 @@ config CHARGER_GPIO
 config CHARGER_MANAGER
 	bool "Battery charger manager for multiple chargers"
 	depends on REGULATOR && RTC_CLASS
+	select EXTCON
 	help
           Say Y to enable charger-manager support, which allows multiple
           chargers attached to a battery and multiple batteries attached to a
-- 
1.7.0.4

