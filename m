Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab1FTWPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:15:38 -0400
Received: from claw.goop.org ([74.207.240.146]:53669 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987Ab1FTWP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:29 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <Xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 13/15] xen/multicalls: add unlikely around slowpath in __xen_mc_entry()
Date: Mon, 20 Jun 2011 15:15:09 -0700
Message-Id: <a275720fd6516effcb69017f6b56191c06e1d170.1308607697.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/multicalls.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
index f19e43b..b9b9811 100644
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -123,8 +123,8 @@ struct multicall_space __xen_mc_entry(size_t args)
 	BUG_ON(preemptible());
 	BUG_ON(b->argidx > MC_ARGS);
 
-	if (b->mcidx == MC_BATCH ||
-	    (argidx + args) > MC_ARGS) {
+	if (unlikely(b->mcidx == MC_BATCH ||
+		     (argidx + args) > MC_ARGS)) {
 		trace_xen_mc_flush_reason((b->mcidx == MC_BATCH) ?
 					  XEN_MC_FL_BATCH : XEN_MC_FL_ARGS);
 		xen_mc_flush();
-- 
1.7.5.4

