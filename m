Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab2GSMnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:43:08 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37316 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2GSMnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:43:01 -0400
X-AuditID: b753bd60-92cf1ba000004f2e-49-500800d2f66d
X-AuditID: b753bd60-92cf1ba000004f2e-49-500800d2f66d
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 6/6] fuse: add documentation of sysfs parameter to limit
 maximum fuse request size
To: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muthukumar R <muthur@gmail.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Rob Landley <rob@landley.net>, Miklos Szeredi <miklos@szeredi.hu>,
        Nikolaus Rath <Nikolaus@rath.org>, Liu Yuan <namei.unix@gmail.com>,
        Has-Wen Nienhuys <hanwen@xs4all.nl>
Date: Thu, 19 Jul 2012 21:50:08 +0900
Message-ID: <20120719125007.6250.29754.stgit@ltc137.sdl.hitachi.co.jp>
In-Reply-To: <20120719124851.6250.43316.stgit@ltc137.sdl.hitachi.co.jp>
References: <20120719124851.6250.43316.stgit@ltc137.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an explanation about the sysfs parameter to limit the
maximum read/write request size.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Rob Landley <rob@landley.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nikolaus Rath <Nikolaus@rath.org>
Cc: Liu Yuan <namei.unix@gmail.com>
Cc: Has-Wen Nienhuys <hanwen@xs4all.nl>
---

 Documentation/filesystems/fuse.txt |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/fuse.txt b/Documentation/filesystems/fuse.txt
index 13af4a4..4e706ec 100644
--- a/Documentation/filesystems/fuse.txt
+++ b/Documentation/filesystems/fuse.txt
@@ -108,13 +108,26 @@ Mount options
 
   With this option the maximum size of read operations can be set.
   The default is infinite.  Note that the size of read requests is
-  limited anyway to 32 pages (which is 128kbyte on i386).
+  limited by max_pages_per_req sysfs parameter (See below for details.)
 
 'blksize=N'
 
   Set the block size for the filesystem.  The default is 512.  This
   option is only valid for 'fuseblk' type mounts.
 
+Sysfs parameter
+~~~~~~~~~~~~~~~
+
+  '/sys/fs/fuse/max_pages_per_req'
+
+Specify max request size in pages, which limits max_read/max_write
+mount option. The default is 32 pages (which is 128kbyte on i386).
+It can be changed to arbitrary number between 32 and the number of
+pages equivalent to pipe_max_size.
+
+Changing it may improve read/write throughput on systems. Existing
+FUSE mount must be remounted for this change to take effect.
+
 Control filesystem
 ~~~~~~~~~~~~~~~~~~
 

