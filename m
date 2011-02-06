Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1BFRNm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 12:13:42 -0500
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:54780 "EHLO
	homiemail-a5.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753200Ab1BFRNl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 12:13:41 -0500
Subject: [PATCH v2 1/2] USB: ffs-test: fix header path
From: Davidlohr Bueso <dave@gnu.org>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Feb 2011 14:13:33 -0300
Message-ID: <1297012413.2039.8.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

When compiling this program the functionfs.h header cannot be found, producing:
ffs-test.c:40: fatal error: linux/usb/functionfs.h: No such file or directory

This patch also fixes the following warning:
ffs-test.c:453: warning: format ‘%4d’ expects type ‘int’, but argument 3 has type ‘size_t’

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 tools/usb/ffs-test.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index bbe2e3a..f2c6524 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -37,7 +37,7 @@
 #include <sys/types.h>
 #include <unistd.h>
 
-#include <linux/usb/functionfs.h>
+#include "../../include/linux/usb/functionfs.h"
 

 /******************** Little Endian Handling ********************************/
@@ -450,7 +450,7 @@ invalid:
 		    len, expected, *p);
 		for (p = buf, len = 0; len < nbytes; ++p, ++len) {
 			if (0 == (len % 32))
-				fprintf(stderr, "%4d:", len);
+				fprintf(stderr, "%4zd", len);
 			fprintf(stderr, " %02x", *p);
 			if (31 == (len % 32))
 				fprintf(stderr, "\n");
-- 
1.7.1






