Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab1FIHSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:18:43 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38573 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab1FIHSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:18:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OxYrsodIoXrSx25Y6wnfhKsfEzGIUMTKa3rtQ1LDyA2xrH4uxhXWKpcn3gsgP9MlXn
         GnO1FqV4lJrOwgZywkICi/FLC9ZVgQQvzVDEJyQK8EudQgnKXB27cLVLXQY4RmrkN3lc
         M/wd+HrnvBkiNZl/WFxfDR8DlyMtGBq3AEc8Q=
From: Weiping Pan <panweiping3@gmail.com>
To: fubar@us.ibm.com, andy@greyhouse.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Weiping Pan <panweiping3@gmail.com>
Subject: [PATCH net-next 3/5] bonding:delete agg_select_mode from ad_bond_info
Date: Thu,  9 Jun 2011 15:19:03 +0800
Message-Id: <61b3301f160012b2568e9801325d09787c8dff4c.1307603621.git.panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <cover.1307603621.git.panweiping3@gmail.com>
References: <cover.1307603621.git.panweiping3@gmail.com>
In-Reply-To: <cover.1307603621.git.panweiping3@gmail.com>
References: <cover.1307603621.git.panweiping3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bond_params->ad_select and ad_bond_info->agg_select_mode have the same
meaning, they are duplicate and need extra synchronization.

__get_agg_selection_mode() get ad_select from bond_params directly.

Signed-off-by: Weiping Pan <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_3ad.c |    3 +--
 drivers/net/bonding/bond_3ad.h |    1 -
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 013a801..6122725 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -262,7 +262,7 @@ static inline u32 __get_agg_selection_mode(struct port *port)
 	if (bond == NULL)
 		return BOND_AD_STABLE;
 
-	return BOND_AD_INFO(bond).agg_select_mode;
+	return bond->params.ad_select;
 }
 
 /**
@@ -1859,7 +1859,6 @@ static void ad_marker_response_received(struct bond_marker *marker,
 void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout)
 {
 	BOND_AD_INFO(bond).agg_select_timer = timeout;
-	BOND_AD_INFO(bond).agg_select_mode = bond->params.ad_select;
 }
 
 static u16 aggregator_identifier;
diff --git a/drivers/net/bonding/bond_3ad.h b/drivers/net/bonding/bond_3ad.h
index 9782785..1682e69 100644
--- a/drivers/net/bonding/bond_3ad.h
+++ b/drivers/net/bonding/bond_3ad.h
@@ -253,7 +253,6 @@ struct ad_system {
 struct ad_bond_info {
 	struct ad_system system;	    /* 802.3ad system structure */
 	u32 agg_select_timer;	    // Timer to select aggregator after all adapter's hand shakes
-	u32 agg_select_mode;	    // Mode of selection of active aggregator(bandwidth/count)
 	struct timer_list ad_timer;
 };
 
-- 
1.7.4.4

