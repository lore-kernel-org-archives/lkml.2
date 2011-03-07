Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1CGPrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:47:06 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:35130 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881Ab1CGPrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:47:04 -0500
Subject: [PATCH] trace: reorder perf_event_context to remove alignment
 padding on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 15:46:59 +0000
Message-ID: <1299512819.2039.5.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove 8 bytes of alignment padding from perf_event_context on 64 bit
builds which shrinks its size to 192 bytes allowing it to fit into one
fewer cache lines and into a smaller slab.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
patch against v2.6.38-rc7
compiled and tested on x86_64

regards
Richard



diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index dda5b0a..59792fe 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -846,8 +846,8 @@ enum perf_event_context_type {
  * Used as a container for task events and CPU events as well:
  */
 struct perf_event_context {
-	enum perf_event_context_type	type;
 	struct pmu			*pmu;
+	enum perf_event_context_type	type;
 	/*
 	 * Protect the states of the events in the list,
 	 * nr_active, and the list:


