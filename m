Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965377Ab1C3VLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:11:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:50512 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965354Ab1C3VKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621239606"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: sgruszka@redhat.com, wey-yi.w.guy@intel.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [268/275] [PATCH 2.6.35] iwl3945: remove plcp check
Message-Id: <20110330210835.CA5D23E1A06@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
commit c91d01556f52255a31575be0cb1981c92a2a5028 upstream.

Patch fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=654599

Many users report very low speed problem on 3945 devices,
this patch fixes problem, but only for some of them.

For unknown reason, sometimes after hw scanning, device is not able
to receive frames at high rate. Since plcp health check may request
hw scan to "reset radio", performance problem start to be observable
after update kernel to .35, where plcp check was introduced.

Bug reporter confirmed that removing plcp check fixed problem for him.

Reported-and-tested-by: SilvioTO <silviotoya@yahoo.it>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.35.y/drivers/net/wireless/iwlwifi/iwl-3945.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2011-01-13 09:47:51.000000000 -0800
+++ linux-2.6.35.y/drivers/net/wireless/iwlwifi/iwl-3945.c	2011-03-29 23:46:19.212792817 -0700
@@ -2837,7 +2837,6 @@
 	.config_ap = iwl3945_config_ap,
 	.manage_ibss_station = iwl3945_manage_ibss_station,
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
-	.check_plcp_health = iwl3945_good_plcp_health,
 
 	.debugfs_ops = {
 		.rx_stats_read = iwl3945_ucode_rx_stats_read,
