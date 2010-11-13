Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab0KMQqK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 11:46:10 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33349 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab0KMQqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 11:46:05 -0500
Date: Sat, 13 Nov 2010 08:44:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linville@tuxdriver.com, einette Chatre <reinette.chatre@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH -next] iwlwifi: fix modular legacy build errors
Message-Id: <20101113084431.d72d096a.randy.dunlap@oracle.com>
In-Reply-To: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au>
References: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

With CONFIG_IWLWIFI=m, CONFIG_IWLAGN=m, and CONFIG_IWL3945=m,
a kernel build has errors as below.  Changing a few lines in the
Makefile is one possible fix for these build errors.

ERROR: "iwl_legacy_mac_config" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!
ERROR: "iwl_isr_legacy" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!
ERROR: "iwl_legacy_tx_cmd_protection" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!
ERROR: "iwl_legacy_mac_bss_info_changed" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!
ERROR: "iwl_legacy_mac_reset_tsf" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Reinette Chatre <reinette.chatre@intel.com>
Cc:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-next-20101112.orig/drivers/net/wireless/iwlwifi/Makefile
+++ linux-next-20101112/drivers/net/wireless/iwlwifi/Makefile
@@ -2,8 +2,6 @@ obj-$(CONFIG_IWLWIFI)	+= iwlcore.o
 iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
 iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o
 iwlcore-objs 		+= iwl-scan.o iwl-led.o
-iwlcore-$(CONFIG_IWL3945) += iwl-legacy.o
-iwlcore-$(CONFIG_IWL4965) += iwl-legacy.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
 
@@ -17,7 +15,7 @@ iwlagn-objs		+= iwl-agn-lib.o iwl-agn-rx
 iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-eeprom.o
 iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
 
-iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
+iwlagn-$(CONFIG_IWL4965) += iwl-4965.o iwl-legacy.o
 iwlagn-$(CONFIG_IWL5000) += iwl-agn-rxon.o iwl-agn-hcmd.o iwl-agn-ict.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
 iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
@@ -25,7 +23,7 @@ iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 
 # 3945
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
-iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o iwl-3945-led.o
+iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o iwl-3945-led.o iwl-legacy.o
 iwl3945-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-3945-debugfs.o
 
 ccflags-y += -D__CHECK_ENDIAN__
