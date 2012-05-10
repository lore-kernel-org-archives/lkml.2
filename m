Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073Ab2EJVMC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:12:02 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:47564 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758055Ab2EJVJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:09:54 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-parisc@vger.kernel.org
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Subject: [PATCH 3/5] parisc: drop include of asm/pdc.h from asm/hardware.h
Date: Thu, 10 May 2012 23:03:26 +0200
Message-ID: <5611809.8T3vflHrKr@donald.sf-tec.de>
User-Agent: KMail/4.8.3 (Linux/3.2.9-13-desktop; KDE/4.8.3; i686; ; )
In-Reply-To: <4430485.xEvkeJU8MB@donald.sf-tec.de>
References: <4430485.xEvkeJU8MB@donald.sf-tec.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
/home/buildbot/repos/linux/arch/parisc/include/asm/processor.h:74:16: error: field ‘cpu_type’ has incomplete type
/home/buildbot/repos/linux/arch/parisc/include/asm/processor.h:77:20: error: field ‘model’ has incomplete type
/home/buildbot/repos/linux/arch/parisc/include/asm/processor.h: In function ‘parisc_requires_coherency’:
/home/buildbot/repos/linux/arch/parisc/include/asm/processor.h:349:36: error: ‘mako’ undeclared (first use in this function)
/home/buildbot/repos/linux/arch/parisc/include/asm/processor.h:349:36: note: each undeclared identifier is reported only once for each function it appears in
/home/buildbot/repos/linux/arch/parisc/include/asm/processor.h:350:30: error: ‘mako2’ undeclared (first use in this function)

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Acked-by: Grant Grundler <grantgrundler@gmail.com>
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
-- 
1.7.9.2


