Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab2JAX0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:26:11 -0400
Received: from 1wt.eu ([62.212.114.60]:35295 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820Ab2JAXBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:06 -0400
Message-Id: <20121001225201.376690206@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: James Bottomley <JBottomley@Parallels.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 089/180] SCSI: fix scsi_wait_scan
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/scsi/scsi_wait_scan.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_wait_scan.c b/drivers/scsi/scsi_wait_scan.c
index 74708fc..5c22bda 100644
--- a/drivers/scsi/scsi_wait_scan.c
+++ b/drivers/scsi/scsi_wait_scan.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <scsi/scsi_scan.h>
+#include "scsi_priv.h"
 
 static int __init wait_scan_init(void)
 {
-- 
1.7.2.1.45.g54fbc



