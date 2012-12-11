Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab2LKFbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 00:31:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42874 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab2LKFba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 00:31:30 -0500
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Cong Wang <amwang@redhat.com>, Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@tuxdriver.com>, Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-wireless@vger.kernel.org,
        Abhijit Pawar <abhi.c.pawar@gmail.com>
Subject: [PATCH 2/2] net: remove obsolete simple_strto<foo>
Date: Tue, 11 Dec 2012 11:00:52 +0530
Message-Id: <1355203852-12749-1-git-send-email-abhi.c.pawar@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the redundant occurences of simple_strto<foo>

Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
---
 net/core/netpoll.c                |    1 -
 net/mac80211/debugfs_sta.c        |    1 -
 net/netfilter/nf_conntrack_core.c |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 12c129f..3151acf 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -706,7 +706,6 @@ int netpoll_parse_options(struct netpoll *np, char *opt)
 		*delim = 0;
 		if (*cur == ' ' || *cur == '\t')
 			np_info(np, "warning: whitespace is not allowed\n");
-		np->remote_port = simple_strtol(cur, NULL, 10);
 		if (kstrtou16(cur, 10, &np->remote_port))
 			goto parse_failed;
 		cur = delim;
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 0dedb4b..6fb1168 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -220,7 +220,6 @@ static ssize_t sta_agg_status_write(struct file *file, const char __user *userbu
 	} else
 		return -EINVAL;
 
-	tid = simple_strtoul(buf, NULL, 0);
 	ret = kstrtoul(buf, 0, &tid);
 	if (ret)
 		return ret;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 37d9e62..08cdc71 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1422,7 +1422,6 @@ int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp)
 	if (!nf_conntrack_htable_size)
 		return param_set_uint(val, kp);
 
-	hashsize = simple_strtoul(val, NULL, 0);
 	rc = kstrtouint(val, 0, &hashsize);
 	if (rc)
 		return rc;
-- 
1.7.7.6

