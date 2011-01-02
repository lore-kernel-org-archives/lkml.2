Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1ABIHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:07:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:34425 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab1ABHWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:02 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Maxim Osipov <maxim.osipov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 046/260] USB: Fix kernel oops with g_ether and Windows
Date: Sun,  2 Jan 2011 02:15:42 -0500
Message-Id: <1293952756-15010-47-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:56.0288 (UTC) FILETIME=[98CBAE00:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Osipov <maxim.osipov@gmail.com>

commit 037d3656adbd7e8cb848f01cf5dec423ed76bbe7 upstream.

Please find attached patch for
https://bugzilla.kernel.org/show_bug.cgi?id=16023 problem.

Signed-off-by: Maxim Osipov <maxim.osipov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/gadget/rndis.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
index 5c0d06c..1043da1 100644
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -292,9 +292,13 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	/* mandatory */
 	case OID_GEN_VENDOR_DESCRIPTION:
 		pr_debug("%s: OID_GEN_VENDOR_DESCRIPTION\n", __func__);
-		length = strlen (rndis_per_dev_params [configNr].vendorDescr);
-		memcpy (outbuf,
-			rndis_per_dev_params [configNr].vendorDescr, length);
+		if ( rndis_per_dev_params [configNr].vendorDescr ) {
+			length = strlen (rndis_per_dev_params [configNr].vendorDescr);
+			memcpy (outbuf,
+				rndis_per_dev_params [configNr].vendorDescr, length);
+		} else {
+			outbuf[0] = 0;
+		}
 		retval = 0;
 		break;
 
-- 
1.7.3.3

