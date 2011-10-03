Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1JCNwC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:52:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093Ab1JCNul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:50:41 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, kvm@vger.kernel.org, joerg.roedel@amd.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl
Subject: [PATCH 1/9] perf, core: Introduce attrs to count in either host or guest mode
Date: Mon,  3 Oct 2011 15:49:47 +0200
Message-Id: <1317649795-18259-2-git-send-email-gleb@redhat.com>
In-Reply-To: <1317649795-18259-1-git-send-email-gleb@redhat.com>
References: <1317649795-18259-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The two new attributes exclude_guest and exclude_host can
bes used by user-space to tell the kernel to setup
performance counter to either only count while the CPU is in
guest or in host mode.
An additional check is also introduced to make sure
user-space does not try to exclude guest and host mode from
counting.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 include/linux/perf_event.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c816075..1e9ebe5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -220,7 +220,10 @@ struct perf_event_attr {
 				mmap_data      :  1, /* non-exec mmap data    */
 				sample_id_all  :  1, /* sample_type all events */
 
-				__reserved_1   : 45;
+				exclude_host   :  1, /* don't count in host   */
+				exclude_guest  :  1, /* don't count in guest  */
+
+				__reserved_1   : 43;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
-- 
1.7.5.3

