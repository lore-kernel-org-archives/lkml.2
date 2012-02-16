Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2BPQF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:05:58 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:62477 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab2BPQF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:05:57 -0500
Date: Thu, 16 Feb 2012 17:05:25 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com
Subject: [PATCH] ARM: amba: don't include <asm/sizes.h>
Message-ID: <20120216160525.GA30558@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file uses no SZ_* symbol and some architectures miss sizes.h

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---

There a number of files including but not using it. This one
in particular I need under x86 so the fix is trivial.

However, I remember different feelings about sizes.h . Should it die
or should it proliferate to other archs using asm-generic/sizes.h ?


 drivers/amba/bus.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 01c2cf4..928f80f 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -18,7 +18,6 @@
 #include <linux/amba/bus.h>
 
 #include <asm/irq.h>
-#include <asm/sizes.h>
 
 #define to_amba_driver(d)	container_of(d, struct amba_driver, drv)
 
-- 
1.7.7.2
