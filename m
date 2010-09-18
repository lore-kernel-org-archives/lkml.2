Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0IRTB7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:01:59 -0400
Received: from kroah.org ([198.145.64.141]:51175 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab0IRTBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:21 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:54 2010
Message-Id: <20100918185954.541067959@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maxim Osipov <maxim.osipov@gmail.com>
Subject: [020/123] USB: Fix kernel oops with g_ether and Windows
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=usb-fix-kernel-oops-with-g_ether-and-windows.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Osipov <maxim.osipov@gmail.com>

commit 037d3656adbd7e8cb848f01cf5dec423ed76bbe7 upstream.

Please find attached patch for
https://bugzilla.kernel.org/show_bug.cgi?id=16023 problem.


Signed-off-by: Maxim Osipov <maxim.osipov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/rndis.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -291,9 +291,13 @@ gen_ndis_query_resp (int configNr, u32 O
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
 


