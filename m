Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab0EaITO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:19:14 -0400
Received: from borg.asidev.net ([95.141.32.69]:35897 "EHLO borg.asidev.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134Ab0EaITN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:19:13 -0400
Message-ID: <4C0370FD.3090909@evidence.eu.com>
Date: Mon, 31 May 2010 10:19:09 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: starvik@axis.com, jesper.nilsson@axis.com
CC: linux-cris-kernel@axis.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hinko Kocevar <hinko.kocevar@cetrtapot.si>,
       Janez Cufer <janez.cufer@cetrtapot.si>,
       Andy Whitcroft <apw@canonical.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dev-etrax@axis.com
Subject: [PATCH] ioctl for getting RS485 information on Cris architecture
References: <49A51878.7020206@evidence.eu.com>
In-Reply-To: <49A51878.7020206@evidence.eu.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper, hi Mikael, 

	I think that the Cris architecture should provide a full RS485 interface (like the atmel_serial driver).

Therefore, I propose this patch which adds an ioctl to get RS485 information from user-level.

Best regards,

             Claudio


Cris serial driver: ioctl to get RS485 data from user-space

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
---
 arch/cris/include/asm/ioctls.h |    1 +
 drivers/serial/crisv10.c       |   11 +++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/cris/include/asm/ioctls.h b/arch/cris/include/asm/ioctls.h
index 35bbc18..076c078 100644
--- a/arch/cris/include/asm/ioctls.h
+++ b/arch/cris/include/asm/ioctls.h
@@ -77,6 +77,7 @@
 #define TIOCSERSETRS485	0x5461  /* enable rs-485 (deprecated) */
 #define TIOCSERWRRS485	0x5462  /* write rs-485 */
 #define TIOCSRS485	0x5463  /* enable rs-485 */
+#define TIOCGRS485	0x542E  /* get rs-485 */
 
 /* Used for packet mode */
 #define TIOCPKT_DATA		 0
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 31f1723..3062644 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -3724,6 +3724,17 @@ rs_ioctl(struct tty_struct *tty, struct file * file,
 		return e100_enable_rs485(tty, &rs485data);
 	}
 
+	case TIOCGRS485:
+	{
+		struct serial_rs485 *rs485data =
+			&(((struct e100_serial *)tty->driver_data)->rs485);
+		/* This is the ioctl to get RS485 data from user-space */
+		if (copy_to_user((struct serial_rs485 *) arg,
+					rs485data,
+					sizeof(serial_rs485)))
+			return -EFAULT;
+		break;
+	}
 
 	case TIOCSERWRRS485:
 	{
-- 
1.6.0.4

