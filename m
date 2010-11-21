Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab0KUCtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:49:24 -0500
Received: from mail.perches.com ([173.55.12.10]:1681 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756656Ab0KUCkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:40:09 -0500
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 28/62] ixgb: Use static const
Date: Sat, 20 Nov 2010 18:38:29 -0800
Message-Id: <aea63062901ce9f2380c2c20439fc51980a3da43.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
   4115	    416	    448	   4979	   1373	drivers/net/ixgb/ixgb_param.o.old
   3998	    416	    448	   4862	   12fe	drivers/net/ixgb/ixgb_param.o.new

Change struct ixgb_opt_list to const struct and
change char *str to const char *str.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ixgb/ixgb_param.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ixgb/ixgb_param.c b/drivers/net/ixgb/ixgb_param.c
index 88a08f0..48765a1 100644
--- a/drivers/net/ixgb/ixgb_param.c
+++ b/drivers/net/ixgb/ixgb_param.c
@@ -191,9 +191,9 @@ struct ixgb_option {
 		} r;
 		struct {	/* list_option info */
 			int nr;
-			struct ixgb_opt_list {
+			const struct ixgb_opt_list {
 				int i;
-				char *str;
+				const char *str;
 			} *p;
 		} l;
 	} arg;
@@ -226,7 +226,7 @@ ixgb_validate_option(unsigned int *value, const struct ixgb_option *opt)
 		break;
 	case list_option: {
 		int i;
-		struct ixgb_opt_list *ent;
+		const struct ixgb_opt_list *ent;
 
 		for (i = 0; i < opt->arg.l.nr; i++) {
 			ent = &opt->arg.l.p[i];
@@ -322,14 +322,15 @@ ixgb_check_options(struct ixgb_adapter *adapter)
 	}
 	{ /* Flow Control */
 
-		struct ixgb_opt_list fc_list[] =
-			{{ ixgb_fc_none,	"Flow Control Disabled" },
-			 { ixgb_fc_rx_pause,"Flow Control Receive Only" },
-			 { ixgb_fc_tx_pause,"Flow Control Transmit Only" },
-			 { ixgb_fc_full,	"Flow Control Enabled" },
-			 { ixgb_fc_default, "Flow Control Hardware Default" }};
+		static const struct ixgb_opt_list fc_list[] = {
+			{ ixgb_fc_none,     "Flow Control Disabled" },
+			{ ixgb_fc_rx_pause, "Flow Control Receive Only" },
+			{ ixgb_fc_tx_pause, "Flow Control Transmit Only" },
+			{ ixgb_fc_full,     "Flow Control Enabled" },
+			{ ixgb_fc_default,  "Flow Control Hardware Default" }
+		};
 
-		const struct ixgb_option opt = {
+		static const struct ixgb_option opt = {
 			.type = list_option,
 			.name = "Flow Control",
 			.err  = "reading default settings from EEPROM",
-- 
1.7.3.2.245.g03276.dirty

