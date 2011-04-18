Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab1DROis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:38:48 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60113 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab1DROig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:38:36 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.38+drm33.16
Date: Mon, 18 Apr 2011 16:38:34 +0200
Message-Id: <1303137514-8945-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: linux-kernel@vger.kernel.org
To: stable@kernel.org
To: kernel-team@lists.ubuntu.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.38+drm33.16 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release contains patches from upstream 2.6.32.38, but dropped any patches
to the DRM subsystem.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* Revert "net: fix rds_iovec page count overflow"
* Linux 2.6.32.38

 Makefile       |    2 +-
 net/rds/rdma.c |    8 --------
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 9e9d9b7..6b2feae 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .37+drm33.16
+EXTRAVERSION = .38+drm33.16
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index f7d8c08..6b09b94 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -473,14 +473,6 @@ static struct rds_rdma_op *rds_rdma_prepare(struct rds_sock *rs,

 		max_pages = max(nr, max_pages);
 		nr_pages += nr;
-
-		/*
-		 * nr_pages for one entry is limited to (UINT_MAX>>PAGE_SHIFT)+1,
-		 * so tot_pages cannot overflow without first going negative.
-		 */
-		if ((int)nr_pages < 0)
-			ret = -EINVAL;
-			goto out;
 	}

 	pages = kcalloc(max_pages, sizeof(struct page *), GFP_KERNEL);
