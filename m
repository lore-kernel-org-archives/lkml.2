Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0EZNdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:33:49 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:63750 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754247Ab0EZNdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:33:46 -0400
Date: Wed, 26 May 2010 15:33:43 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Greg Ungerer <gerg@uclinux.org>,
       Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] config CONSOLE
Message-ID: <20100526133343.GA7508@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

	CONSOLE is such a generic term that maybe someone just
expected this option exists. Or maybe it existed ages ago but I can't
find any trace of it. Anyway that code has been dead for quite some
time withoutanybody noticing so it's probably just unneeded.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From 4a3b6fda1bb3a229c7ea8ca8992ed2573f07e5ba Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@cs.fau.de>
Date: Wed, 26 May 2010 15:18:26 +0200
Subject: [PATCH] There's no config CONSOLE

as there's no config CONSOLE (never has been as far as I can tell) and
noone has ever missed that piece of code, it should be safe to remove
it making the kernel a tiny bit less complex.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/serial/68328serial.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index 3046386..193a242 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -78,10 +78,6 @@ struct m68k_serial *m68k_consinfo = 0;
 
 #define M68K_CLOCK (16667000) /* FIXME: 16MHz is likely wrong */
 
-#ifdef CONFIG_CONSOLE
-extern wait_queue_head_t keypress_wait; 
-#endif
-
 struct tty_driver *serial_driver;
 
 /* number of characters left in xmit buffer before we ask for more */
@@ -301,9 +297,5 @@ static void receive_chars(struct m68k_serial *info, unsigned short rx)
 #endif /* CONFIG_MAGIC_SYSRQ */
 			}
- 			/* It is a 'keyboard interrupt' ;-) */
-#ifdef CONFIG_CONSOLE
-			wake_up(&keypress_wait);
-#endif			
 		}
 
 		if(!tty)
-- 
1.6.3.3














