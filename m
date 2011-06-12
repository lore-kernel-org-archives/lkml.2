Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab1FLGkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 02:40:07 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:49470 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1FLGkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 02:40:05 -0400
Date: Sun, 12 Jun 2011 08:40:02 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] UBI changes for 2.6.40
Message-ID: <20110612064002.GA1712@x4.trippels.de>
References: <20110524064147.4545.43792.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110524064147.4545.43792.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.05.24 at 09:41 +0300, Artem Bityutskiy wrote:
> 
>       UBI: use __packed instead of __attribute__((packed))

This patch causes a compile error when I build busybox:

  CC      miscutils/ubi_attach_detach.o
In file included from miscutils/ubi_attach_detach.c:27:0:
/usr/include/mtd/ubi-user.h:330:3: error: conflicting types for ‘__packed’
/usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
/usr/include/mtd/ubi-user.h:372:3: error: conflicting types for ‘__packed’
/usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
/usr/include/mtd/ubi-user.h:387:3: error: conflicting types for ‘__packed’
/usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
/usr/include/mtd/ubi-user.h:399:3: error: conflicting types for ‘__packed’
/usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
/usr/include/mtd/ubi-user.h:413:4: error: conflicting types for ‘__packed’
/usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
make[1]: *** [miscutils/ubi_attach_detach.o] Error 1
make: *** [miscutils] Error 2
make: *** Waiting for unfinished jobs....

Either reverting or using something like this fixes the problem:

diff --git a/include/mtd/ubi-user.h b/include/mtd/ubi-user.h
index 3c41097..47a6c21 100644
--- a/include/mtd/ubi-user.h
+++ b/include/mtd/ubi-user.h
@@ -23,6 +23,10 @@
 
 #include <linux/types.h>
 
+#ifndef __packed
+#define __packed __attribute__((packed))
+#endif
+
 /*
  * UBI device creation (the same as MTD device attachment)
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- 
Markus
