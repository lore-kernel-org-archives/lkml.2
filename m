Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0EXUbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:31:53 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52579 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab0EXUbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:31:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=vAkXXm9uD60h2v1zdTNEMDKCa6kfGoAYXBOX/yjXsFHh8jx+CfxiqiTW+DQ9uc2Vs
	lHmXCExqjDWnwE4Ok8t9A==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH 00/11] V4: rwsem changes + down_read_critical() proposal
Date: Mon, 24 May 2010 13:31:10 -0700
Message-Id: <1274733081-4623-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 4 of my rwsem changes.

Changes since V3:

- Split first x86 rwsem change in two smaller parts
- Added David's rwsem_waiter_type enum suggestion into
  'rwsem: down_read_critical infrastructure support'
- Lots of minor style fixes and comments clarified

I would hope the entire series can be considered for inclusion;
however if we can not agree on the down_read_critical() bits I would
still like patches 1-7 to be independently considered as I think they
still have merit on their own.

Michel Lespinasse (11):
  x86 rwsem: stay on fast path when count>0 in __up_write()
  x86 rwsem: minor cleanups
  rwsem: fully separate code pathes to wake writers vs readers
  rwsem: lighter active count checks when waking up readers
  rwsem: let RWSEM_WAITING_BIAS represent any number of waiting threads
  rwsem: wake queued readers when writer blocks on active read lock
  rwsem: smaller wrappers around rwsem_down_failed_common
  generic rwsem: implement down_read_critical() / up_read_critical()
  rwsem: down_read_critical infrastructure support
  x86 rwsem: down_read_critical implementation
  Use down_read_critical() for /proc/<pid>/exe and /proc/<pid>/maps files

 arch/x86/include/asm/rwsem.h   |   73 +++++++++++------
 arch/x86/lib/rwsem_64.S        |   14 +++-
 arch/x86/lib/semaphore_32.S    |   21 ++++-
 fs/proc/base.c                 |    4 +-
 fs/proc/task_mmu.c             |   24 ++++--
 include/linux/proc_fs.h        |    1 +
 include/linux/rwsem-spinlock.h |   10 ++-
 include/linux/rwsem.h          |   12 +++
 kernel/rwsem.c                 |   35 ++++++++
 lib/rwsem-spinlock.c           |   10 ++-
 lib/rwsem.c                    |  178 +++++++++++++++++++++++++---------------
 11 files changed, 276 insertions(+), 106 deletions(-)
