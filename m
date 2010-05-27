Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab0E0Mhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:37:47 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:43254 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab0E0Mhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:37:45 -0400
Date: Thu, 27 May 2010 14:37:39 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 11/11] drivers/usb/serial: Eliminate a NULL pointer dereference
Message-ID: <Pine.LNX.4.64.1005271437200.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The assignment seems completely unnecessary if mos7840_port is NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E,E1;
identifier f;
statement S1,S2,S3;
@@

if ((E == NULL && ...) || ...)
{
  ... when != if (...) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/serial/mos7840.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index f8424d1..585b7e6 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -730,7 +730,6 @@ static void mos7840_bulk_in_callback(struct urb *urb)
 	mos7840_port = urb->context;
 	if (!mos7840_port) {
 		dbg("%s", "NULL mos7840_port pointer");
-		mos7840_port->read_urb_busy = false;
 		return;
 	}
 
