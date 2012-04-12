Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761887Ab2DLCsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:48:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260Ab2DLCsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:48:41 -0400
Date: Thu, 12 Apr 2012 04:47:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] task_work_queue() && keyctl_session_to_parent()
Message-ID: <20120412024751.GA17561@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

So, task_work_queue() again, now with the first user.

Compared to v1, 1/2 adds task_work_cancel(func), it removes
the first work with the same callback. May be it should remove
all and return the list, or we can add task_work_requeue()
instead. Easy to change if needed, although I think a simple
_cancel is enough.

checkpatch.pl dislikes replace_session_keyring() in 2/2, but
I disagree. This code was copy-and-past'ed, and I really think
that the "unnecessary" spaces make it more readable.

Of course, I can "fix" the code to make checkpatch.pl happy.

I tried to test this, seems to work. But please review the
the error-handling in keyctl_session_to_parent().

I do not like when diffstat shows the code bloat, but note that
the numbers will be much better after we kill the no longer used
->replacement_session_keyring and cleanup arch/*/kernel/signal.c

Oleg.

 include/linux/key.h          |    2 +-
 include/linux/sched.h        |    2 +
 include/linux/task_work.h    |   48 +++++++++++++++++++++++
 include/linux/tracehook.h    |   10 ++++-
 kernel/Makefile              |    2 +-
 kernel/exit.c                |    5 ++-
 kernel/fork.c                |    1 +
 kernel/task_work.c           |   77 +++++++++++++++++++++++++++++++++++++
 security/keys/keyctl.c       |   87 +++++++++++++++++++++++++++++++-----------
 security/keys/process_keys.c |   49 -----------------------
 10 files changed, 207 insertions(+), 76 deletions(-)

