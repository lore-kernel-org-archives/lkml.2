Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab2EIGcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:32:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38703 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755214Ab2EIFwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:46 -0400
Message-Id: <20120509055032.493479393@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 021/167] [PATCH] cfg80211: fix interface combinations check.
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>

commit e55a4046dab28c440c96890bdddcf02dc8981f2d upstream.

Signed-off-by: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 1b7a08d..957f2562 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -989,7 +989,7 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 			if (rdev->wiphy.software_iftypes & BIT(iftype))
 				continue;
 			for (j = 0; j < c->n_limits; j++) {
-				if (!(limits[j].types & iftype))
+				if (!(limits[j].types & BIT(iftype)))
 					continue;
 				if (limits[j].max < num[iftype])
 					goto cont;
-- 
1.7.10



