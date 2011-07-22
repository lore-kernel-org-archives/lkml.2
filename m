Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1GVRmC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 13:42:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab1GVRmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 13:42:00 -0400
Date: Fri, 22 Jul 2011 13:41:56 -0400
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 3.1
Message-ID: <20110722174156.GB16459@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 3.1 from:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

The three large patches are relatively low hanging efficiency improvements:
replacing the lock hash table with idr, improving resource hash table lookups
by pre-allocating, and replacing the single callback thread with per-lockspace
workqueues.
Thanks,
Dave

Bryn M. Reeves (1):
      dlm: use vmalloc for hash tables

David Teigland (6):
      dlm: fix kmalloc args
      dlm: keep lkbs in idr
      dlm: improve rsb searches
      dlm: remove deadlock debug print
      dlm: use workqueue for callbacks
      dlm: don't limit active work items

Jesper Juhl (1):
      dlm: don't do pointless NULL check, use kzalloc and fix order of arguments

Masatake YAMATO (2):
      dlm: show addresses in configfs
      dlm: dump address of unknown node

 fs/dlm/ast.c          |  265 ++++++++++++++++++++++---------------------------
 fs/dlm/ast.h          |   15 ++--
 fs/dlm/config.c       |   75 ++++++++++++--
 fs/dlm/config.h       |    2 +-
 fs/dlm/dlm_internal.h |   29 +++---
 fs/dlm/lock.c         |  225 ++++++++++++++++++++++-------------------
 fs/dlm/lockspace.c    |  175 ++++++++++++++++----------------
 fs/dlm/lowcomms.c     |    9 +-
 fs/dlm/memory.c       |   22 +++--
 fs/dlm/memory.h       |    2 +-
 fs/dlm/recoverd.c     |   12 +--
 fs/dlm/user.c         |   12 +-
 12 files changed, 446 insertions(+), 397 deletions(-)
