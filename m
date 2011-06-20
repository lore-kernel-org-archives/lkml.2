Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab1FTWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:16:56 -0400
Received: from claw.goop.org ([74.207.240.146]:53652 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971Ab1FTWP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:27 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <Xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 12/15] xen/multicalls: disable MC_DEBUG
Date: Mon, 20 Jun 2011 15:15:08 -0700
Message-Id: <095998230fbe24456d1011e33bf328471e944fef.1308607697.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

It's useful - and probably should be a config - but its very heavyweight,
especially with the tracing stuff to help sort out problems.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/multicalls.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
index ac3641d..f19e43b 100644
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -30,7 +30,7 @@
 
 #define MC_BATCH	32
 
-#define MC_DEBUG	1
+#define MC_DEBUG	0
 
 #define MC_ARGS		(MC_BATCH * 16)
 
@@ -132,7 +132,7 @@ struct multicall_space __xen_mc_entry(size_t args)
 	}
 
 	ret.mc = &b->entries[b->mcidx];
-#ifdef MC_DEBUG
+#if MC_DEBUG
 	b->caller[b->mcidx] = __builtin_return_address(0);
 #endif
 	b->mcidx++;
-- 
1.7.5.4

