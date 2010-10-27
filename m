Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0J0Q75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:59:57 -0400
Received: from king.tilera.com ([72.1.168.226]:10610 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab0J0Q74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:59:56 -0400
Message-Id: <201010271659.o9RGxrMc009847@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 27 Oct 2010 12:54:27 -0400
Subject: [PATCH] drivers/char/hvc_console.c: reduce max idle timeout
To: linux-kernel@vger.kernel.org
To: linuxppc-dev@lists.ozlabs.org
X-OriginalArrivalTime: 27 Oct 2010 16:59:55.0319 (UTC) FILETIME=[6131E470:01CB75F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tile architecture uses this framework for our serial console,
and our users complain that the delay of up to two seconds feels like
the machine has gone non-responsive and is disturbing.  By contrast,
a delay of up to half a second feels like just the normal sort of
delay caused by swapping, network lag, etc. and is not noticeable.
The overhead is obviously not much greater.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---

I'm happy to push this via the tile tree if the linuxppc-dev folks
want to give me an acked-by, or you can take it into your tree.  Thanks!

 drivers/char/hvc_console.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 3afd62e..1df5431 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -565,11 +565,11 @@ static int hvc_chars_in_buffer(struct tty_struct *tty)
  * and during console activity we will use a default MIN_TIMEOUT of 10.  When
  * the console is idle, we increase the timeout value on each pass through
  * msleep until we reach the max.  This may be noticeable as a brief (average
- * one second) delay on the console before the console responds to input when
+ * 0.25 second) delay on the console before the console responds to input when
  * there has been no input for some time.
  */
 #define MIN_TIMEOUT		(10)
-#define MAX_TIMEOUT		(2000)
+#define MAX_TIMEOUT		(500)
 static u32 timeout = MIN_TIMEOUT;
 
 #define HVC_POLL_READ	0x00000001
-- 
1.6.5.2

