Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab2DXWqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:46:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790Ab2DXWht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:37:49 -0400
Message-Id: <20120424223254.683691426@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 14/42] cfg80211: fix interface combinations check.
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -990,7 +990,7 @@ int cfg80211_can_change_interface(struct
 			if (rdev->wiphy.software_iftypes & BIT(iftype))
 				continue;
 			for (j = 0; j < c->n_limits; j++) {
-				if (!(limits[j].types & iftype))
+				if (!(limits[j].types & BIT(iftype)))
 					continue;
 				if (limits[j].max < num[iftype])
 					goto cont;


