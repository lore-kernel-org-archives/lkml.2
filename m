Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050Ab0HEWr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:47:27 -0400
Received: from kroah.org ([198.145.64.141]:37569 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760771Ab0HEWXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:23:45 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jeff Dike <jdike@addtoit.com>, Jeff Dike <jdike@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/67] tty: Remove Hayes ESP ioctls
Date: Thu,  5 Aug 2010 15:22:36 -0700
Message-Id: <1281047014-23429-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Dike <jdike@addtoit.com>

Remove Hayes ESP ioctls

The Hayes ESP driver has been removed from the tree:
commit f53a2ade0bb9f2a81f473e6469155172a96b7c38
("tty: esp: remove broken driver")
so its ioctls aren't needed any more.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/asm-generic/ioctls.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
index a799e20..1375fa1 100644
--- a/include/asm-generic/ioctls.h
+++ b/include/asm-generic/ioctls.h
@@ -87,12 +87,10 @@
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
 
 /*
- * some architectures define FIOQSIZE as 0x545E, which is used for
- * TIOCGHAYESESP on others
+ * Some arches already define FIOQSIZE due to a historical
+ * conflict with a Hayes modem-specific ioctl value.
  */
 #ifndef FIOQSIZE
-# define TIOCGHAYESESP	0x545E  /* Get Hayes ESP configuration */
-# define TIOCSHAYESESP	0x545F  /* Set Hayes ESP configuration */
 # define FIOQSIZE	0x5460
 #endif
 
-- 
1.7.2

