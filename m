Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0HCIdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:33:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43074 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab0HCIdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=VTwqWZyVLkY+RHcyMEdcDibQkDpp0BQaaRVISzIFOx+C+IdwWRvg1nxiEh6uNgBOLB
         31rA3qf7+C1e7Lx/F8+NAomvT+jsJjk8GBoMcmLQ6aTc4bzanPgKwA3Sh3Gb9h/GVSsm
         oGEphRlkituTV+kU6AK1N+uhwAiTiQfcqRMtg=
Subject: [PATCH] ucb1400_core: avoid calling platform_device_put() twice in
	ucb1400_core_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Marek Vasut <marek.vasut@gmail.com>
Content-Type: text/plain
Date: Tue, 03 Aug 2010 16:34:13 +0800
Message-Id: <1280824453.19576.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of goto err2, what we want is to call
platform_device_del() instead of platform_device_unregister().
Otherwise, we call platform_device_put() twice.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/ucb1400_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ucb1400_core.c b/drivers/mfd/ucb1400_core.c
index dbe2801..d73f84b 100644
--- a/drivers/mfd/ucb1400_core.c
+++ b/drivers/mfd/ucb1400_core.c
@@ -114,7 +114,7 @@ static int ucb1400_core_probe(struct device *dev)
 err3:
 	platform_device_put(ucb->ucb1400_ts);
 err2:
-	platform_device_unregister(ucb->ucb1400_gpio);
+	platform_device_del(ucb->ucb1400_gpio);
 err1:
 	platform_device_put(ucb->ucb1400_gpio);
 err0:
-- 
1.5.4.3



