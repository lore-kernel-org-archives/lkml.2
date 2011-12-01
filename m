Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1LAPpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:45:10 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:43652 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab1LAPpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:45:08 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM / Hibernate: Enable usermodehelpers in software_resume()
 error path
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Thu, 01 Dec 2011 21:15:00 +0530
Message-ID: <20111201154453.25828.85233.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11120115-8878-0000-0000-0000006EDFCD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the software_resume() function defined in kernel/power/hibernate.c,
if the call to create_basic_memory_bitmaps() fails, the usermodehelpers
are not enabled (which had been disabled in the previous step). Fix it.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/hibernate.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index a6b0503..df35313 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -811,8 +811,10 @@ static int software_resume(void)
 		goto close_finish;
 
 	error = create_basic_memory_bitmaps();
-	if (error)
+	if (error) {
+		usermodehelper_enable();
 		goto close_finish;
+	}
 
 	pr_debug("PM: Preparing processes for restore.\n");
 	error = prepare_processes();

