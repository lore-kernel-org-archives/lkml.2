Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab2LTTNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:13:52 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48644 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab2LTTN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:13:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Du Changbin <changbinx.du@intel.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Sasha Levin <sasha.levin@oracle.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tools/usb: remove unneeded 'continue' and simplify condition
Date: Thu, 20 Dec 2012 14:11:15 -0500
Message-Id: <1356030701-16284-7-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basically remove unneeded code. Since that 'continue' is at the end
of the for() there's no need for it.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/usb/testusb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c
index 68d0734..643cd77 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -507,10 +507,8 @@ usage:
 			return handle_testdev (entry) != entry;
 		}
 		status = pthread_create (&entry->thread, 0, handle_testdev, entry);
-		if (status) {
+		if (status)
 			perror ("pthread_create");
-			continue;
-		}
 	}
 	if (device) {
 		struct testdev		dev;
-- 
1.8.0

