Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab0ECNiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:38:55 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:60243 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab0ECNiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:38:54 -0400
Date: Mon, 03 May 2010 08:38:35 -0500
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 8/8] ipmi: Change timeout and event poll to one second
Message-id: <20100503133835.GH8130@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

The timeouts in IPMI are in the 1-5 second range in message handling,
so a 1 second timeout is a reasonable thing to do.  This should help
with reducing power consumption on idle systems.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---

Index: linux-2.6/drivers/char/ipmi/ipmi_msghandler.c
===================================================================
--- linux-2.6.orig/drivers/char/ipmi/ipmi_msghandler.c
+++ linux-2.6/drivers/char/ipmi/ipmi_msghandler.c
@@ -4037,8 +4037,8 @@ static void ipmi_request_event(void)
 
 static struct timer_list ipmi_timer;
 
-/* Call every ~100 ms. */
-#define IPMI_TIMEOUT_TIME	100
+/* Call every ~1000 ms. */
+#define IPMI_TIMEOUT_TIME	1000
 
 /* How many jiffies does it take to get to the timeout time. */
 #define IPMI_TIMEOUT_JIFFIES	((IPMI_TIMEOUT_TIME * HZ) / 1000)
