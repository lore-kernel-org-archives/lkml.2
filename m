Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2HCOXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:23:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35880 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2HCOXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:23:12 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: torvalds@linux-foundation.org
Cc: tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com, davem@davemloft.net,
        rostedt@goodmis.org, mingo@elte.hu, ebiederm@xmission.com,
        aarcange@redhat.com, ericvh@gmail.com, netdev@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC v2 0/7] generic hashtable implementation
Date: Fri,  3 Aug 2012 16:23:01 +0200
Message-Id: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are quite a few places in the kernel which implement a hashtable
in a very similar way. Instead of having implementations of a hashtable
all over the kernel, we can re-use the code.

This patch series introduces a very simple hashtable implementation, and
modifies three (random) modules to use it. I've limited it to 3 only
so that it would be easy to review and modify, and to show that even
at this number we already eliminate a big amount of duplicated code.

If this basic hashtable looks ok, future code will include:

 - RCU support
 - Self locking (list_bl?)
 - Converting more code to use the hashtable


Changes in V2:

 - Address review comments by Tejun Heo, Josh Triplett and Eric Beiderman (Thanks all!).
 - Rebase on top of latest master.
 - Convert more places to use the hashtable. Hopefully it will trigger more reviews by
 touching more subsystems.

Sasha Levin (7):
  hashtable: introduce a small and naive hashtable
  user_ns: use new hashtable implementation
  mm,ksm: use new hashtable implementation
  workqueue: use new hashtable implementation
  mm/huge_memory: use new hashtable implementation
  tracepoint: use new hashtable implementation
  net,9p: use new hashtable implementation

 include/linux/hashtable.h |   75 ++++++++++++++++++++++++++++++++++++
 kernel/tracepoint.c       |   26 ++++--------
 kernel/user.c             |   53 +++++++++-----------------
 kernel/workqueue.c        |   93 +++++++--------------------------------------
 mm/huge_memory.c          |   56 +++++----------------------
 mm/ksm.c                  |   29 ++++----------
 net/9p/error.c            |   17 ++++----
 7 files changed, 144 insertions(+), 205 deletions(-)
 create mode 100644 include/linux/hashtable.h

-- 
1.7.8.6

