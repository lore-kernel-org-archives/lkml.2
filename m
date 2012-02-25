Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2BYXz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 18:55:26 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38798 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2BYXzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 18:55:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jorgyano@gmail.com designates 10.236.157.9 as permitted sender) smtp.mail=jorgyano@gmail.com; dkim=pass header.i=jorgyano@gmail.com
Date: Sat, 25 Feb 2012 21:55:10 -0200
From: Jorgyano Vieira <jorgyano@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        jarod@wilsonet.com, nsankar@broadcom.com, joe@perches.com,
        dan.carpenter@oracle.com
Subject: [PATCH 1/2] Staging: crystalhd: Add global header
Message-ID: <20120225235510.GA22541@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the crystalhd_cmds.h there was a struct dependence bug:
the struct crystalhd_adp (which  is declared on crystalhd_lnx.h)
is used on  the crystalhd_cmd struct, however the crystalhd_lnx.h is
never included on crystalhd_cmds.h at all. Including the
crystalhd_lnx.h on crystalhd_cmds.h breaks the build,
many dependencies error occurrs, most of the type
"error: 'struct bar' has no member named 'foo'",
so I decided to reorganize the headers by adding a global header.

The gobal header crystalhd.h includes all the local headers.
The idea is that the crystalhd header will be the only included
by the others files, this will avoid the mess of many #include levels.

The order of the headers included by crystalhd.h considers the
dependencies among the headers.

Signed-off-by: Jorgyano Vieira <jorgyano@gmail.com>
---
 drivers/staging/crystalhd/crystalhd.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/crystalhd/crystalhd.h

diff --git a/drivers/staging/crystalhd/crystalhd.h b/drivers/staging/crystalhd/crystalhd.h
new file mode 100644
index 0000000..3f4d795
--- /dev/null
+++ b/drivers/staging/crystalhd/crystalhd.h
@@ -0,0 +1,14 @@
+#ifndef _CRYSTALHD_H_
+#define _CRYSTALHD_H_
+
+#include <asm/system.h>
+#include "bc_dts_defs.h"
+#include "crystalhd_misc.h"
+#include "bc_dts_glob_lnx.h"
+#include "crystalhd_hw.h"
+#include "crystalhd_cmds.h"
+#include "crystalhd_lnx.h"
+#include "bcm_70012_regs.h"
+#include "crystalhd_fw_if.h"
+
+#endif
-- 
1.7.2.5

