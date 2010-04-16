Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab0DPLqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 07:46:42 -0400
Received: from smtp.nokia.com ([192.100.122.233]:29027 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929Ab0DPLql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 07:46:41 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: akpm@linux-foundation.org
Cc: benh@kernel.crashing.org, roel.kluin@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] hvsi: Messed up error checking getting state name
Date: Fri, 16 Apr 2010 14:49:14 +0300
Message-Id: <1271418554-21278-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 16 Apr 2010 11:45:55.0609 (UTC) FILETIME=[5FB6C890:01CADD5A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phil Carmody <ext-phil.2.carmody@nokia.com>

Handle out-of-range indices before reading what they refer
to. And don't access the one-past-the-end element of the
array either.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 drivers/char/hvsi.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hvsi.c b/drivers/char/hvsi.c
index 793b236..d4b14ff 100644
--- a/drivers/char/hvsi.c
+++ b/drivers/char/hvsi.c
@@ -194,10 +194,8 @@ static inline void print_state(struct hvsi_struct *hp)
 		"HVSI_WAIT_FOR_MCTRL_RESPONSE",
 		"HVSI_FSP_DIED",
 	};
-	const char *name = state_names[hp->state];
-
-	if (hp->state > ARRAY_SIZE(state_names))
-		name = "UNKNOWN";
+	const char *name = (hp->state < ARRAY_SIZE(state_names))
+		? state_names[hp->state] : "UNKNOWN";
 
 	pr_debug("hvsi%i: state = %s\n", hp->index, name);
 #endif /* DEBUG */
-- 
1.6.0.4

