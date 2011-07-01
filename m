Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1GAFpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 01:45:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45413 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab1GAFpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 01:45:12 -0400
Date: Fri, 1 Jul 2011 15:45:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20110701154508.92c8b685.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/video/backlight/ams369fg06.o:(.bss+0x510): multiple definition of `before_power'
drivers/video/backlight/s6e63m0.o:(.bss+0x5e0): first defined here

Caused by commit 45193c8486ef ("Add the ams369fg06 amoled panel driver.
The ams369fg06 amoled panel (480").  The variable should probably be
static in both files.

I have applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 1 Jul 2011 15:34:22 +1000
Subject: [PATCH] backlight: make some varibales static

fixes this build error:

drivers/video/backlight/ams369fg06.o:(.bss+0x510): multiple definition of `before_power'
drivers/video/backlight/s6e63m0.o:(.bss+0x5e0): first defined here

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/video/backlight/ams369fg06.c |    2 +-
 drivers/video/backlight/s6e63m0.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index 86a7daf..d1d8237 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -560,7 +560,7 @@ static int __devexit ams369fg06_remove(struct spi_device *spi)
 }
 
 #if defined(CONFIG_PM)
-unsigned int before_power;
+static unsigned int before_power;
 
 static int ams369fg06_suspend(struct spi_device *spi, pm_message_t mesg)
 {
diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index 322040f..e1803ba 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -840,7 +840,7 @@ static int __devexit s6e63m0_remove(struct spi_device *spi)
 }
 
 #if defined(CONFIG_PM)
-unsigned int before_power;
+static unsigned int before_power;
 
 static int s6e63m0_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-- 
1.7.5.4


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
