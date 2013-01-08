Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab3AIABt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:01:49 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53590 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347Ab3AHXhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:09 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eliad Peller <eliad@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 29/77] nl80211: fix MAC address validation
Date: Tue, 8 Jan 2013 18:35:08 -0500
Message-ID: <1357688156-25387-30-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliad Peller <eliad@wizery.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e007b857e88097c96c45620bf3b04a4e309053d1 upstream.

MAC addresses have a fixed length. The current
policy allows passing < ETH_ALEN bytes, which
might result in reading beyond the buffer.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/wireless/nl80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fde82a8..a316e59 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -76,8 +76,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFNAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ-1 },
 
-	[NL80211_ATTR_MAC] = { .type = NLA_BINARY, .len = ETH_ALEN },
-	[NL80211_ATTR_PREV_BSSID] = { .type = NLA_BINARY, .len = ETH_ALEN },
+	[NL80211_ATTR_MAC] = { .len = ETH_ALEN },
+	[NL80211_ATTR_PREV_BSSID] = { .len = ETH_ALEN },
 
 	[NL80211_ATTR_KEY] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_KEY_DATA] = { .type = NLA_BINARY,
-- 
1.7.12.1

