Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab0FPNwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 09:52:06 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:32774 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882Ab0FPNwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:52:05 -0400
Date: Wed, 16 Jun 2010 08:51:44 -0500
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: Martin Wilck <martin.wilck@ts.fujitsu.com>,
       Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [PATCH] IPMI: Set schedule_timeout_wait value back to one
Message-id: <20100616135144.GA7548@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Wilck <martin.wilck@ts.fujitsu.com>

Some systems were seeing CPU usage go up dramatically with the recent
changes to try to reduce timer usage in the IPMI driver.  This was
traced down to schedule_timeout_interruptible(1) being changed to
schedule_timeout_interruptbile(0).  Revert that change.

Reported-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Tested-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---

Index: linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
@@ -1018,7 +1018,7 @@ static int ipmi_thread(void *data)
 		else if (smi_result == SI_SM_IDLE)
 			schedule_timeout_interruptible(100);
 		else
-			schedule_timeout_interruptible(0);
+			schedule_timeout_interruptible(1);
 	}
 	return 0;
 }
