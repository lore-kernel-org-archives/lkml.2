Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988Ab2EWCnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:43:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:50778 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab2EWCnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:43:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="146555362"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: Michal Nazarewicz <mina86@mina86.com>,
        "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>
CC: "'David Rientjes'" <rientjes@google.com>,
        "'Sergei Shtylyov'" <sshtylyov@mvista.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "'balbi@ti.com'" <balbi@ti.com>, "'hpa@zytor.com'" <hpa@zytor.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-usb@vger.kernel.org'" <linux-usb@vger.kernel.org>
Subject: [PATCH v2] testusb: expose looping forever option "l" to user
Thread-Topic: [PATCH v2] testusb: expose looping forever option "l" to user
Thread-Index: AQHNOI3HlZBaw4PBIUqH35T9UAv+PQ==
Date: Wed, 23 May 2012 02:43:05 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A063D03@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The testusb.c tool has support for looping forever implemented, which
may be useful for stress test, yet it is not exposed to the user, so
even though the code is there, it cannot be used.  This commit adds
"l" to the set of options handled by the application which enables
the feature.

Also, I collate help information for each command line option to make
it easier to use for novice.

Signed-off-by: Du Changbin <changbinx.du@intel.com>
---
 tools/usb/testusb.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c
index 0aac3ff..7a7adf3 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -422,7 +422,7 @@ int main (int argc, char **argv)
 	/* for easy use when hotplugging */
 	device = getenv ("DEVICE");
 
-	while ((c = getopt (argc, argv, "D:aA:c:g:hns:t:v:")) != EOF)
+	while ((c = getopt (argc, argv, "D:aA:c:g:hlns:t:v:")) != EOF)
 	switch (c) {
 	case 'D':	/* device, if only one */
 		device = optarg;
@@ -465,10 +465,21 @@ int main (int argc, char **argv)
 	case 'h':
 	default:
 usage:
-		fprintf (stderr, "usage: %s [-n] [-D dev | -a | -A usbfs-dir]\n"
-			"\t[-c iterations]  [-t testnum]\n"
-			"\t[-s packetsize] [-g sglen] [-v vary]\n",
-			argv [0]);
+		fprintf (stderr,
+			"usage: %s [options]\n"
+			"Options:\n"
+			"\t-D dev		only test specific device\n"
+			"\t-A usbfs-dir\n"
+			"\t-a		test all recognized devices\n"
+			"\t-l		loop forever(for stress test)\n"
+			"\t-t testnum	only run specified case\n"
+			"\t-n		no test running, show devices to be tested\n"
+			"Case arguments:\n"
+			"\t-c iterations	default 1000\n"
+			"\t-s packetsize	default 512\n"
+			"\t-g sglen	default 32\n"
+			"\t-v vary		default 512\n",
+			argv[0]);
 		return 1;
 	}
 	if (optind != argc)
-- 
1.7.9.5

