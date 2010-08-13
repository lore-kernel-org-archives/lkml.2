Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761270Ab0HMA4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 20:56:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37502 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab0HMA4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 20:56:05 -0400
Date: Fri, 13 Aug 2010 10:56:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Subject: linux-next: build failure after merge of the acpi tree
Message-Id: <20100813105602.a6daf552.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

After merging the acpi tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/acpi/debugfs.c: In function 'cm_write':
drivers/acpi/debugfs.c:36: error: implicit declaration of function 'copy_from_user'

Caused by commit c0b82d427637c7598af5d7926187a7781c03bce8 ("ACPI:
introduce drivers/acpi/debugfs.c"), interacting with something that
stopped linux/uaccess.h from being implicitly included.  See Rule 1 in
Documentation/SubmitChecklist.

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 13 Aug 2010 10:52:30 +1000
Subject: [PATCH] acpi: using copy_from_user needs linux/uaccess.h

fixes this build error:

drivers/acpi/debugfs.c: In function 'cm_write':
drivers/acpi/debugfs.c:36: error: implicit declaration of function 'copy_from_user'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/acpi/debugfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/debugfs.c b/drivers/acpi/debugfs.c
index f0cd0e7..4f19078 100644
--- a/drivers/acpi/debugfs.c
+++ b/drivers/acpi/debugfs.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/debugfs.h>
+#include <linux/uaccess.h>
 #include <acpi/acpi_drivers.h>
 
 #define _COMPONENT		ACPI_SYSTEM_COMPONENT
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
