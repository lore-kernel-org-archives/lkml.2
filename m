Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab3ADTbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:31:33 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:37560 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754655Ab3ADTbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:31:23 -0500
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
Subject: [PATCH 1/6] OF: Introduce device tree node flag helpers.
Date: Fri,  4 Jan 2013 21:31:05 +0200
Message-Id: <1357327870-13615-2-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helper functions for working with device node flags.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 include/linux/of.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 5ebcc5c..2ff35b5 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -114,6 +114,26 @@ static inline void of_node_set_flag(struct device_node *n, unsigned long flag)
 	set_bit(flag, &n->_flags);
 }
 
+static inline void of_node_clear_flag(struct device_node *n, unsigned long flag)
+{
+	clear_bit(flag, &n->_flags);
+}
+
+static inline int of_property_check_flag(struct property *p, unsigned long flag)
+{
+	return test_bit(flag, &p->_flags);
+}
+
+static inline void of_property_set_flag(struct property *p, unsigned long flag)
+{
+	set_bit(flag, &p->_flags);
+}
+
+static inline void of_property_clear_flag(struct property *p, unsigned long flag)
+{
+	clear_bit(flag, &p->_flags);
+}
+
 extern struct device_node *of_find_all_nodes(struct device_node *prev);
 
 /*
-- 
1.7.12

