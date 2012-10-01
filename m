Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037Ab2JAXBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:01:52 -0400
Received: from 1wt.eu ([62.212.114.60]:35429 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933013Ab2JAXBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:47 -0400
Message-Id: <20121001225202.658882219@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Darren Hart <dvhart@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 119/180] futex: Test for pi_mutex on fault in futex_wait_requeue_pi()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Darren Hart <dvhart@linux.intel.com>

commit b6070a8d9853eda010a549fa9a09eb8d7269b929 upstream.

If fixup_pi_state_owner() faults, pi_mutex may be NULL. Test
for pi_mutex != NULL before testing the owner against current
and possibly unlocking it.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Link: http://lkml.kernel.org/r/dc59890338fc413606f04e5c5b131530734dae3d.1342809673.git.dvhart@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 0b06da1..6f745b6 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2345,7 +2345,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	 * fault, unlock the rt_mutex and return the fault to userspace.
 	 */
 	if (ret == -EFAULT) {
-		if (rt_mutex_owner(pi_mutex) == current)
+		if (pi_mutex && rt_mutex_owner(pi_mutex) == current)
 			rt_mutex_unlock(pi_mutex);
 	} else if (ret == -EINTR) {
 		/*
-- 
1.7.2.1.45.g54fbc



