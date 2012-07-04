Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab2GDOey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:34:54 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49864 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab2GDOew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:34:52 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] wireless: fix leak found by coverity
To: bzhao@marvell.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Date: Wed, 04 Jul 2012 16:33:34 +0100
Message-ID: <20120704153327.4012.76171.stgit@bluebook>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/net/wireless/mwifiex/cfg80211.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 97de652..497a05a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1003,6 +1003,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	case NL80211_HIDDEN_SSID_ZERO_CONTENTS:
 		/* firmware doesn't support this type of hidden SSID */
 	default:
+		kfree(bss_cfg);
 		return -EINVAL;
 	}
 

