Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab1LGRC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:02:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757031Ab1LGQRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:17:05 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:25 2011
Message-Id: <20111207160825.388383668@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:06:53 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [33/80] cfg80211: fix regulatory NULL dereference
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit de3584bd62d87b4c250129fbc46ca52c80330add upstream.

By the time userspace returns with a response to
the regulatory domain request, the wiphy causing
the request might have gone away. If this is so,
reject the update but mark the request as having
been processed anyway.

Cc: Luis R. Rodriguez <lrodriguez@qca.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/reg.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2026,6 +2026,10 @@ static int __set_regdom(const struct iee
 	}
 
 	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+	if (!request_wiphy) {
+		reg_set_request_processed();
+		return -ENODEV;
+	}
 
 	if (!last_request->intersect) {
 		int r;


