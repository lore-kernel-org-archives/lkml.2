Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab0JHQBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:01:06 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:60827 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab0JHQBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:01:04 -0400
X-IronPort-AV: E=Sophos;i="4.57,303,1283745600"; 
   d="scan'208";a="117224493"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com
Cc: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, stable@kernel.org
Subject: [PATCH] xen: ensure that all event channels start off bound to VCPU 0
Date: Fri,  8 Oct 2010 17:00:57 +0100
Message-Id: <1286553657-22110-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 08 Oct 2010 16:01:03.0647 (UTC) FILETIME=[024E42F0:01CB6702]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All event channels startbound to VCPU 0 so ensure that cpu_evtchn_mask
is initialised to reflect this.

sizeof(cpu_evtchn_mask(0))==sizeof(unsigned long*) which is not
correct, use sizeof(struct cpu_evtchn_s) instead.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: stable@kernel.org
---
 drivers/xen/events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 075e709..175e931 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -290,7 +290,7 @@ static void init_evtchn_cpu_bindings(void)
 	}
 #endif
 
-	memset(cpu_evtchn_mask(0), ~0, sizeof(cpu_evtchn_mask(0)));
+	memset(cpu_evtchn_mask(0), ~0, sizeof(struct cpu_evtchn_s));
 }
 
 static inline void clear_evtchn(int port)
-- 
1.5.6.5

