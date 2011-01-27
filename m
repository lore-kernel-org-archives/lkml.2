Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1A0Tjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:39:37 -0500
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:58101 "EHLO
	homiemail-a37.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751648Ab1A0Tjg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:39:36 -0500
Subject: [PATCH 1/2] USB: ffs-test: fix header path
From: Davidlohr Bueso <dave@gnu.org>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 16:39:28 -0300
Message-ID: <1296157168.2113.5.camel@offworld>
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
index bbe2e3a..b5a4430 100644
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
+				fprintf(stderr, "%4ld:", len);
 			fprintf(stderr, " %02x", *p);
 			if (31 == (len % 32))
 				fprintf(stderr, "\n");
-- 
1.7.1




