Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab1LGRHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:07:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757416Ab1LGRDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:03:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:56:01 2011
Message-Id: <20111207165601.267510237@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:54:43 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Eliad Peller <eliad@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [10/27] nl80211: fix MAC address validation
In-Reply-To: <20111207165611.GA19872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
@@ -74,8 +74,8 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFNAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ-1 },
 
-	[NL80211_ATTR_MAC] = { .type = NLA_BINARY, .len = ETH_ALEN },
-	[NL80211_ATTR_PREV_BSSID] = { .type = NLA_BINARY, .len = ETH_ALEN },
+	[NL80211_ATTR_MAC] = { .len = ETH_ALEN },
+	[NL80211_ATTR_PREV_BSSID] = { .len = ETH_ALEN },
 
 	[NL80211_ATTR_KEY] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_KEY_DATA] = { .type = NLA_BINARY,


