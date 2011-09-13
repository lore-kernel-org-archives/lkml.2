Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab1IMQUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:20:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52296 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab1IMQUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:20:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6467"; a="118226954"
Date: Tue, 13 Sep 2011 11:20:23 -0500
From: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Janitor: Typo in stack debug code
Message-ID: <20110913162023.GA23759@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the debug routine check_stack_usage(), free stack space is counted
in units of (unsigned long), not bytes.  Make this clear when printing.

It seems easiest to just change the message, instead of multiplying
by sizeof(unsigned long).

Signed-off-by: Linas Vepstas <linas@codeaurora.org>

---

===================================================================
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -888,7 +888,7 @@ static void check_stack_usage(void)
 
 	spin_lock(&low_water_lock);
 	if (free < lowest_to_date) {
-		printk(KERN_WARNING "%s used greatest stack depth: %lu bytes "
+		printk(KERN_WARNING "%s used greatest stack depth: %lu words "
 				"left\n",
 				current->comm, free);
 		lowest_to_date = free;




-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
