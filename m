Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab0C3XM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:12:56 -0400
Received: from kroah.org ([198.145.64.141]:49181 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600Ab0C3XMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:53 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:50 2010
Message-Id: <20100330225850.349949516@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:58:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [67/89] class: Free the class private data in class_release
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 18d19c96457d172d913510c083bc7411ed40cb10 upstream.

Fix a memory leak by freeing the memory allocated in __class_register
for the class private data.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/class.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -59,6 +59,8 @@ static void class_release(struct kobject
 	else
 		pr_debug("class '%s' does not have a release() function, "
 			 "be careful\n", class->name);
+
+	kfree(cp);
 }
 
 static struct sysfs_ops class_sysfs_ops = {


