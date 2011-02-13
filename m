Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1BMJnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:43:37 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9944 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab1BMJnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:13 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/21] ARM: tegra: clock: Initialize clocks that have no enable
Date: Sun, 13 Feb 2011 01:40:18 -0800
Message-Id: <1297590033-15035-7-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assume that any clock that has no enable op is always on.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/clock.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index 0ea5d92..79c0bd8 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -166,6 +166,15 @@ void clk_init(struct clk *c)
 	if (c->ops && c->ops->init)
 		c->ops->init(c);
 
+	if (!c->ops || !c->ops->enable) {
+		c->refcnt++;
+		c->set = 1;
+		if (c->parent)
+			c->state = c->parent->state;
+		else
+			c->state = ON;
+	}
+
 	clk_recalculate_rate(c);
 
 	list_add(&c->node, &clocks);
-- 
1.7.3.1

