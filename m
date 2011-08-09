Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1HILkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 07:40:22 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:33560 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab1HILkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 07:40:21 -0400
Subject: [PATCH] drivers/leds: leds-renesas-tpu.c needs module.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <damm@opensource.se>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 19:40:08 +0800
Message-ID: <1312890008.14708.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

leds-renesas-tpu.c needs to include linux/module.h to fix below build errors.

  CC      drivers/leds/leds-renesas-tpu.o
drivers/leds/leds-renesas-tpu.c:341: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-renesas-tpu.c:341: warning: data definition has no type or storage class
drivers/leds/leds-renesas-tpu.c:341: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/leds/leds-renesas-tpu.c:341: warning: function declaration isn't a prototype
drivers/leds/leds-renesas-tpu.c:342: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-renesas-tpu.c:342: warning: data definition has no type or storage class
drivers/leds/leds-renesas-tpu.c:342: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/leds/leds-renesas-tpu.c:342: warning: function declaration isn't a prototype
drivers/leds/leds-renesas-tpu.c:343: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-renesas-tpu.c:343: warning: data definition has no type or storage class
drivers/leds/leds-renesas-tpu.c:343: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/leds/leds-renesas-tpu.c:343: warning: function declaration isn't a prototype
make[2]: *** [drivers/leds/leds-renesas-tpu.o] Error 1
make[1]: *** [drivers/leds] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-renesas-tpu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-renesas-tpu.c b/drivers/leds/leds-renesas-tpu.c
index 5bfb40e1..d9a7d72 100644
--- a/drivers/leds/leds-renesas-tpu.c
+++ b/drivers/leds/leds-renesas-tpu.c
@@ -17,6 +17,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
-- 
1.7.4.1



