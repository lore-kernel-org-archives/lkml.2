Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab0JSHHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 03:07:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51146 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758050Ab0JSHHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 03:07:34 -0400
Date: Tue, 19 Oct 2010 18:07:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Devin Heitmueller <dheitmueller@hauppauge.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: build failure after merge of the final tree (v4l-dvb
 tree related)
Message-Id: <20101019180730.5beac8af.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/media/video/cx231xx/cx231xx-417.c: In function 'cx231xx_load_firmware':
drivers/media/video/cx231xx/cx231xx-417.c:943: error: implicit declaration of function 'vmalloc'
drivers/media/video/cx231xx/cx231xx-417.c:943: warning: cast to pointer from integer of different size
drivers/media/video/cx231xx/cx231xx-417.c:950: warning: cast to pointer from integer of different size
drivers/media/video/cx231xx/cx231xx-417.c:1039: error: implicit declaration of function 'vfree'

Caused by commit e0bb3704be9decb10985b0886031e76a228b5f32 ("[media]
cx231xx: Added support for Carraera, Shelby, RDx_253S and VIDEO_GRABBER").

Also, I don't think Arnd is going to like the new BKL usage also
introduced by the commit.  ;-)

I added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 19 Oct 2010 18:01:25 +1100
Subject: [PATCH] v4l-dvb: using vmalloc needs vmalloc.h in cx231xx-417.c

Fixes these build errors and warnings:

drivers/media/video/cx231xx/cx231xx-417.c: In function 'cx231xx_load_firmware':
drivers/media/video/cx231xx/cx231xx-417.c:943: error: implicit declaration of function 'vmalloc'
drivers/media/video/cx231xx/cx231xx-417.c:943: warning: cast to pointer from integer of different size
drivers/media/video/cx231xx/cx231xx-417.c:950: warning: cast to pointer from integer of different size
drivers/media/video/cx231xx/cx231xx-417.c:1039: error: implicit declaration of function 'vfree'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/media/video/cx231xx/cx231xx-417.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-417.c b/drivers/media/video/cx231xx/cx231xx-417.c
index e456b97..aab21f3 100644
--- a/drivers/media/video/cx231xx/cx231xx-417.c
+++ b/drivers/media/video/cx231xx/cx231xx-417.c
@@ -32,6 +32,7 @@
 #include <linux/device.h>
 #include <linux/firmware.h>
 #include <linux/smp_lock.h>
+#include <linux/vmalloc.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/cx2341x.h>
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
