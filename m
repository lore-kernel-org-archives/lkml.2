Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188Ab2EUVSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:18:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759098Ab2EUVSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:18:44 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] dlm and gfs2 patches for 3.5
Date: Mon, 21 May 2012 16:18:32 -0500
Message-Id: <1337635120-19969-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These are dlm and gfs2 patches from -next for 3.5.  The one large patch
fixes various problems with the "nodir" mode, in which the dlm operates
without a resource directory (a long neglected feature).  Other patches
are all minor fixes and improvements.

Dan Carpenter (1):
      dlm: NULL dereference on failure in kmem_cache_create()

David Teigland (7):
      dlm: prevent connections during shutdown
      dlm: fix waiter recovery
      dlm: limit rcom debug messages
      dlm: avoid unnecessary search in search_rsb
      dlm: improve error and debug messages
      dlm: fixes for nodir mode
      gfs2: fix recovery during unmount

 fs/dlm/ast.c          |    3 +-
 fs/dlm/dlm_internal.h |   16 +-
 fs/dlm/lock.c         |  541 +++++++++++++++++++++++++++++++++----------------
 fs/dlm/lock.h         |    7 +-
 fs/dlm/lockspace.c    |   20 ++
 fs/dlm/lowcomms.c     |   28 ++-
 fs/dlm/memory.c       |    8 +-
 fs/dlm/rcom.c         |   61 +++---
 fs/dlm/recover.c      |   73 ++++---
 fs/dlm/recoverd.c     |   15 +-
 fs/dlm/requestqueue.c |   43 ++--
 fs/gfs2/incore.h      |    1 -
 fs/gfs2/lock_dlm.c    |    2 -
 fs/gfs2/ops_fstype.c  |    7 +-
 fs/gfs2/sys.c         |   10 +-
 include/linux/dlm.h   |    1 -
 16 files changed, 538 insertions(+), 298 deletions(-)

