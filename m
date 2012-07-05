Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab2GEKq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:46:27 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:49876 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab2GEKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:46:22 -0400
X-AuditID: b753bd60-9a0f2ba000000f6c-69-4ff56ff6b2c9
X-AuditID: b753bd60-9a0f2ba000000f6c-69-4ff56ff6b2c9
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH 5/5] fuse: add documentation of sysfs parameter to limit
 maximum fuse request size
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Rob Landley <rob@landley.net>, Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2012 19:51:15 +0900
Message-ID: <20120705105115.17812.93681.stgit@ltc137.sdl.hitachi.co.jp>
In-Reply-To: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
References: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an explantion about the sysfs parameter to the limit
maximum read/write request size.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Rob Landley <rob@landley.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>
---

 Documentation/filesystems/fuse.txt |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/fuse.txt b/Documentation/filesystems/fuse.txt
index 13af4a4..e6ffba3 100644
--- a/Documentation/filesystems/fuse.txt
+++ b/Documentation/filesystems/fuse.txt
@@ -108,13 +108,28 @@ Mount options
 
   With this option the maximum size of read operations can be set.
   The default is infinite.  Note that the size of read requests is
-  limited anyway to 32 pages (which is 128kbyte on i386).
+  limited to 32 pages (which is 128kbyte on i386) if direct_io
+  option is not specified. When direct_io option is specified,
+  the request size is limited to max_pages_per_req sysfs parameter.
 
 'blksize=N'
 
   Set the block size for the filesystem.  The default is 512.  This
   option is only valid for 'fuseblk' type mounts.
 
+Sysfs parameter
+~~~~~~~~~~~~~~~
+
+The sysfs parameter max_pages_per_req limits the maximum page size per
+FUSE request.
+
+	/sys/fs/fuse/max_pages_per_req
+
+The default is 32 pages. It can be changed from 32 to 256 pages, which
+may improve the read/write throughput optimizing it. This change is
+effective per mount. Therefore, the re-mounting of FUSE filesystem
+is required after changing it.
+
 Control filesystem
 ~~~~~~~~~~~~~~~~~~
 

