Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0EFXrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:47:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63535 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab0EFXrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:47:01 -0400
Date: Thu, 6 May 2010 16:46:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       lud <linux-usb@vger.kernel.org>
Subject: [PATCH -next] usb: fix u132-hcd code/data warning
Message-Id: <20100506164603.5c5107b7.randy.dunlap@oracle.com>
In-Reply-To: <20100506151502.f97afe54.sfr@canb.auug.org.au>
References: <20100506151502.f97afe54.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090201.4BE354F0.00E4:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix gcc warning on mixed declarations/code:
drivers/usb/host/u132-hcd.c:1450: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/host/u132-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100506.orig/drivers/usb/host/u132-hcd.c
+++ linux-next-20100506/drivers/usb/host/u132-hcd.c
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
