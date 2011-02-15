Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab1BOWvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 17:51:22 -0500
Received: from kroah.org ([198.145.64.141]:40234 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622Ab1BOWvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:51:19 -0500
Subject: Patch "kernel/user.c: add lock release annotation on free_user()" has been added to the 2.6.32-longterm tree
To: namhyung@gmail.com, akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
        dhaval.giani@gmail.com, efault@gmx.de, gregkh@suse.de,
        linux-kernel@vger.kernel.org, mingo@elte.hu,
        torvalds@linux-foundation.org
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Tue, 15 Feb 2011 14:51:10 -0800
In-Reply-To: <1297404421.7865.24.camel@marge.simson.net>
Message-ID: <12978102701595@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    kernel/user.c: add lock release annotation on free_user()

to the 2.6.32-longterm tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/longterm/longterm-queue-2.6.32.git;a=summary

The filename of the patch is:
     kernel-user.c-add-lock-release-annotation-on-free_user.patch
and it can be found in the queue-2.6.32 subdirectory.

If you, or anyone else, feels it should not be added to the 2.6.32 longterm tree,
please let <stable@kernel.org> know about it.


>From efault@gmx.de  Tue Feb 15 14:39:42 2011
From: Namhyung Kim <namhyung@gmail.com>
From: Mike Galbraith <efault@gmx.de>
Date: Fri, 11 Feb 2011 07:07:01 +0100
Subject: kernel/user.c: add lock release annotation on free_user()
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Message-ID: <1297404421.7865.24.camel@marge.simson.net>


From: Namhyung Kim <namhyung@gmail.com>

commit 571428be550fbe37160596995e96ad398873fcbd upstream.

free_user() releases uidhash_lock but was missing annotation.  Add it.
This removes following sparse warnings:

 include/linux/spinlock.h:339:9: warning: context imbalance in 'free_user' - unexpected unlock
 kernel/user.c:120:6: warning: context imbalance in 'free_uid' - wrong count at exit

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval.giani@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 kernel/user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/user.c
+++ b/kernel/user.c
@@ -91,6 +91,7 @@ static struct user_struct *uid_hash_find
  * upon function exit.
  */
 static void free_user(struct user_struct *up, unsigned long flags)
+	__releases(&uidhash_lock)
 {
 	uid_hash_remove(up);
 	spin_unlock_irqrestore(&uidhash_lock, flags);


Patches currently in longterm-queue-2.6.32 which might be from namhyung@gmail.com are

