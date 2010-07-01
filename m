Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0GACPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 22:15:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38356 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab0GACPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 22:15:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SNiA1CxSkew3zKmtA7G/wGXlHM+vPdtKmH2EcFnUZLfQy5TlIeltRqC1du2nnVW3+c
         BQbzkfXn1xLSs+ftp1hZCby1e69c7yAC37ldnP315a2/NLLszqzJ0eX+aZGKnQlGEwy4
         lUzbklTg+Mz9N72thqUqqJnwsRTXDjkqVPy2o=
Subject: [PATCH] sony-laptop: use platform_device_unregister in
	sony_pf_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>,
       Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, Andi Kleen <ak@linux.intel.com>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Thu, 01 Jul 2010 10:18:01 +0800
Message-Id: <1277950681.30073.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_device_unregister calls platform_device_del and platform_device_put,
thus this change is logically equivalent to original code.

I made this change because the documents in platform.c shows that:
platform_device_del and platform_device_put must _only_ be externally called
in error cases.  All other usage is a bug.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/sony-laptop.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 1387c5f..6b7ea49 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -561,8 +561,7 @@ static void sony_pf_remove(void)
 	if (!atomic_dec_and_test(&sony_pf_users))
 		return;
 
-	platform_device_del(sony_pf_device);
-	platform_device_put(sony_pf_device);
+	platform_device_unregister(sony_pf_device);
 	platform_driver_unregister(&sony_pf_driver);
 }
 
-- 
1.5.4.3



