Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab0HVEFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 00:05:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34880 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab0HVEFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 00:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=JGm5+7FSt44Rr3oP+OrwVxH++mbU/csuSMZn5sTytNfqpuUq/sd+JAmp7o6ik6d6kF
         bQSYiXerFOrC04heLqXk/apxnjUor2CNRFmM39k5NhuzyYT9+S8UDmhCBHuzREMHbH0q
         WdWD//Qq7RiaZURqoUnSZLfAIUxfKG8gn7uzE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        "2 . 6 . 32 . x-2 . 6 . 35 . y" <stable@kernel.org>
Subject: [GIT PULL] perf fixlet
Date: Sun, 22 Aug 2010 06:05:51 +0200
Message-Id: <1282449951-18546-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      perf: Initialize callchains roots's childen hits


 tools/perf/util/callchain.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

---
commit 944c88c5ebf7bead43a98fc4cb89b195ee8792d1
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Sun Aug 22 04:29:17 2010 +0200

    perf: Initialize callchains roots's childen hits
    
    Each histogram entry has a callchain root that stores the
    callchain samples. However we forgot to initialize the
    tracking of children hits of these roots, which then got
    random values on their creation.
    
    The root children hits is multiplied by the minimum percentage
    of hits provided by the user, and the result becomes the minimum
    hits expected from children branches. If the random value due
    to the uninitialization is big enough, then this minimum number
    of hits can be huge and eventually filter every children branches.
    
    The end result was invisible callchains. All we need to
    fix this is to initialize the children hits of the root.
    
    Reported-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: 2.6.32.x-2.6.35.y <stable@kernel.org>

diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 624a96c..6de4313 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -50,6 +50,7 @@ static inline void callchain_init(struct callchain_node *node)
 	INIT_LIST_HEAD(&node->children);
 	INIT_LIST_HEAD(&node->val);
 
+	node->children_hit = 0;
 	node->parent = NULL;
 	node->hit = 0;
 }
