Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761566Ab0HMMOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 08:14:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57472 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761543Ab0HMMOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 08:14:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Yw/n1QjDOJnQcF7wqu9rCgmHvnqrywpjNrK+NpYWiNSCJLGNeMfZObUjfy71/3JBDQ
         jjWSz6D7knWzOn+tqL06V9vNoXzpBl6nkdrHBd8tTx5LB7proWWekznuZbTHgimrY9Od
         +t5PHPsX1GVDuL5VBN9WLdGMEKJuHUaw+W0fw=
MIME-Version: 1.0
Date: Fri, 13 Aug 2010 21:14:20 +0900
Message-ID: <AANLkTinDWt_Fxk=VoHfZ+ePfLO8LBtv0fg5xhuN1OxuM@mail.gmail.com>
Subject: [PATCH] video: v4l2-ctrls.c missing include
From: Jerome Pinot <ngc891@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>, Linus Torvalds <torvalds@osdl.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A missing include in drivers/media/video/v4l2-ctrls.c makes the kernel
(2.6.35-07788-g320b2b8) fail to build:

  CC      drivers/media/video/v4l2-ctrls.o
drivers/media/video/v4l2-ctrls.c: In function ‘v4l2_ctrl_handler_init’:
drivers/media/video/v4l2-ctrls.c:766: error: implicit declaration of
function ‘kzalloc’
drivers/media/video/v4l2-ctrls.c:767: warning: assignment makes
pointer from integer without a cast
drivers/media/video/v4l2-ctrls.c: In function ‘v4l2_ctrl_handler_free’:
drivers/media/video/v4l2-ctrls.c:786: error: implicit declaration of
function ‘kfree’
drivers/media/video/v4l2-ctrls.c: In function ‘handler_new_ref’:
drivers/media/video/v4l2-ctrls.c:896: warning: assignment makes
pointer from integer without a cast
drivers/media/video/v4l2-ctrls.c: In function ‘v4l2_ctrl_new’:
drivers/media/video/v4l2-ctrls.c:975: warning: assignment makes
pointer from integer without a cast
drivers/media/video/v4l2-ctrls.c: In function ‘v4l2_g_ext_ctrls’:
drivers/media/video/v4l2-ctrls.c:1528: error: implicit declaration of
function ‘kmalloc’
drivers/media/video/v4l2-ctrls.c:1528: warning: assignment makes
pointer from integer without a cast
drivers/media/video/v4l2-ctrls.c: In function ‘try_set_ext_ctrls’:
drivers/media/video/v4l2-ctrls.c:1752: warning: assignment makes
pointer from integer without a cast
make[3]: *** [drivers/media/video/v4l2-ctrls.o] Error 1
make[2]: *** [drivers/media/video] Error 2
make[1]: *** [drivers/media] Error 2
make: *** [drivers] Error 2

The following trivial patch corrects this.

Signed-off-by: Jerome Pinot <ngc891@gmail.com>
--
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 84c1a53..ea8d32c 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -19,6 +19,7 @@
  */

 #include <linux/ctype.h>
+#include <linux/slab.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>



-- 
Jérôme Pinot
http://ngc891.blogdns.net/
