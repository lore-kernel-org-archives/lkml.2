Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0J1HZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 03:25:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab0J1HZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 03:25:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] Fix a missing inclusion of linux/types.h in linux/fs.h
To: torvalds@osdl.org, akpm@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: lczerner@redhat.com, dmonakhov@openvz.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org
Date: Thu, 28 Oct 2010 08:25:28 +0100
Message-ID: <20101028072528.31276.91746.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/fs.h needs to #include linux/types.h otherwise the following errors can be
encountered:

In file included from fs/char_dev.c:8:
include/linux/fs.h:36: error: expected specifier-qualifier-list before 'uint64_t'
In file included from include/linux/tty.h:9,
                 from drivers/char/tty_mutex.c:4:
include/linux/fs.h:36: error: expected specifier-qualifier-list before 'uint64_t'
In file included from mm/shmem.c:23:
include/linux/fs.h:36: error: expected specifier-qualifier-list before 'uint64_t'

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/fs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6ed7ace..15de46d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -6,6 +6,7 @@
  * structures etc.
  */
 
+#include <linux/types.h>
 #include <linux/limits.h>
 #include <linux/ioctl.h>
 #include <linux/blk_types.h>

