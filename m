Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab2HTOAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:00:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38505 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab2HTOAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:00:48 -0400
From: Trevor Brandt <tjbrandt@gmail.com>
To: Trevor Brandt <tjbrandt@gmail.com>, Josh Triplett <josh@joshtriplett.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Cc: team-fjord@googlegroups.com
Subject: [PATCHv2 1/2] sched: Fixed cpupri_init stub signature; switched from macros to inlines.
Date: Mon, 20 Aug 2012 07:00:22 -0700
Message-Id: <1345471224-14997-1-git-send-email-tjbrandt@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the cpupri_init stub in cpupri.h so it takes one argument
instead of none. At the same time, changed the cpupri stubs from
macros to inlines.

Signed-off-by: Trevor Brandt <tjbrandt@gmail.com>
---
 kernel/sched/cpupri.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cpupri.h b/kernel/sched/cpupri.h
index f6d7561..fd7914c 100644
--- a/kernel/sched/cpupri.h
+++ b/kernel/sched/cpupri.h
@@ -27,8 +27,11 @@ void cpupri_set(struct cpupri *cp, int cpu, int pri);
 int cpupri_init(struct cpupri *cp);
 void cpupri_cleanup(struct cpupri *cp);
 #else
-#define cpupri_set(cp, cpu, pri) do { } while (0)
-#define cpupri_init() do { } while (0)
+static inline void cpupri_set(struct cpupri *cp, int cpu, int pri) { }
+static inline int cpupri_init(struct cpupri *cp)
+{
+	return 0;
+}
 #endif
 
 #endif /* _LINUX_CPUPRI_H */
-- 
1.7.9.5

