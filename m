Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab2GCKpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:45:40 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42386 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2GCKpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:45:38 -0400
Date: Tue, 3 Jul 2012 13:45:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] printk: remove some dead code
Message-ID: <20120703104511.GA29501@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static checkers complain about the impossible condition here.

In 084681d14e ('printk: flush continuation lines immediately to
console'), we changed msg->level from being a u16 to being an unsigned
3 bit bitfield.  That means we can remove the code here to handle log
levels which are in the tens or hundreds column.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/printk.c b/kernel/printk.c
index 660ba72..3edc531 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -822,15 +822,10 @@ static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 	size_t len = 0;
 
 	if (syslog) {
-		if (buf) {
+		if (buf)
 			len += sprintf(buf, "<%u>", msg->level);
-		} else {
+		else
 			len += 3;
-			if (msg->level > 9)
-				len++;
-			if (msg->level > 99)
-				len++;
-		}
 	}
 
 	len += print_time(msg->ts_nsec, buf ? buf + len : NULL);
