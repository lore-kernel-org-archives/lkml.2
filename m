Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab2EIWRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:17:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932494Ab2EIWRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:17:49 -0400
Date: Wed, 9 May 2012 18:17:42 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: torvalds@linux-foundation.org
cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 3/5] PA-RISC: fix compile errors
In-Reply-To: <Pine.LNX.4.64.1205091816470.1272@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1205091817170.1272@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205091758310.1272@file.rdu.redhat.com>
 <Pine.LNX.4.64.1205091816470.1272@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

It seems none of the symbols defined by pdc.h is needed, but it introduces an
include loop causing compile errors:

In file included from /home/buildbot/repos/linux/arch/parisc/include/asm/spinlock.h:4:0,
                 from /home/buildbot/repos/linux/arch/parisc/include/asm/atomic.h:20,
                 from /home/buildbot/repos/linux/include/linux/atomic.h:4,
                 from /home/buildbot/repos/linux/arch/parisc/include/asm/bitops.h:56,
                 from /home/buildbot/repos/linux/include/linux/bitops.h:35,
                 from /home/buildbot/repos/linux/include/asm-generic/getorder.h:7,
                 from /home/buildbot/repos/linux/arch/parisc/include/asm/page.h:162,
                 from /home/buildbot/repos/linux/arch/parisc/include/asm/pdc.h:346,
                 from /home/buildbot/repos/linux/arch/parisc/include/asm/hardware.h:5,
                 from /home/buildbot/repos/linux/arch/parisc/kernel/hardware.c:30:
/home/buildbot/repos/linux/arch/parisc/include/asm/processor.h:74:16: error: field "cpu_type" has incomplete type
/home/buildbot/repos/linux/arch/parisc/include/asm/processor.h:77:20: error: field "model" has incomplete type
/home/buildbot/repos/linux/arch/parisc/include/asm/processor.h: In function "parisc_requires_coherency":
/home/buildbot/repos/linux/arch/parisc/include/asm/processor.h:349:36: error: "mako" undeclared (first use in this function)
/home/buildbot/repos/linux/arch/parisc/include/asm/processor.h:349:36: note: each undeclared identifier is reported only once for each function it appears in
/home/buildbot/repos/linux/arch/parisc/include/asm/processor.h:350:30: error: "mako2" undeclared (first use in this function)

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 arch/parisc/include/asm/hardware.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/parisc/include/asm/hardware.h b/arch/parisc/include/asm/hardware.h
index 036e703..d1d864b 100644
--- a/arch/parisc/include/asm/hardware.h
+++ b/arch/parisc/include/asm/hardware.h
@@ -2,7 +2,6 @@
 #define _PARISC_HARDWARE_H
 
 #include <linux/mod_devicetable.h>
-#include <asm/pdc.h>
 
 #define HWTYPE_ANY_ID		PA_HWTYPE_ANY_ID
 #define HVERSION_ANY_ID		PA_HVERSION_ANY_ID

