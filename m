Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab1LGQWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:22:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922Ab1LGQWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:22:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:18 2011
Message-Id: <20111207161218.239865660@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:44 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Eliad Peller <eliad@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [042/104] nl80211: fix MAC address validation
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit e007b857e88097c96c45620bf3b04a4e309053d1 upstream.

MAC addresses have a fixed length. The current
policy allows passing < ETH_ALEN bytes, which
might result in reading beyond the buffer.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/nl80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -83,8 +83,8 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFNAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ-1 },
 
-	[NL80211_ATTR_MAC] = { .type = NLA_BINARY, .len = ETH_ALEN },
-	[NL80211_ATTR_PREV_BSSID] = { .type = NLA_BINARY, .len = ETH_ALEN },
+	[NL80211_ATTR_MAC] = { .len = ETH_ALEN },
+	[NL80211_ATTR_PREV_BSSID] = { .len = ETH_ALEN },
 
 	[NL80211_ATTR_KEY] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_KEY_DATA] = { .type = NLA_BINARY,


