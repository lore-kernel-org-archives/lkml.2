Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064Ab0GUCEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 22:04:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40941 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762005Ab0GUCEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 22:04:43 -0400
Date: Wed, 21 Jul 2010 12:04:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the wireless tree with the net tree
Message-Id: <20100721120440.46679304.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-commands.h between commit
ba2d3587912f82d1ab4367975b1df460db60fb1e ("drivers/net: use __packed
annotation") from the net tree and commit
7c094c5cc4d28062abf0d33ca022dbea6c522558 ("iwlwifi: additional statistic
debug counter") from the wireless tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/iwl-commands.h
index 8d2db9d,83247f7..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@@ -3035,8 -3035,9 +3035,9 @@@ struct iwl39_statistics_tx 
  struct statistics_dbg {
  	__le32 burst_check;
  	__le32 burst_count;
- 	__le32 reserved[4];
+ 	__le32 wait_for_silence_timeout_cnt;
+ 	__le32 reserved[3];
 -} __attribute__ ((packed));
 +} __packed;
  
  struct iwl39_statistics_div {
  	__le32 tx_on_a;
