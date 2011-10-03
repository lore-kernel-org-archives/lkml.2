Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1JCMCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 08:02:20 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:63285 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab1JCMCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 08:02:15 -0400
X-IronPort-AV: E=Sophos;i="4.68,479,1312156800"; 
   d="scan'208";a="8178408"
Subject: [PATCH] stop_machine: fixup cut'n'paste error in stopped thread name
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC: <linux-kernel@vger.kernel.org>
Date: Mon, 3 Oct 2011 13:01:56 +0100
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317643317.21903.36.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed this while poking around. Seems like the code was lifted a bit
more thoroughly from the migration thread mgmt code than the author of
the preceding comment intended...

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -312,7 +312,7 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 		p = kthread_create_on_node(cpu_stopper_thread,
 					   stopper,
 					   cpu_to_node(cpu),
-					   "migration/%d", cpu);
+					   "stopper/%d", cpu);
 		if (IS_ERR(p))
 			return notifier_from_errno(PTR_ERR(p));
 		get_task_struct(p);


