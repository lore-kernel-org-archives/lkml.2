Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2JPVzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 17:55:11 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:48591 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2JPVy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 17:54:29 -0400
X-Greylist: delayed 3608 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2012 17:54:29 EDT
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 4/5] IPMI: Fix some uninitialized warning
Date: Tue, 16 Oct 2012 15:53:39 -0500
Message-id: <1350420820-7156-5-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1350420820-7156-1-git-send-email-minyard@acm.org>
References: <1350420820-7156-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

There was a spot where the compiler couldn't tell some variables
would be set.  So initialize them to make the warning go away.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_msghandler.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 2c29942..a0c84bb 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -1880,7 +1880,7 @@ int ipmi_request_supply_msgs(ipmi_user_t          user,
 			     struct ipmi_recv_msg *supplied_recv,
 			     int                  priority)
 {
-	unsigned char saddr, lun;
+	unsigned char saddr = 0, lun = 0;
 	int           rv;
 
 	if (!user)
-- 
1.7.4.1

