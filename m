Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab0DVUDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:03:50 -0400
Received: from kroah.org ([198.145.64.141]:60101 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758162Ab0DVUCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:02:02 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:18 2010
Message-Id: <20100422195418.187113373@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:55:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, travis@sgi.com,
       peterz@infradead.org, drepper@redhat.com, rja@sgi.com,
       sharyath@in.ibm.com, steiner@sgi.com, Ingo Molnar <mingo@elte.hu>
Subject: [128/139] sched: Use proper type in sched_getaffinity()
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 8bc037fb89bb3104b9ae290d18c877624cd7d9cc upstream.

Using the proper type fixes the following compiler warning:

  kernel/sched.c:4850: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: torvalds@linux-foundation.org
Cc: travis@sgi.com
Cc: peterz@infradead.org
Cc: drepper@redhat.com
Cc: rja@sgi.com
Cc: sharyath@in.ibm.com
Cc: steiner@sgi.com
LKML-Reference: <20100317090046.4C79.A69D9226@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6727,7 +6727,7 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t
 
 	ret = sched_getaffinity(pid, mask);
 	if (ret == 0) {
-		int retlen = min(len, cpumask_size());
+		size_t retlen = min_t(size_t, len, cpumask_size());
 
 		if (copy_to_user(user_mask_ptr, mask, retlen))
 			ret = -EFAULT;


