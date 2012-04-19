Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab2DSVJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:09:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41811 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933126Ab2DSVJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:09:53 -0400
Message-Id: <20120419210612.387534950@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 15/59] cciss: Fix scsi tape io with more than 255 scatter gather elements
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit bc67f63650fad6b3478d9ddfd5406d45a95987c9 upstream.

The total number of scatter gather elements in the CISS command
used by the scsi tape code was being cast to a u8, which can hold
at most 255 scatter gather elements.  It should have been cast to
a u16.  Without this patch the command gets rejected by the controller
since the total scatter gather count did not add up to the right
value resulting in an i/o error.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/cciss_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1411,7 +1411,7 @@ static void cciss_scatter_gather(ctlr_in
 	/* track how many SG entries we are using */
 	if (request_nsgs > h->maxSG)
 		h->maxSG = request_nsgs;
-	c->Header.SGTotal = (__u8) request_nsgs + chained;
+	c->Header.SGTotal = (u16) request_nsgs + chained;
 	if (request_nsgs > h->max_cmd_sgentries)
 		c->Header.SGList = h->max_cmd_sgentries;
 	else


