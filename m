Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab0EKXnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:43:19 -0400
Received: from kroah.org ([198.145.64.141]:57797 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab0EKXnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:43:17 -0400
Subject: patch usb-fix-u132-hcd-code-data-warning.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Tue, 11 May 2010 16:43:04 -0700
In-Reply-To: <20100506164603.5c5107b7.randy.dunlap@oracle.com>
Message-ID: <12736213841919@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: USB: fix u132-hcd code/data warning

to my gregkh-2.6 tree.  Its filename is

    usb-fix-u132-hcd-code-data-warning.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From randy.dunlap@oracle.com  Tue May 11 16:25:40 2010
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Thu, 6 May 2010 16:46:03 -0700
Subject: USB: fix u132-hcd code/data warning
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, lud <linux-usb@vger.kernel.org>
Message-ID: <20100506164603.5c5107b7.randy.dunlap@oracle.com>


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix gcc warning on mixed declarations/code:
drivers/usb/host/u132-hcd.c:1450: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/u132-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -1446,9 +1446,9 @@ static void u132_hcd_endp_work_scheduler
 			return;
 		} else {
 			int retval;
-			address = u132->addr[endp->usb_addr].address;
 			struct urb *urb = endp->urb_list[ENDP_QUEUE_MASK &
 				endp->queue_next];
+			address = u132->addr[endp->usb_addr].address;
 			endp->active = 1;
 			ring->curr_endp = endp;
 			ring->in_use = 1;

