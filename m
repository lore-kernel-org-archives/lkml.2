Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1KFN1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 08:27:01 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:41016 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab1KFN05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 08:26:57 -0500
From: Julia Lawall <julia@diku.dk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: kernel-janitors@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] net/mac80211/debugfs.c: use kstrtoul, etc
Date: Sun,  6 Nov 2011 14:26:48 +0100
Message-Id: <1320586010-21931-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1320586010-21931-1-git-send-email-julia@diku.dk>
References: <1320586010-21931-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kstrtoul, etc instead of the now deprecated strict_strtoul, etc.

A semantic patch rule for the kstrtoul case is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression a,b;
{int,long} *c;
@@

-strict_strtoul
+kstrtoul
 (a,b,c)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/mac80211/debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -190,7 +190,7 @@ static ssize_t uapsd_max_sp_len_write(st
 		return -EFAULT;
 	buf[len] = '\0';
 
-	ret = strict_strtoul(buf, 0, &val);
+	ret = kstrtoul(buf, 0, &val);
 
 	if (ret)
 		return -EINVAL;

