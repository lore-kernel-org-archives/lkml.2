Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab0GWS7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:59:07 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39068 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779Ab0GWS6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:58:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6052"; a="48450454"
X-IronPort-AV: E=Sophos;i="4.55,247,1278313200"; 
   d="scan'208";a="69829415"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 2/3] arm: mm: do not set missing flags on ScorpionMP
Date: Fri, 23 Jul 2010 11:58:02 -0700
Message-Id: <1279911483-7039-3-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279911483-7039-1-git-send-email-johlstei@codeaurora.org>
References: <1279911483-7039-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Muckle <smuckle@codeaurora.org>

ScorpionMP does not have the SMP/nAMP mode and TLB ops
broadcasting bits in the ACTLR.

Signed-off-by: Steve Muckle <smuckle@codeaurora.org>
Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mm/proc-v7.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 7aaf88a..6bddf5d 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -190,7 +190,7 @@ cpu_v7_name:
  *	- cache type register is implemented
  */
 __v7_setup:
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && !defined(CONFIG_ARCH_MSM_SCORPIONMP)
 	mrc	p15, 0, r0, c1, c0, 1
 	tst	r0, #(1 << 6)			@ SMP/nAMP mode enabled?
 	orreq	r0, r0, #(1 << 6) | (1 << 0)	@ Enable SMP/nAMP mode and
-- 
1.7.1.1

