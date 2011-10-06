Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1JFEyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 00:54:36 -0400
Received: from cobra.newdream.net ([66.33.216.30]:55751 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1JFEye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 00:54:34 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk
Cc: hch@infradead.org, ceph-devel@vger.kernel.org, rwheeler@redhat.com,
        linux-kernel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: [PATCH] d_prune dentry_operation
Date: Wed,  5 Oct 2011 21:26:09 -0700
Message-Id: <1317875170-9349-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ceph goes to great lengths to keep its client-side cache coherent, 
allowing many operations (lookup, creations, readdir) to be performed 
without any server interaction when the client has the proper leases. 

Sadly, this functionality is all currently disabled because we cannot 
handle races between dcache pruning and any of those activities with the 
current VFS interface.

This patch adds a d_prune hook that allows the filesystem to be informed 
before a dentry is removed from the cache.  Merging this for 3.2-rc1 
will make Ceph users and their metadata-intensive workload very happy.

If anybody has any issues at all with this, please tell me, so I can 
make my case or revise my approach.

Thanks!
sage


Sage Weil (1):
  vfs: add d_prune dentry operation

 Documentation/filesystems/Locking |    1 +
 fs/dcache.c                       |    8 ++++++++
 include/linux/dcache.h            |    3 +++
 3 files changed, 12 insertions(+), 0 deletions(-)

-- 
1.7.2.5

