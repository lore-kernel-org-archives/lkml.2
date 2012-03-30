Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936468Ab2C3WGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:06:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965425Ab2C3VQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:16:08 -0400
Message-Id: <20120330194903.179117300@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Jones <davej@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 140/149] Remove printk from rds_sendmsg
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Dave Jones <davej@redhat.com>

[ Upstream commit a6506e1486181975d318344143aca722b2b91621 ]

no socket layer outputs a message for this error and neither should rds.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/send.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -935,7 +935,6 @@ int rds_sendmsg(struct kiocb *iocb, stru
 	/* Mirror Linux UDP mirror of BSD error message compatibility */
 	/* XXX: Perhaps MSG_MORE someday */
 	if (msg->msg_flags & ~(MSG_DONTWAIT | MSG_CMSG_COMPAT)) {
-		printk(KERN_INFO "msg_flags 0x%08X\n", msg->msg_flags);
 		ret = -EOPNOTSUPP;
 		goto out;
 	}


