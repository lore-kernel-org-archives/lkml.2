Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab0LHA7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:42 -0500
Received: from kroah.org ([198.145.64.141]:48552 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756842Ab0LHA7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:38 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:25 2010
Message-Id: <20101208005725.745386206@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [044/289] cfg80211: fix regression on processing country IEs
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit a171fba491f54216e356efa46096171a7ed01d10 upstream.

The patch 4f366c5:

	wireless: only use alpha2 regulatory information from country IE

removed some complex intersection we were always doing between the AP's
country IE info and what we got from CRDA. When CRDA sent us back a
regulatory domain we would do some sanity checks on that regulatory
domain response we just got. Part of these sanity checks included
checking that we already had performed an intersection for the
request of NL80211_REGDOM_SET_BY_COUNTRY_IE type.

This mean that cfg80211 was only processing country IEs for cases
where we already had an intersection, but since we removed enforcing
this this is no longer required, we should just apply the country
IE country hint with the data received from CRDA.

This patch has fixes intended for kernels >= 2.6.36.

Reported-by: Easwar Krishnan <easwar.krishnan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/reg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1170,7 +1170,7 @@ static int ignore_request(struct wiphy *
 				return 0;
 			return -EALREADY;
 		}
-		return REG_INTERSECT;
+		return 0;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		if (last_request->initiator == NL80211_REGDOM_SET_BY_CORE) {
 			if (regdom_changes(pending_request->alpha2))


