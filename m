Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965604Ab2C3V7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:59:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965572Ab2C3VR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:17:57 -0400
Message-Id: <20120330194829.475734054@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Faber <thfabba@gmx.de>
Subject: [ 025/175] usb: gadgetfs: return number of bytes on ep0 read request
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Faber <thfabba@gmx.de>

commit 85b4b3c8c189e0159101f7628a71411af072ff69 upstream.

A read from GadgetFS endpoint 0 during the data stage of a control
request would always return 0 on success (as returned by
wait_event_interruptible) despite having written data into the user
buffer.
This patch makes it correctly set the return value to the number of
bytes read.

Signed-off-by: Thomas Faber <thfabba@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1043,6 +1043,8 @@ ep0_read (struct file *fd, char __user *
 // FIXME don't call this with the spinlock held ...
 				if (copy_to_user (buf, dev->req->buf, len))
 					retval = -EFAULT;
+				else
+					retval = len;
 				clean_req (dev->gadget->ep0, dev->req);
 				/* NOTE userspace can't yet choose to stall */
 			}


