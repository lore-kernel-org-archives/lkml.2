Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab0KXX5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:57:24 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10589 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab0KXX5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:57:20 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6177"; a="64247790"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 2/2] arm: add optimized inlining
Date: Wed, 24 Nov 2010 15:57:00 -0800
Message-Id: <1290643020-24558-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2.245.g03276
In-Reply-To: <1290643020-24558-1-git-send-email-sboyd@codeaurora.org>
References: <1290643020-24558-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is inspired by 60a3cdd (x86: add optimized inlining,
2008-03-03). GCC is currently being forced to inline whatever
functions are marked as inline (due to the #define of inline to
the gcc attribute always_inline). The 4.x series of GCC has a
rewritten inlining algorithm which should be good enough for the
kernel's purposes. Enabling this option will allow GCC to decide
when to inline a function marked as inline. Since it's opt-in and
doesn't affect functions marked as always_inline there shouldn't
be much harm in allowing people to enable this. If there is, we
should find the affected functions and mark them as always_inline.

	text    data     bss     dec     hex filename
	5987182  246104  926696 7159982  6d40ae vmlinux.orig
	5794190  246104  926744 6967038  6a4efe vmlinux.new

It reduces the text section of my kernel by 3.3%, which is pretty
nice.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index db524e7..1ed7968 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -23,6 +23,7 @@ config ARM
 	select PERF_USE_VMALLOC
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if (PERF_EVENTS && (CPU_V6 || CPU_V7))
+	select ARCH_SUPPORTS_OPTIMIZED_INLINING
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

