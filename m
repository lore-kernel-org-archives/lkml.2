Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab2AQVOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 16:14:11 -0500
Received: from mx2.parallels.com ([64.131.90.16]:44376 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631Ab2AQVOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 16:14:10 -0500
From: James Bottomley <jbottomley@parallels.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <greg@kroah.com>
CC: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Fix compile breakage with kref.h
Thread-Topic: Fix compile breakage with kref.h
Thread-Index: AQHM1VzxLNCfI82BwEKdqe1+VaxU0w==
Date: Tue, 17 Jan 2012 21:14:05 +0000
Message-ID: <1326834845.3020.36.camel@dabdike>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [194.186.187.194]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E0DB16776AF8B479083D49B9B5E685D@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0HLEF7C020244

This set of build failures just started appearing on parisc:

In file included from drivers/input/serio/serio_raw.c:12:
include/linux/kref.h: In function 'kref_get':
include/linux/kref.h:40: error: 'TAINT_WARN' undeclared (first use in this function)
include/linux/kref.h:40: error: (Each undeclared identifier is reported only once
include/linux/kref.h:40: error: for each function it appears in.)
include/linux/kref.h: In function 'kref_sub':
include/linux/kref.h:65: error: 'TAINT_WARN' undeclared (first use in this function)

It happens because TAINT_WARN is defined in kernel.h and this particular
compile doesn't seem to include it (no idea why it's just
manifesting ... probably some #include file untangling exposed it).  Fix
by adding #include <linux/kernel.h> to linux/kref.h

Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---

diff --git a/include/linux/kref.h b/include/linux/kref.h
index abc0120..9c07dce 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -17,6 +17,7 @@
 
 #include <linux/bug.h>
 #include <linux/atomic.h>
+#include <linux/kernel.h>
 
 struct kref {
 	atomic_t refcount;

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
