Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab0IRTvX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:51:23 -0400
Received: from kroah.org ([198.145.64.141]:51439 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404Ab0IRTBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:46 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:57 2010
Message-Id: <20100918185957.610986671@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [056/123] perf: Initialize callchains rootss childen hits
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=perf-initialize-callchains-roots-s-childen-hits.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 5225c45899e872383ca39f5533d28ec63c54b39e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/util/callchain.h |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -49,6 +49,7 @@ static inline void callchain_init(struct
 	INIT_LIST_HEAD(&node->children);
 	INIT_LIST_HEAD(&node->val);
 
+	node->children_hit = 0;
 	node->parent = NULL;
 	node->hit = 0;
 }


