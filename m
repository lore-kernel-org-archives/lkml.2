Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2HMWQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:16:47 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59891 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab2HMWQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:16:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 26/65] mac80211: cancel mesh path timer
Date: Mon, 13 Aug 2012 15:14:10 -0700
Message-Id: <20120813221417.271970432@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit dd4c9260e7f23f2e951cbfb2726e468c6d30306c upstream.

The mesh path timer needs to be canceled when
leaving the mesh as otherwise it could fire
after the interface has been removed already.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mesh.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -595,6 +595,7 @@ void ieee80211_stop_mesh(struct ieee8021
 
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
+	del_timer_sync(&sdata->u.mesh.mesh_path_timer);
 	/*
 	 * If the timer fired while we waited for it, it will have
 	 * requeued the work. Now the work will be running again


