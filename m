Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab1BPBwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:52:54 -0500
Received: from kroah.org ([198.145.64.141]:51388 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758667Ab1BPBwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:52:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:05 2011
Message-Id: <20110216014705.757486691@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:46:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [115/115] kernel/user.c: add lock release annotation on free_user()
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


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


