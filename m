Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574Ab2EVBcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:32:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:41058 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab2EVBcM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:32:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102646569"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>
CC: "'Sergei Shtylyov'" <sshtylyov@mvista.com>,
        "'mina86@mina86.com'" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "'balbi@ti.com'" <balbi@ti.com>, "'hpa@zytor.com'" <hpa@zytor.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-usb@vger.kernel.org'" <linux-usb@vger.kernel.org>
Subject: [Resend PATCH v2] testusb: add path /dev/bus/usb to default search
 paths of usbfs
Thread-Topic: [Resend PATCH v2] testusb: add path /dev/bus/usb to default
 search paths of usbfs
Thread-Index: AQHNN7qyG7Zv5VtpIkaxHOeRBAtVMw==
Date: Tue, 22 May 2012 01:32:05 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A06388E@SHSMSX101.ccr.corp.intel.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A062E6C@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A062E6C@SHSMSX101.ccr.corp.intel.com>
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

As real device-nodes managed by udev whose nodes lived in /dev/bus/usb are mostly used today, let testusb tool use that directory as one default path make tool be more convenient to use.

Signed-off-by: Du Changbin <changbinx.du@intel.com>
---
 tools/usb/testusb.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c index 6e0f567..82d7c59 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -358,6 +358,7 @@ static const char *usbfs_dir_find(void)  {
 	static char usbfs_path_0[] = "/dev/usb/devices";
 	static char usbfs_path_1[] = "/proc/bus/usb/devices";
+	static char udev_usb_path[] = "/dev/bus/usb";
 
 	static char *const usbfs_paths[] = {
 		usbfs_path_0, usbfs_path_1
@@ -376,6 +377,10 @@ static const char *usbfs_dir_find(void)
 		}
 	} while (++it != end);
 
+	/* real device-nodes managed by udev */
+	if (access(udev_usb_path, F_OK) == 0)
+		return udev_usb_path;
+
 	return NULL;
 }
 
--
1.7.9.5

