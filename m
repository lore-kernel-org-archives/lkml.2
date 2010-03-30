Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab0CaA3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:29:47 -0400
Received: from kroah.org ([198.145.64.141]:48880 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab0C3XMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:16 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:25 2010
Message-Id: <20100330225825.154800852@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ping Cheng <pingc@wacom.com>, Matthew Garrett <mjg@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [27/89] serial: 8250_pnp: use wildcard for serial Wacom tablets
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit 6d34855d9aa281f72c533ecb827405139d1b0fe9 upstream.

Wacom claims that the WACF namespace will always be devoted to serial
Wacom tablets.  Remove the existing entries and add a wildcard to avoid
having to update the kernel every time they add a new device.

Signed-off-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Tested-by: Ping Cheng <pingc@wacom.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250_pnp.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -328,15 +328,7 @@ static const struct pnp_device_id pnp_de
 	/* U.S. Robotics 56K Voice INT PnP*/
 	{	"USR9190",		0	},
 	/* Wacom tablets */
-	{	"WACF004",		0	},
-	{	"WACF005",		0	},
-	{       "WACF006",              0       },
-	{       "WACF007",              0       },
-	{       "WACF008",              0       },
-	{       "WACF009",              0       },
-	{       "WACF00A",              0       },
-	{       "WACF00B",              0       },
-	{       "WACF00C",              0       },
+	{	"WACFXXX",		0	},
 	/* Compaq touchscreen */
 	{       "FPI2002",              0 },
 	/* Fujitsu Stylistic touchscreens */


