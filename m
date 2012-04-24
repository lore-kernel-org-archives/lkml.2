Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab2DXWfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:35:23 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:49931 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482Ab2DXWfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:35:20 -0400
Message-Id: <20120424223244.369681838@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 28/62] cfg80211: fix interface combinations check.
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>

commit e55a4046dab28c440c96890bdddcf02dc8981f2d upstream.

Signed-off-by: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -988,7 +988,7 @@ int cfg80211_can_change_interface(struct
 			if (rdev->wiphy.software_iftypes & BIT(iftype))
 				continue;
 			for (j = 0; j < c->n_limits; j++) {
-				if (!(limits[j].types & iftype))
+				if (!(limits[j].types & BIT(iftype)))
 					continue;
 				if (limits[j].max < num[iftype])
 					goto cont;


