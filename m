Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab0DVTdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:33:43 -0400
Received: from kroah.org ([198.145.64.141]:41578 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782Ab0DVT35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:57 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:23 2010
Message-Id: <20100422190923.903359954@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kashyap Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>,
       maximilian attems <max@stro.at>
Subject: [184/197] [SCSI] mptctl : Remove printk which floods unnecessary messages to var/log/message
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kashyap, Desai <kashyap.desai@lsi.com>

commit e39e145dfb78d4e20d89139d2576306b4279c126 upstream.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/message/fusion/mptctl.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -621,11 +621,8 @@ __mptctl_ioctl(struct file *file, unsign
 	 */
 	iocnumX = khdr.iocnum & 0xFF;
 	if (((iocnum = mpt_verify_adapter(iocnumX, &iocp)) < 0) ||
-	    (iocp == NULL)) {
-		printk(KERN_DEBUG MYNAM "%s::mptctl_ioctl() @%d - ioc%d not found!\n",
-				__FILE__, __LINE__, iocnumX);
+	    (iocp == NULL))
 		return -ENODEV;
-	}
 
 	if (!iocp->active) {
 		printk(KERN_DEBUG MYNAM "%s::mptctl_ioctl() @%d - Controller disabled.\n",


