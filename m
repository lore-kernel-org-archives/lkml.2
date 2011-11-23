Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab1KWAfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:35:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532Ab1KWAfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:35:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:54 2011
Message-Id: <20111123002554.127329100@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [13/53] nl80211: fix HT capability attribute validation
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 6c7394197af90f6a332180e33f5d025d3037d883 upstream.

Since the NL80211_ATTR_HT_CAPABILITY attribute is
used as a struct, it needs a minimum, not maximum
length. Enforce that properly. Not doing so could
potentially lead to reading after the buffer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/nl80211.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -126,8 +126,7 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_MESH_CONFIG] = { .type = NLA_NESTED },
 	[NL80211_ATTR_SUPPORT_MESH_AUTH] = { .type = NLA_FLAG },
 
-	[NL80211_ATTR_HT_CAPABILITY] = { .type = NLA_BINARY,
-					 .len = NL80211_HT_CAPABILITY_LEN },
+	[NL80211_ATTR_HT_CAPABILITY] = { .len = NL80211_HT_CAPABILITY_LEN },
 
 	[NL80211_ATTR_MGMT_SUBTYPE] = { .type = NLA_U8 },
 	[NL80211_ATTR_IE] = { .type = NLA_BINARY,


