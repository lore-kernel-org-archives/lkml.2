Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1AFIeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:34:20 -0500
Received: from borg.asidev.net ([95.141.38.199]:51867 "EHLO borg.asidev.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab1AFIeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:34:19 -0500
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2011 03:34:19 EST
Message-ID: <4D257C87.4040400@evidence.eu.com>
Date: Thu, 06 Jan 2011 09:25:43 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: starvik@axis.com, Jesper Nilsson <Jesper.Nilsson@axis.com>
CC: linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] RS485 on Cris: use global value of TIOCSRS485
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper, Hi Mikael,

	    the following patch sets the value of TIOCSRS485 on Cris
equal to the value of all other architectures (as currently is for
TIOCGRS485).

With this patch, TIOCSRS485 gets the same value across all
architectures, making maintenance and portability of user-level code
easier.

Best regards,

	Claudio


RS485: use global value of TIOCSRS485 (i.e. 0x546F) on Cris.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
---
 arch/cris/include/asm/ioctls.h |    2 +-
 drivers/serial/crisv10.c       |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/cris/include/asm/ioctls.h b/arch/cris/include/asm/ioctls.h
index 488fbb3..2c15ff8 100644
--- a/arch/cris/include/asm/ioctls.h
+++ b/arch/cris/include/asm/ioctls.h
@@ -4,7 +4,7 @@
 #define TIOCSERGSTRUCT	0x5458 /* For debugging only */
 #define TIOCSERSETRS485	0x5461  /* enable rs-485 (deprecated) */
 #define TIOCSERWRRS485	0x5462  /* write rs-485 */
-#define TIOCSRS485	0x5463  /* enable rs-485 */
+#define TIOCSRS485DEPR	0x5463  /* enable rs-485 (deprecated) */
 
 #include <asm-generic/ioctls.h>
 
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index bcc31f2..29bd418 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -3717,6 +3717,11 @@ rs_ioctl(struct tty_struct *tty, struct file * file,
 		return e100_enable_rs485(tty, &rs485data);
 	}
 
+	case TIOCSRS485DEPR:
+	{
+		printk(KERN_DEBUG "The use of this ioctl is deprecated. Use TIOCSRS485 instead\n");
+		/* Fall through */
+	}
 	case TIOCSRS485:
 	{
 		/* This is the new version of TIOCSRS485, with new
-- 
1.7.1



