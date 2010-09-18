Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab0IRTeW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:34:22 -0400
Received: from kroah.org ([198.145.64.141]:43349 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752Ab0IRTPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:05 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:00 2010
Message-Id: <20100918191300.643204850@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maxim Osipov <maxim.osipov@gmail.com>
Subject: [039/129] USB: Fix kernel oops with g_ether and Windows
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
@@ -292,9 +292,13 @@ gen_ndis_query_resp (int configNr, u32 O
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
 


