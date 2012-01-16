Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab2APVUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:20:31 -0500
Received: from relay2.sgi.com ([192.48.179.30]:36943 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754167Ab2APVUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:20:30 -0500
Date: Mon, 16 Jan 2012 15:20:50 -0600
From: Cliff Wickman <cpw@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, x86@kernel.org
Cc: mingo@elte.hu, x86@kernel.org
Subject: [PATCH 4/6] x86 UV2: remove no-resources test for UV2 BAU
Message-ID: <20120116212050.GD5767@sgi.com>
References: <20120116211617.GD5512@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116211617.GD5512@sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch removes an unnecessary test for a no-destination-resources-available
condition that looks like a destination timeout in UV1, but is separately
distinguishable in UV2.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/platform/uv/tlb_uv.c |   10 ----------
 1 file changed, 10 deletions(-)

Index: 120113.linux-3.2.1/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- 120113.linux-3.2.1.orig/arch/x86/platform/uv/tlb_uv.c
+++ 120113.linux-3.2.1/arch/x86/platform/uv/tlb_uv.c
@@ -642,16 +642,6 @@ static int uv2_wait_completion(struct ba
 		} else if (descriptor_stat == UV2H_DESC_DEST_TIMEOUT) {
 			stat->s_dtimeout++;
 			ttm = get_cycles();
-			/*
-			 * Our retries may be blocked by all destination
-			 * swack resources being consumed, and a timeout
-			 * pending.  In that case hardware returns the
-			 * ERROR that looks like a destination timeout.
-			 */
-			if (cycles_2_us(ttm - bcp->send_message) < timeout_us) {
-				bcp->conseccompletes = 0;
-				return FLUSH_RETRY_PLUGGED;
-			}
 			bcp->conseccompletes = 0;
 			return FLUSH_RETRY_TIMEOUT;
 		} else {
