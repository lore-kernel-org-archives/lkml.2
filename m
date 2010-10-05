Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab0JEIwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:52:32 -0400
Received: from smtp.nokia.com ([192.100.105.134]:17151 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab0JEIwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:52:31 -0400
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: m.nazarewicz@samsung.com, mingo@elte.hu, gregkh@suse.de,
        a.p.zijlstra@chello.nl, xiaosuo@gmail.com,
        linux-kernel@vger.kernel.org, ext-eugeny.kuznetsov@nokia.com
Subject: [PATCH 1/1] wait: using uninitialized member of wait queue
Date: Tue,  5 Oct 2010 12:47:57 +0400
Message-Id: <dfd3348b7971bee89360efb85f8d622e6574b003.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <cover.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
References: <cover.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
In-Reply-To: <cover.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
References: <cover.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-OriginalArrivalTime: 05 Oct 2010 08:51:34.0508 (UTC) FILETIME=[837672C0:01CB646A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Kuznetsov <ext-eugeny.kuznetsov@nokia.com>

Member "flags" of "wait_queue_t" struct  is used in several places in
kernel code without beeing initialized. "flags" is used in bitwise operations.
If "flags" not initialized then unexpected behaviour may have place.
Incorrect flags maybe used later in code.
Struct "wait_queue_t" is initialized in function "init_wait()". But
"init_wait()" do not initialize "flag" member.
Added initialization of "wait_queue_t.flags" with zero value into "init_wait".

Signed-off-by: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
---
 include/linux/wait.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 0836ccc..3efc9f3 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -614,6 +614,7 @@ int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 		(wait)->private = current;				\
 		(wait)->func = autoremove_wake_function;		\
 		INIT_LIST_HEAD(&(wait)->task_list);			\
+		(wait)->flags = 0;					\
 	} while (0)
 
 /**
-- 
1.6.3.3

