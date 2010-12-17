Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab0LQAw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:52:27 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29778 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab0LQAuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:16 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67160035"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 14/22] msm: clock: Support clk_set_parent() clk_ops
Date: Thu, 16 Dec 2010 16:49:58 -0800
Message-Id: <1292547006-19741-15-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
References: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Voting clocks are linked to the clock they vote on with a parent
pointer. Implement this API for sub drivers which wish to use it.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/clock.c |    2 ++
 arch/arm/mach-msm/clock.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 80e1d64..b6b7e7c 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -119,6 +119,8 @@ EXPORT_SYMBOL(clk_set_max_rate);
 
 int clk_set_parent(struct clk *clk, struct clk *parent)
 {
+	if (clk->ops->set_parent)
+		return clk->ops->set_parent(clk->id, parent);
 	return -ENOSYS;
 }
 EXPORT_SYMBOL(clk_set_parent);
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 4dc8853..1a9fb72 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -46,6 +46,7 @@ struct clk_ops {
 	unsigned (*is_enabled)(unsigned id);
 	long (*round_rate)(unsigned id, unsigned rate);
 	bool (*is_local)(unsigned id);
+	int (*set_parent)(unsigned id, struct clk *parent);
 };
 
 struct clk {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

