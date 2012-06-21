Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2FUBa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:30:56 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:53069 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756530Ab2FUBay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:30:54 -0400
Message-ID: <4FE27936.8090401@xenotime.net>
Date: Wed, 20 Jun 2012 18:30:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] media: pms.c needs linux/slab.h
References: <20120619212521.D53D6A01BD@akpm.mtv.corp.google.com>
In-Reply-To: <20120619212521.D53D6A01BD@akpm.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

drivers/media/video/pms.c uses kzalloc() and kfree() so it should
include <linux/slab.h> to fix build errors and a warning.

drivers/media/video/pms.c:1047:2: error: implicit declaration of function 'kzalloc'
drivers/media/video/pms.c:1047:6: warning: assignment makes pointer from integer without a cast
drivers/media/video/pms.c:1116:2: error: implicit declaration of function 'kfree'

Found in mmotm but applies to mainline.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/pms.c |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-0619.orig/drivers/media/video/pms.c
+++ mmotm-0619/drivers/media/video/pms.c
@@ -29,6 +29,7 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/isa.h>
 #include <asm/io.h>
