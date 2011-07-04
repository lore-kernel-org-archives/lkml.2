Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab1GDKD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 06:03:28 -0400
Received: from bar.sig21.net ([80.81.252.164]:39128 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab1GDKD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 06:03:26 -0400
Date: Mon, 4 Jul 2011 12:03:17 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] compat_ioctl: fix make headers_check regression
Message-ID: <20110704100316.GA15894@sig21.net>
References: <20110704134842.7ab89126.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704134842.7ab89126.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.635,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix headers_check error introduced by 390192b30057:

include/linux/fd.h:6: included file 'linux/compat.h' is not exported

Signed-off-by: Johannes Stezenbach <js@sig21.net>
---
I used the same style as in linux/usbdevice_fs.h, hope
that's OK.

 include/linux/fd.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/fd.h b/include/linux/fd.h
index c6a68d0..72202b1 100644
--- a/include/linux/fd.h
+++ b/include/linux/fd.h
@@ -3,7 +3,6 @@
 
 #include <linux/ioctl.h>
 #include <linux/compiler.h>
-#include <linux/compat.h>
 
 /* New file layout: Now the ioctl definitions immediately follow the
  * definitions of the structures that they use */
@@ -378,7 +377,11 @@ struct floppy_raw_cmd {
 #define FDEJECT _IO(2, 0x5a)
 /* eject the disk */
 
+
+#ifdef __KERNEL__
 #ifdef CONFIG_COMPAT
+#include <linux/compat.h>
+
 struct compat_floppy_struct {
 	compat_uint_t	size;
 	compat_uint_t	sect;
@@ -394,5 +397,6 @@ struct compat_floppy_struct {
 
 #define FDGETPRM32 _IOR(2, 0x04, struct compat_floppy_struct)
 #endif
+#endif
 
 #endif
