Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab2EKLAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:00:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:15075 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab2EKLAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:00:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98914178"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: [PATCH 1/3] testusb: fix a makefile bug in tools/usb
Thread-Topic: [PATCH 1/3] testusb: fix a makefile bug in tools/usb
Thread-Index: AQHNL1p+MUYABQOzqU+swDDDi1NjwZbEavIQ
Date: Fri, 11 May 2012 11:00:01 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A060D00@SHSMSX101.ccr.corp.intel.com>
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

For gcc, link options must behind of compiling options, else it could lead to "undefined reference ..." error since gcc cannot find specific library.

Signed-off-by: Du Changbin <changbinx.du@intel.com>
---
 tools/usb/Makefile |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/usb/Makefile b/tools/usb/Makefile index 396d6c4..acf2165 100644
--- a/tools/usb/Makefile
+++ b/tools/usb/Makefile
@@ -3,11 +3,12 @@
 CC = $(CROSS_COMPILE)gcc
 PTHREAD_LIBS = -lpthread
 WARNINGS = -Wall -Wextra
-CFLAGS = $(WARNINGS) -g $(PTHREAD_LIBS) -I../include
+CFLAGS = $(WARNINGS) -g -I../include
+LDFLAGS = $(PTHREAD_LIBS)
 
 all: testusb ffs-test
 %: %.c
-	$(CC) $(CFLAGS) -o $@ $^
+	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
 
 clean:
 	$(RM) testusb ffs-test
--
1.7.9.5

