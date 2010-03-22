Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab0CVSd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:33:56 -0400
Received: from quartz.orcorp.ca ([139.142.54.143]:44222 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755Ab0CVSdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:33:55 -0400
Date: Mon, 22 Mar 2010 12:33:52 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] Fix build failure, INOTIFY_USER requires ANON_INODES
Message-ID: <20100322183352.GA19451@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or linking can fail needing anon_inode_getfd called from
sys_inotify_init1.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 fs/notify/inotify/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Tested on powerpc with CONFIG_EMBEDDED/etc

diff --git a/fs/notify/inotify/Kconfig b/fs/notify/inotify/Kconfig
index 3e56dbf..af2fc8e 100644
--- a/fs/notify/inotify/Kconfig
+++ b/fs/notify/inotify/Kconfig
@@ -16,6 +16,7 @@ config INOTIFY
 config INOTIFY_USER
 	bool "Inotify support for userspace"
 	select FSNOTIFY
+	select ANON_INODES
 	default y
 	---help---
 	  Say Y here to enable inotify support for userspace, including the
-- 
1.5.4.2

