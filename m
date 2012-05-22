Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab2EVGul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 02:50:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:41129 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab2EVGuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 02:50:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102740015"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        David Rientjes <rientjes@google.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: [PATCH v3] testusb: add path /dev/bus/usb to default search paths
 of usbfs
Thread-Topic: [PATCH v3] testusb: add path /dev/bus/usb to default search
 paths of usbfs
Thread-Index: AQHNN+cp9BusCFthtkWJbyjs7xMVXw==
Date: Tue, 22 May 2012 06:50:24 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A063A7C@SHSMSX101.ccr.corp.intel.com>
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

As real device-nodes managed by udev whose nodes lived in /dev/bus/usb
are mostly used today, let testusb tool use that directory as one default
path make tool be more convenient to use.

Signed-off-by: Du Changbin <changbinx.du@intel.com>
---
 tools/usb/testusb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c
index 6e0f567..0aac3ff 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -358,9 +358,11 @@ static const char *usbfs_dir_find(void)
 {
 	static char usbfs_path_0[] = "/dev/usb/devices";
 	static char usbfs_path_1[] = "/proc/bus/usb/devices";
+	/* real device-nodes managed by udev */
+	static char udev_usb_path[] = "/dev/bus/usb/";
 
 	static char *const usbfs_paths[] = {
-		usbfs_path_0, usbfs_path_1
+		usbfs_path_0, usbfs_path_1, udev_usb_path,
 	};
 
 	static char *const *
-- 
1.7.9.5

