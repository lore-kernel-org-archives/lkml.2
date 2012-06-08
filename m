Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485Ab2FHFH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:07:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43125 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759707Ab2FHFHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:10 -0400
Message-Id: <20120608041845.280015309@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, James Bottomley <jbottomley@parallels.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: [ 33/82] [SCSI] fix scsi_wait_scan
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <jbottomley@parallels.com>

commit 1ff2f40305772b159a91c19590ee159d3a504afc upstream.

Commit  c751085943362143f84346d274e0011419c84202
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sun Apr 12 20:06:56 2009 +0200

    PM/Hibernate: Wait for SCSI devices scan to complete during resume

Broke the scsi_wait_scan module in 2.6.30.  Apparently debian still uses it so
fix it and backport to stable before removing it in 3.6.

The breakage is caused because the function template in
include/scsi/scsi_scan.h is defined to be a nop unless SCSI is built in.
That means that in the modular case (which is every distro), the
scsi_wait_scan module does a simple async_synchronize_full() instead of
waiting for scans.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_wait_scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_wait_scan.c b/drivers/scsi/scsi_wait_scan.c
index 74708fc..ae78148 100644
--- a/drivers/scsi/scsi_wait_scan.c
+++ b/drivers/scsi/scsi_wait_scan.c
@@ -12,7 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/device.h>
-#include <scsi/scsi_scan.h>
+#include "scsi_priv.h"
 
 static int __init wait_scan_init(void)
 {


