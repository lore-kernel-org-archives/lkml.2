Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2CLAuC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:50:02 -0400
Received: from 1wt.eu ([62.212.114.60]:63061 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab2CLAs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:27 -0400
Message-Id: <20120312002046.403300238@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:20:56 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@hack.frob.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 11/12] regset: Return -EFAULT, not -EIO, on host-side memory fault
In-Reply-To: <feb44625a10a45049eddf27890e95d54@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: H. Peter Anvin <hpa@zytor.com>

commit 5189fa19a4b2b4c3bec37c3a019d446148827717 upstream.

There is only one error code to return for a bad user-space buffer
pointer passed to a system call in the same address space as the
system call is executed, and that is EFAULT.  Furthermore, the
low-level access routines, which catch most of the faults, return
EFAULT already.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@hack.frob.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/regset.h b/include/linux/regset.h
index 5150fd1..686f373 100644
--- a/include/linux/regset.h
+++ b/include/linux/regset.h
@@ -339,7 +339,7 @@ static inline int copy_regset_to_user(struct task_struct *target,
 		return -EOPNOTSUPP;
 
 	if (!access_ok(VERIFY_WRITE, data, size))
-		return -EIO;
+		return -EFAULT;
 
 	return regset->get(target, regset, offset, size, NULL, data);
 }
@@ -365,7 +365,7 @@ static inline int copy_regset_from_user(struct task_struct *target,
 		return -EOPNOTSUPP;
 
 	if (!access_ok(VERIFY_READ, data, size))
-		return -EIO;
+		return -EFAULT;
 
 	return regset->set(target, regset, offset, size, NULL, data);
 }


