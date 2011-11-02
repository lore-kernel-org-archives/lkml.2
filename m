Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962Ab1KBSmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:42:07 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18132 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257Ab1KBShC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706979"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 13/34] msm: clock-debug: Implement a default is_enabled()
Date: Wed,  2 Nov 2011 11:36:10 -0700
Message-Id: <1320258991-22325-14-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Some clocks are simple enough that determining if they are
enabled or disabled can be done by reading the 'count' member of
struct clk. Implement support for such clocks in clock-debug.c so
that these types of clocks don't need to implement the
is_enabled() ops.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-debug.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/clock-debug.c b/arch/arm/mach-msm/clock-debug.c
index a8db06d..472a735 100644
--- a/arch/arm/mach-msm/clock-debug.c
+++ b/arch/arm/mach-msm/clock-debug.c
@@ -65,9 +65,14 @@ static int clock_debug_enable_set(void *data, u64 val)
 static int clock_debug_enable_get(void *data, u64 *val)
 {
 	struct clk *clock = data;
+	int enabled;
 
-	*val = clock->ops->is_enabled(clock);
+	if (clock->ops->is_enabled)
+		enabled = clock->ops->is_enabled(clock);
+	else
+		enabled = !!(clock->count);
 
+	*val = enabled;
 	return 0;
 }
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

