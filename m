Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142Ab0IPEDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 00:03:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33030 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0IPEDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 00:03:22 -0400
Date: Thu, 16 Sep 2010 14:03:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: linux-next: manual merge of the bkl-trivial tree with the pcmcia
 tree
Message-Id: <20100916140314.593c98cd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the bkl-trivial tree got a conflict in
drivers/char/pcmcia/cm4000_cs.c drivers/char/pcmcia/cm4040_cs.c between
commit 2cf3b10bf1a5b763c8acb54d61bbfb5fb1814dad ("pcmcia: avoid messages
on module (un)loading") from the pcmcia tree and commit
65c7297b0322453d238b2d23918a3a8b3a223c3b ("drivers: autoconvert trivial
BKL users to private mutex") from the bkl-trivial tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/char/pcmcia/cm4000_cs.c
index c7b482d,7d091b6..0000000
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@@ -54,6 -55,9 +54,8 @@@
  			   __func__ , ## args);		\
  	} while (0)
  
+ static DEFINE_MUTEX(cmm_mutex);
 -static char *version = "cm4000_cs.c v2.4.0gm6 - All bugs added by Harald Welte";
+ 
  #define	T_1SEC		(HZ)
  #define	T_10MSEC	msecs_to_jiffies(10)
  #define	T_20MSEC	msecs_to_jiffies(20)
diff --cc drivers/char/pcmcia/cm4040_cs.c
index bf2f046,04c0a89..0000000
--- a/drivers/char/pcmcia/cm4040_cs.c
+++ b/drivers/char/pcmcia/cm4040_cs.c
@@@ -48,6 -49,10 +48,8 @@@
  			   __func__ , ## args);		\
  	} while (0)
  
+ static DEFINE_MUTEX(cm4040_mutex);
 -static char *version =
 -"OMNIKEY CardMan 4040 v1.1.0gm5 - All bugs added by Harald Welte";
+ 
  #define	CCID_DRIVER_BULK_DEFAULT_TIMEOUT  	(150*HZ)
  #define	CCID_DRIVER_ASYNC_POWERUP_TIMEOUT 	(35*HZ)
  #define	CCID_DRIVER_MINIMUM_TIMEOUT 		(3*HZ)
