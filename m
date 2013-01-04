Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3ADTbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:31:31 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:37578 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754552Ab3ADTb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:31:28 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 2/6] OF: export of_property_notify
Date: Fri,  4 Jan 2013 21:31:06 +0200
Message-Id: <1357327870-13615-3-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_property_notify can be utilized by other users too, export it.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/of/base.c  |  8 +-------
 include/linux/of.h | 11 +++++++++++
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 2390ddb..d598216 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1115,7 +1115,7 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 EXPORT_SYMBOL(of_parse_phandle_with_args);
 
 #if defined(CONFIG_OF_DYNAMIC)
-static int of_property_notify(int action, struct device_node *np,
+int of_property_notify(int action, struct device_node *np,
 			      struct property *prop)
 {
 	struct of_prop_reconfig pr;
@@ -1124,12 +1124,6 @@ static int of_property_notify(int action, struct device_node *np,
 	pr.prop = prop;
 	return of_reconfig_notify(action, &pr);
 }
-#else
-static int of_property_notify(int action, struct device_node *np,
-			      struct property *prop)
-{
-	return 0;
-}
 #endif
 
 /**
diff --git a/include/linux/of.h b/include/linux/of.h
index 2ff35b5..aea3694 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -298,6 +298,17 @@ extern int of_parse_phandle_with_args(const struct device_node *np,
 	const char *list_name, const char *cells_name, int index,
 	struct of_phandle_args *out_args);
 
+#if defined(CONFIG_OF_DYNAMIC)
+extern int of_property_notify(int action, struct device_node *np,
+			      struct property *prop);
+#else
+static inline int of_property_notify(int action, struct device_node *np,
+			      struct property *prop)
+{
+	return 0;
+}
+#endif
+
 extern void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align));
 extern int of_alias_get_id(struct device_node *np, const char *stem);
 
-- 
1.7.12

