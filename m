Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab2FOPNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:13:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41535 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab2FOPNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:13:13 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Chris Friesen <chris.friesen@genband.com>
Subject: [PATCH v2 0/2] msync improvements
Date: Fri, 15 Jun 2012 17:12:57 +0200
Message-Id: <1339773179-31210-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches are improvements on the implementation of the msync
system call.  To give some context, I found them while working on
the implementation of a persistent dirty bitmap.

Paolo Bonzini (2):
  msync: support syncing a small part of the file
  msync: start async writeout when MS_ASYNC

 include/linux/fs.h |    3 +-
 mm/fadvise.c       |    2 +-
 mm/filemap.c       |   11 +++++---
 mm/msync.c         |   63 +++++++++++++++++++++++++++++++++-------------------
 4 files changed, 50 insertions(+), 29 deletions(-)


