Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab1FGW1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:27:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:36820 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048Ab1FGW1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:27:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,335,1304319600"; 
   d="scan'208";a="15212963"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, samuel@sortiz.org
Subject: [PATCH 3/5] IRDA: Fix global type conflicts in net/irda/irsysctl.c
Date: Tue,  7 Jun 2011 15:26:31 -0700
Message-Id: <1307485593-27196-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307485593-27196-1-git-send-email-andi@firstfloor.org>
References: <1307485593-27196-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The externs here didn't agree with the declarations in qos.c.

Better would be probably to move this into a header, but since it's
common practice to have naked externs with sysctls I left it for now.

Cc: samuel@sortiz.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 net/irda/irsysctl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/irda/irsysctl.c b/net/irda/irsysctl.c
index d0b70da..be22ad2 100644
--- a/net/irda/irsysctl.c
+++ b/net/irda/irsysctl.c
@@ -40,9 +40,9 @@ extern int  sysctl_slot_timeout;
 extern int  sysctl_fast_poll_increase;
 extern char sysctl_devname[];
 extern int  sysctl_max_baud_rate;
-extern int  sysctl_min_tx_turn_time;
-extern int  sysctl_max_tx_data_size;
-extern int  sysctl_max_tx_window;
+extern unsigned  sysctl_min_tx_turn_time;
+extern unsigned  sysctl_max_tx_data_size;
+extern unsigned  sysctl_max_tx_window;
 extern int  sysctl_max_noreply_time;
 extern int  sysctl_warn_noreply_time;
 extern int  sysctl_lap_keepalive_time;
-- 
1.7.4.4

