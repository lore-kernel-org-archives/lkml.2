Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0FGTAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:00:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35867 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab0FGTAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:00:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: fix-up botched revert
Date: Mon,  7 Jun 2010 14:49:36 -0400
Message-Id: <1275936576-15590-1-git-send-email-linville@tuxdriver.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <20100607090230.deed8bd1.randy.dunlap@oracle.com>
References: <20100607090230.deed8bd1.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the revert of "iwlwifi: move _agn statistics related structure", I
need to use CONFIG_IWLWIFI_DEBUGFS instead of CONFIG_IWLWIFI_DEBUG in
the private structure definition.  Without this patch, it is possible
to get this:

drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_accumulative_statistics':
drivers/net/wireless/iwlwifi/iwl-rx.c:304: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:305: error: 'struct iwl_priv' has no member named 'delta_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:306: error: 'struct iwl_priv' has no member named 'max_delta'
drivers/net/wireless/iwlwifi/iwl-rx.c:321: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:323: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:325: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:327: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:329: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:331: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_reply_statistics':
drivers/net/wireless/iwlwifi/iwl-rx.c:484: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:486: error: 'struct iwl_priv' has no member named 'delta_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:488: error: 'struct iwl_priv' has no member named 'max_delta'

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f359d9f..a00248c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1208,7 +1208,7 @@ struct iwl_priv {
 	struct iwl_tt_mgmt thermal_throttle;
 
 	struct iwl_notif_statistics statistics;
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct iwl_notif_statistics accum_statistics;
 	struct iwl_notif_statistics delta_statistics;
 	struct iwl_notif_statistics max_delta;
-- 
1.6.6.1

