Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2E3RAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:00:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340Ab2E3RAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:00:31 -0400
Date: Wed, 30 May 2012 18:58:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] uprobes: remove the unnecessary initialization in
	add_utask()
Message-ID: <20120530165832.GB8085@redhat.com>
References: <20120530165757.GA8077@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530165757.GA8077@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial cleanup. No need to nullify ->active_uprobe after kzalloc().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 1593b43..50c8a9c 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1416,7 +1416,6 @@ static struct uprobe_task *add_utask(void)
 	if (unlikely(!utask))
 		return NULL;
 
-	utask->active_uprobe = NULL;
 	current->utask = utask;
 	return utask;
 }
-- 
1.5.5.1


