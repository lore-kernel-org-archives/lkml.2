Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab0JNEGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:06:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48669 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab0JNEEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:04:21 -0400
Date: Wed, 13 Oct 2010 18:16:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Marcel Holtmann <marcel@holtmann.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH -next] bluetooth: fix hidp kconfig dependency warning
Message-Id: <20101013181652.7ddf481e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning to satisfy dependencies:

warning: (BT_HIDP && NET && BT && BT_L2CAP && INPUT || USB_HID && HID_SUPPORT && USB && INPUT) selects HID which has unmet direct dependencies (HID_SUPPORT && INPUT)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/bluetooth/hidp/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20101013.orig/net/bluetooth/hidp/Kconfig
+++ linux-next-20101013/net/bluetooth/hidp/Kconfig
@@ -1,6 +1,6 @@
 config BT_HIDP
 	tristate "HIDP protocol support"
-	depends on BT && BT_L2CAP && INPUT
+	depends on BT && BT_L2CAP && INPUT && HID_SUPPORT
 	select HID
 	help
 	  HIDP (Human Interface Device Protocol) is a transport layer
