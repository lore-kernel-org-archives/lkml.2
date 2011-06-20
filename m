Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab1FTWPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:15:36 -0400
Received: from claw.goop.org ([74.207.240.146]:53664 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929Ab1FTWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:28 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <Xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 15/15] xen/multicall: move *idx fields to start of mc_buffer
Date: Mon, 20 Jun 2011 15:15:11 -0700
Message-Id: <4a1c748744bdaab955cfad8efaccb2a77fec6eda.1308607697.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

The CPU would prefer small offsets.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/multicalls.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
index eb022fd..a599f0e 100644
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -36,6 +36,7 @@
 
 
 struct mc_buffer {
+	unsigned mcidx, argidx, cbidx;
 	struct multicall_entry entries[MC_BATCH];
 #if MC_DEBUG
 	struct multicall_entry debug[MC_BATCH];
@@ -46,7 +47,6 @@ struct mc_buffer {
 		void (*fn)(void *);
 		void *data;
 	} callbacks[MC_BATCH];
-	unsigned mcidx, argidx, cbidx;
 };
 
 static DEFINE_PER_CPU(struct mc_buffer, mc_buffer);
-- 
1.7.5.4

