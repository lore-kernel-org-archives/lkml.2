Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab1JRSI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:08:57 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51859 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab1JRSI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:08:56 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Oct 2011 14:08:56 EDT
Date: Tue, 18 Oct 2011 11:01:27 -0700
From: Kees Cook <kees@outflux.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Sergiu Iordache <sergiu@chromium.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH] ramoops: update parameters only after successful init
Message-ID: <20111018180126.GA20695@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a platform device exists on the system, but ramoops fails to attach to
it, the module parameters are overridden before ramoops can fall back and
try to use passed module parameters. Move update to end of init routine.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/char/ramoops.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 810aff9..0ec4bb3 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -147,14 +147,6 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
 	cxt->dump_oops = pdata->dump_oops;
-	/*
-	 * Update the module parameter variables as well so they are visible
-	 * through /sys/module/ramoops/parameters/
-	 */
-	mem_size = pdata->mem_size;
-	mem_address = pdata->mem_address;
-	record_size = pdata->record_size;
-	dump_oops = pdata->dump_oops;
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
 		pr_err("request mem region failed\n");
@@ -175,6 +167,15 @@ static int __init ramoops_probe(struct platform_device *pdev)
 		goto fail1;
 	}
 
+	/*
+	 * Update the module parameter variables as well so they are visible
+	 * through /sys/module/ramoops/parameters/
+	 */
+	mem_size = pdata->mem_size;
+	mem_address = pdata->mem_address;
+	record_size = pdata->record_size;
+	dump_oops = pdata->dump_oops;
+
 	return 0;
 
 fail1:
-- 
1.7.5.4


-- 
Kees Cook                                            @outflux.net
