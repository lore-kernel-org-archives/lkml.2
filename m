Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab0KUCxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:53:46 -0500
Received: from mail.perches.com ([173.55.12.10]:1656 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259Ab0KUCj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:39:56 -0500
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
Subject: [PATCH 16/62] e1000: Use static const
Date: Sat, 20 Nov 2010 18:38:17 -0800
Message-Id: <4aeb81ea2fe3e78609cb557286aa530715195e40.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
   9083	   1772	    936	  11791	   2e0f	drivers/net/e1000/e1000_param.o.new
   9147	   1772	    936	  11855	   2e4f	drivers/net/e1000/e1000_param.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/e1000/e1000_param.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/e1000/e1000_param.c b/drivers/net/e1000/e1000_param.c
index 10d8d98..6ba2aee 100644
--- a/drivers/net/e1000/e1000_param.c
+++ b/drivers/net/e1000/e1000_param.c
@@ -352,12 +352,13 @@ void __devinit e1000_check_options(struct e1000_adapter *adapter)
 	}
 	{ /* Flow Control */
 
-		struct e1000_opt_list fc_list[] =
-			{{ E1000_FC_NONE,    "Flow Control Disabled" },
-			 { E1000_FC_RX_PAUSE,"Flow Control Receive Only" },
-			 { E1000_FC_TX_PAUSE,"Flow Control Transmit Only" },
-			 { E1000_FC_FULL,    "Flow Control Enabled" },
-			 { E1000_FC_DEFAULT, "Flow Control Hardware Default" }};
+		static const struct e1000_opt_list fc_list[] = {
+			{ E1000_FC_NONE,     "Flow Control Disabled" },
+			{ E1000_FC_RX_PAUSE, "Flow Control Receive Only" },
+			{ E1000_FC_TX_PAUSE, "Flow Control Transmit Only" },
+			{ E1000_FC_FULL,     "Flow Control Enabled" },
+			{ E1000_FC_DEFAULT,  "Flow Control Hardware Default" }
+		};
 
 		opt = (struct e1000_option) {
 			.type = list_option,
-- 
1.7.3.2.245.g03276.dirty

