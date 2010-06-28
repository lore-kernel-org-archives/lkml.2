Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0F1Lzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:55:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0F1Lzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:55:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Gz4YWtjube+CpJ18/nkgq0FouPWYdWInGBHSTRdiNkQ0OHM3doPLfnDqLP8vtG9vX5
         8mfzGB8pMOQXyLmDYEPYa1s7rjgl0QXVFAIi+YOzC40CDOjhMZ/wzjpRhHP6mJ+KM1Cc
         PmJYfYU5hA3vI8maDjzQ6cLHAR2GKsk9U6aq0=
From: Kulikov Vasiliy <segooon@gmail.com>
To: trivial@kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Julia Lawall <julia@diku.dk>, Joe Perches <joe@perches.com>,
       Kulikov Vasiliy <segooon@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] trivial: use ARRAY_SIZE
Date: Mon, 28 Jun 2010 15:55:32 +0400
Message-Id: <1277726134-24831-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
index fb78ed2..d6f55c2 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
@@ -85,7 +85,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 	}
 	/* Add the protocol name */
 	iwe.cmd = SIOCGIWNAME;
-	for(i=0; i<(sizeof(ieee80211_modes)/sizeof(ieee80211_modes[0])); i++) {
+	for(i=0; i<ARRAY_SIZE(ieee80211_modes); i++) {
 		if(network->mode&(1<<i)) {
 			sprintf(pname,ieee80211_modes[i].mode_string,ieee80211_modes[i].mode_size);
 			pname +=ieee80211_modes[i].mode_size;
-- 
1.7.0.4

