Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab2FOPqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:46:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158Ab2FOPqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:46:10 -0400
Date: Fri, 15 Jun 2012 17:44:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] uprobes: remove the unnecessary initialization in
	add_utask()
Message-ID: <20120615154401.GA9633@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615154241.GA9524@redhat.com>
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
index d1b2eeb..f935327 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1392,7 +1392,6 @@ static struct uprobe_task *add_utask(void)
 	if (unlikely(!utask))
 		return NULL;
 
-	utask->active_uprobe = NULL;
 	current->utask = utask;
 	return utask;
 }
-- 
1.5.5.1

