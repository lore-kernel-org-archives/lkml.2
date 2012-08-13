Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab2HMUW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:22:59 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55329 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab2HMUW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:22:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 40/82] mac80211: cancel mesh path timer
Date: Mon, 13 Aug 2012 13:19:16 -0700
Message-Id: <20120813201749.947528566@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -621,6 +621,7 @@ void ieee80211_stop_mesh(struct ieee8021
 
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
+	del_timer_sync(&sdata->u.mesh.mesh_path_timer);
 	/*
 	 * If the timer fired while we waited for it, it will have
 	 * requeued the work. Now the work will be running again


