Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291Ab0FQUS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:18:58 -0400
Received: from kroah.org ([198.145.64.141]:53350 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933058Ab0FQUS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:18:57 -0400
Subject: patch tty-remove-hayes-esp-ioctls.patch added to gregkh-2.6 tree
To: jdike@addtoit.com, alan@linux.intel.com, gregkh@suse.de, greg@kroah.com,
       jdike@linux.intel.com, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 17 Jun 2010 13:18:53 -0700
In-Reply-To: <20100617191516.GA15963@c-98-229-117-200.hsd1.ma.comcast.net>
Message-ID: <1276805933630@site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: tty: Remove Hayes ESP ioctls

to my gregkh-2.6 tree.  Its filename is

    tty-remove-hayes-esp-ioctls.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From jdike@addtoit.com  Thu Jun 17 13:03:30 2010
From: Jeff Dike <jdike@addtoit.com>
Date: Thu, 17 Jun 2010 15:15:16 -0400
Subject: tty: Remove Hayes ESP ioctls
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <20100617191516.GA15963@c-98-229-117-200.hsd1.ma.comcast.net>
Content-Disposition: inline

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
 1 file changed, 2 insertions(+), 4 deletions(-)

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
 

