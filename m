Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab1FJUIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:08:07 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:39802 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925Ab1FJUIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:08:04 -0400
Date: Fri, 10 Jun 2011 16:07:52 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [patch] perf_event: Return -EINVAL for Offcore Response Events
Message-ID: <alpine.DEB.2.00.1106101606000.14542@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If we really are going to ban raw access to Offcore Response events for a 
while, then we should return a proper error code.  Right now we return "0"
which gives tools the false impression that opening the event worked.

Vince
vweaver1@eecs.utk.edu


diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3a0338b..c6bfa6b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -598,7 +598,7 @@ static int x86_setup_perfctr(struct perf_event *event)
 	 * there's no sane user-space generalization yet:
 	 */
 	if (attr->type == PERF_TYPE_RAW)
-		return 0;
+		return -EINVAL;
 
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, event);
