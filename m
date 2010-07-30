Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab0G3R4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:56:36 -0400
Received: from kroah.org ([198.145.64.141]:58545 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759970Ab0G3Rzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:45 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:41 2010
Message-Id: <20100730175141.631228575@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Corey Minyard <cminyard@mvista.com>
Subject: [088/205] ipmi: set schedule_timeout_wait() value back to one
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Martin Wilck <martin.wilck@ts.fujitsu.com>

commit 8d1f66dc9b4f80a1441bc1c33efa98aca99e8813 upstream.

Fix a regression introduced by ae74e823cb7d ("ipmi: add parameter to limit
CPU usage in kipmid").

Some systems were seeing CPU usage go up dramatically with the recent
changes to try to reduce timer usage in the IPMI driver.  This was traced
down to schedule_timeout_interruptible(1) being changed to
schedule_timeout_interruptbile(0).  Revert that part of the change.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16147

Reported-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Tested-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/ipmi/ipmi_si_intf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1003,7 +1003,7 @@ static int ipmi_thread(void *data)
 		else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait)
 			schedule();
 		else
-			schedule_timeout_interruptible(0);
+			schedule_timeout_interruptible(1);
 	}
 	return 0;
 }


