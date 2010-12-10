Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0LJQlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:41:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:52728 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756656Ab0LJQlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:41:44 -0500
Message-ID: <4D025824.7030407@kernel.org>
Date: Fri, 10 Dec 2010 17:41:08 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
CC: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [GIT PULL] workqueue for v2.6.37-rc4
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Dec 2010 16:41:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive workqueue changes for
v2.6.37-rc4.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

It contains only two uninteresting changes.  One to add a missing
sanity check during system boot and the other to add MAINTAINERS
entry.

Thanks.
---
Hitoshi Mitake (1):
      workqueue: check the allocation of system_unbound_wq

Tejun Heo (1):
      MAINTAINERS: Add workqueue entry

 MAINTAINERS        |    8 ++++++++
 kernel/workqueue.c |    3 ++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b3be8b3..350dcf6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6585,6 +6585,14 @@ F:	include/linux/mfd/wm8400*
 F:	include/sound/wm????.h
 F:	sound/soc/codecs/wm*

+WORKQUEUE
+M:	Tejun Heo <tj@kernel.org>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	include/linux/workqueue.h
+F:	kernel/workqueue.c
+F:	Documentation/workqueue.txt
+
 X.25 NETWORK LAYER
 M:	Andrew Hendry <andrew.hendry@gmail.com>
 L:	linux-x25@vger.kernel.org
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 90db1bd..ca017ce 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3692,7 +3692,8 @@ static int __init init_workqueues(void)
 	system_nrt_wq = alloc_workqueue("events_nrt", WQ_NON_REENTRANT, 0);
 	system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND,
 					    WQ_UNBOUND_MAX_ACTIVE);
-	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq);
+	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq ||
+	       !system_unbound_wq);
 	return 0;
 }
 early_initcall(init_workqueues);
