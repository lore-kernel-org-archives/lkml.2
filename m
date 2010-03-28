Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab0C1LzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 07:55:15 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59450 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab0C1LzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:55:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=SiVn9lyMqM7GpHpRLVslYgiP+soOvUlB6wlHATwn4G4gNdOWq3L3QgsExwMynUC7HN
         GO4UYvwkpIl75ZmbOqCL0kVLiW17+knvLclPBqc21hIv/a9ajXcxnhvp7+MewDPHKyPU
         uGQdBylWWkytlrAZEOc7+jM4MxktdW8XRVEX0=
Date: Sun, 28 Mar 2010 14:55:00 +0300
From: Dan Carpenter <error27@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] iwlwifi: range checking issue
Message-ID: <20100328115500.GX5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IWL_RATE_COUNT is 13 and IWL_RATE_COUNT_LEGACY is 12.

IWL_RATE_COUNT_LEGACY is the right one here because iwl3945_rates
doesn't support 60M and also that's how "rates" is defined in
iwlcore_init_geos() from drivers/net/wireless/iwlwifi/iwl-core.c.

        rates = kzalloc((sizeof(struct ieee80211_rate) * IWL_RATE_COUNT_LEGACY),
                        GFP_KERNEL);

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 54daa38..7d3806a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1955,7 +1955,7 @@ static void iwl3945_init_hw_rates(struct iwl_priv *priv,
 {
 	int i;
 
-	for (i = 0; i < IWL_RATE_COUNT; i++) {
+	for (i = 0; i < IWL_RATE_COUNT_LEGACY; i++) {
 		rates[i].bitrate = iwl3945_rates[i].ieee * 5;
 		rates[i].hw_value = i; /* Rate scaling will work on indexes */
 		rates[i].hw_value_short = i;
