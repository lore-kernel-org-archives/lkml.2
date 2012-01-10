Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab2AJXNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:13:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934164Ab2AJXCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:02:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:03 2012
Message-Id: <20120110215602.930683849@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [16/49] iwlagn: fix TID use bug
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 9a215e40d70ae63762963ab3ccc7f31dd966dc6a upstream.

The driver everywhere uses max TID count as 9,
which is wrong, it should be 8.

I think the reason it uses 9 here is off-by-one
confusion by whoever wrote this. We do use the
value IWL_MAX_TID_COUNT for "not QoS/no TID"
but that is completely correct even if it is 8
and not 9 since 0-7 are only valid.

As a side effect, this fixes the following bug:

 Open BA session requested for 00:23:cd:16:8a:7e tid 8
 ------------[ cut here ]------------
 kernel BUG at drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h:350!
 ...

when you do
echo "tx start 8" > /sys/kernel/debug/ieee80211/*/*/*/*/agg_status

Reported-by: Nikolay Martynov <mar.kolya@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -809,7 +809,7 @@ struct iwl_qosparam_cmd {
 #define	IWLAGN_STATION_COUNT	16
 
 #define	IWL_INVALID_STATION 	255
-#define IWL_MAX_TID_COUNT	9
+#define IWL_MAX_TID_COUNT	8
 
 #define STA_FLG_TX_RATE_MSK		cpu_to_le32(1 << 2)
 #define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8)


