Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab2ENDRs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 23:17:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:14994 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab2ENDRq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 23:17:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99657234"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>
CC: "'mina86@mina86.com'" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "'balbi@ti.com'" <balbi@ti.com>, "'hpa@zytor.com'" <hpa@zytor.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-usb@vger.kernel.org'" <linux-usb@vger.kernel.org>
Subject: [Resend PATCH] tools/usb: fix a makefile bug
Thread-Topic: [Resend PATCH] tools/usb: fix a makefile bug
Thread-Index: AQHNMYAf2yBasM9h+0OI1vzV8R3yDw==
Date: Mon, 14 May 2012 03:17:42 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A0629F2@SHSMSX101.ccr.corp.intel.com>
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

I try to compile tools/usb foler, but got below error(gcc version
4.6.3):
	tools/usb/testusb.c:516: undefined reference to `pthread_create'
	tools/usb/testusb.c:541: undefined reference to `pthread_join'
The reason is the makefile puts source files behind of compiler option
"-l". For gcc(and clang), it reads compiler options in order from left
to right. When compiler gets a source file, it starts parsing it and try
to resolve all symbols invoked. If compiler can not resolve a symbol, it
will read --remain-- options and try get a definition of the symbol. So,
if we put source file behind of "-l" option, the specified library will
not work.

Signed-off-by: Du Changbin <changbinx.du@intel.com>
---
 tools/usb/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/usb/Makefile b/tools/usb/Makefile
index 396d6c4..e1cfd19 100644
--- a/tools/usb/Makefile
+++ b/tools/usb/Makefile
@@ -7,7 +7,7 @@ CFLAGS = $(WARNINGS) -g $(PTHREAD_LIBS) -I../include
 
 all: testusb ffs-test
 %: %.c
-	$(CC) $(CFLAGS) -o $@ $^
+	$(CC) $^ $(CFLAGS) -o $@
 
 clean:
 	$(RM) testusb ffs-test
-- 
1.7.9.5

