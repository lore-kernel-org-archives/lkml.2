Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934691Ab2DLVMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:12:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849Ab2DLVMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:12:49 -0400
Date: Thu, 12 Apr 2012 23:11:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Gordeev <agordeev@redhat.com>, Chris Zankel <chris@zankel.net>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] task_work_queue() with 2 users
Message-ID: <20120412211146.GA30448@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Compared to v2

	1/3: make it (partly) useable without TIF_NOTIFY_RESUME

	2/3: address the comments from David

	3/3: New. Looks trivial, but I guess needs more testing.
	     And of course, needs the review from Thomas.

Oleg.

 include/linux/interrupt.h    |    4 --
 include/linux/key.h          |    6 +--
 include/linux/sched.h        |   12 ++----
 include/linux/task_work.h    |   32 ++++++++++++++++
 include/linux/tracehook.h    |   14 ++++++--
 kernel/Makefile              |    2 +-
 kernel/exit.c                |    5 ++-
 kernel/fork.c                |    1 +
 kernel/irq/manage.c          |   69 +++++++++++++++++------------------
 kernel/task_work.c           |   81 ++++++++++++++++++++++++++++++++++++++++++
 security/keys/internal.h     |    3 +-
 security/keys/keyctl.c       |   76 ++++++++++++++++++--------------------
 security/keys/process_keys.c |   25 ++++---------
 13 files changed, 213 insertions(+), 117 deletions(-)

