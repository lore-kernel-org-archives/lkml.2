Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab0ELCPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:15:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59474 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab0ELCPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:15:42 -0400
Date: Wed, 12 May 2010 12:15:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes.berg@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the net tree with the wireless-current
 tree
Message-Id: <20100512121539.8956720a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-dev.h between commit
562db532760827f6ce30801a08e6b568848bc9f2 ("iwlagn: wait for asynchronous
firmware loading") from the wireless-current tree and commit
ee525d13f501baeaa33209620398adaf0a820629 ("iwlwifi: move 3945 specific
data into union") from the net tree.

Just context changes. I fixed it up (see below) and can carry the fix for
a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/iwl-dev.h
index 4d4c651,58c69a5..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@@ -1304,12 -1274,6 +1274,8 @@@ struct iwl_priv 
  	struct delayed_work alive_start;
  	struct delayed_work scan_check;
  
 +	struct completion firmware_loading_complete;
 +
- 	/*For 3945 only*/
- 	struct delayed_work thermal_periodic;
- 	struct delayed_work rfkill_poll;
- 
  	/* TX Power */
  	s8 tx_power_user_lmt;
  	s8 tx_power_device_lmt;
