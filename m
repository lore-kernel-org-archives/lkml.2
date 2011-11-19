Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1KSJUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 04:20:33 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:45901 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1KSJUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 04:20:31 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM / Suspend: Fix bug in suspend statistics update
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, shuox.liu@intel.com
Date: Sat, 19 Nov 2011 14:50:26 +0530
Message-ID: <20111119092019.27505.77215.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11111909-9574-0000-0000-00000038ED57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pair of missing braces inside the state_store() function causes even
invalid arguments to suspend to be wrongly treated as failed suspend
attempts. Fix this.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/power/main.c b/kernel/power/main.c
index 71f49fe..36e0f09 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -290,13 +290,14 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
 			break;
 	}
-	if (state < PM_SUSPEND_MAX && *s)
+	if (state < PM_SUSPEND_MAX && *s) {
 		error = enter_state(state);
 		if (error) {
 			suspend_stats.fail++;
 			dpm_save_failed_errno(error);
 		} else
 			suspend_stats.success++;
+	}
 #endif
 
  Exit:

