Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab2ENGvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 02:51:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:50758 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab2ENGv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 02:51:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99709118"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: [PATCH] testusb: add path /dev/bus/usb to default search paths for
 usbfs
Thread-Topic: [PATCH] testusb: add path /dev/bus/usb to default search paths
 for usbfs
Thread-Index: AQHNMZ2BooD2tGJJHE+2JranocONc5bI1+TQ
Date: Mon, 14 May 2012 06:51:23 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A062C91@SHSMSX101.ccr.corp.intel.com>
References: <1337021163-1487-1-git-send-email-changbinx.du@intel.com>
In-Reply-To: <1337021163-1487-1-git-send-email-changbinx.du@intel.com>
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
 tools/usb/testusb.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c
index 6e0f567..c6c839e 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -358,6 +358,7 @@ static const char *usbfs_dir_find(void)
 {
 	static char usbfs_path_0[] = "/dev/usb/devices";
 	static char usbfs_path_1[] = "/proc/bus/usb/devices";
+	static char udev_usb_path[] = "/dev/bus/usb";
 
 	static char *const usbfs_paths[] = {
 		usbfs_path_0, usbfs_path_1
@@ -376,6 +377,11 @@ static const char *usbfs_dir_find(void)
 		}
 	} while (++it != end);
 
+	/* real device-nodes managed by udev */
+	if (access(udev_usb_path, F_OK) == 0) {
+		return udev_usb_path;
+	}
+
 	return NULL;
 }
 
-- 
1.7.9.5

