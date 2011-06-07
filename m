Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab1FGPdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:33:43 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:58591 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756714Ab1FGPdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:33:40 -0400
Subject: [PATCH] perf events: remove 64bit alignment padding from
 perf_event_context
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>
Date: Tue, 07 Jun 2011 16:33:38 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307460819.1950.5.camel@castor.rsk>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder perf_event_context to remove 8 bytes of 64 bit alignment padding
shrinking its size to 192 bytes, allowing it to fit into a smaller slab
and use one fewer cache lines.


Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---

patch against v3.0-rc2
compiled & tested on x86_64

regards
Richard


diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3412684..9d5b3d5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -919,8 +919,8 @@ struct perf_event_context {
 	u64				parent_gen;
 	u64				generation;
 	int				pin_count;
-	struct rcu_head			rcu_head;
 	int				nr_cgroups; /* cgroup events present */
+	struct rcu_head			rcu_head;
 };
 
 /*


