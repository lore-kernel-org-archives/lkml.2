Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030683Ab2HQD1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:27:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46738 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030628Ab2HQD0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:55 -0400
Message-Id: <20120817030246.563512336@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>
Subject: [ 18/37] mac80211: cancel mesh path timer
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit dd4c9260e7f23f2e951cbfb2726e468c6d30306c upstream.

The mesh path timer needs to be canceled when
leaving the mesh as otherwise it could fire
after the interface has been removed already.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/mesh.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d60b3d3..8557235 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -622,6 +622,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
+	del_timer_sync(&sdata->u.mesh.mesh_path_timer);
 	/*
 	 * If the timer fired while we waited for it, it will have
 	 * requeued the work. Now the work will be running again


