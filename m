Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1I1DTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 23:19:21 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:36405 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab1I1DTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 23:19:20 -0400
Date: Wed, 28 Sep 2011 13:19:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: linux-next: manual merge of the wireless tree with the
 wireless-current tree
Message-Id: <20110928131917.fe58aa3efa5549a9b3a6e3da@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
net/wireless/nl80211.c between commit 1b9ca0272ffa ("cfg80211: Fix
validation of AKM suites") from the wireless-current tree and commit
6d30240e3d68 ("cfg80211: Remove strict validation of AKM suites") from
the wireless tree.

The latter seems to make the former partly unneccessary, so I used that
(see below).

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/wireless/nl80211.c
index 1b79a56,bf3fc4f..0000000
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@@ -4304,14 -4300,7 +4300,10 @@@ static int nl80211_crypto_settings(stru
  		if (len % sizeof(u32))
  			return -EINVAL;
  
 +		if (settings->n_akm_suites > NL80211_MAX_NR_AKM_SUITES)
 +			return -EINVAL;
 +
  		memcpy(settings->akm_suites, data, len);
- 
- 		for (i = 0; i < settings->n_akm_suites; i++)
- 			if (!nl80211_valid_akm_suite(settings->akm_suites[i]))
- 				return -EINVAL;
  	}
  
  	return 0;
