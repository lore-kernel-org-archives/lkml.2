Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab2FGEPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:15:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab2FGEPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:15:12 -0400
Message-Id: <20120607040336.941708070@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:03:39 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, James Bottomley <JBottomley@Parallels.com>
Subject: [ 03/82] SCSI: fix scsi_wait_scan
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/scsi/scsi_wait_scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/scsi_wait_scan.c
+++ b/drivers/scsi/scsi_wait_scan.c
@@ -12,7 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/device.h>
-#include <scsi/scsi_scan.h>
+#include "scsi_priv.h"
 
 static int __init wait_scan_init(void)
 {


