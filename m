Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab2JEUok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:44:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58138 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687Ab2JEUoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:44:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH] stagin/dgrp: include linux/uaccess.h where necessary
Date: Fri, 5 Oct 2012 20:44:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210052044.35187.arnd@arndb.de>
X-Provags-ID: V02:K0:WDtcu47uFY/E02wP5844qjx3iQSaVhNQ7nEm2HmisON
 SR1losIHcPw7ci+dUi6OsV8+0ylgUI2hyjLRJ3/qHwdsD5y1/N
 MqxqPPKQHRahq/z/PPiWHFtwaen1qfCUI/6mz+5s+l7zNVPCj2
 BiRtOGZZLFlpLKCfz5gtCXyu2kfC87nEcExtR+ul7yP4WUpX/5
 pyUgWlzoVYqUaQ1/FvPQgO5B9YYIbTdBOLSqQ0Hk8G+jisL39H
 3sV0qmPWnUy4WkmVA57IvA1tX136bHtl9yAC9Vo87LOOBvr+q1
 D0xXoBKoozI9cIphLwl/l1BLt+jyygSjXjTxNXWkSJAZ4BhBl5
 VHgLuWfO88JqBudhNdJQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation of the dgrp driver fails on ARM because uaccess.h
is not included implicitly in three files that need it.
Add an explicit #include statement to fix that.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/dgrp/dgrp_mon_ops.c b/drivers/staging/dgrp/dgrp_mon_ops.c
index 268dcb9..4792d05 100644
--- a/drivers/staging/dgrp/dgrp_mon_ops.c
+++ b/drivers/staging/dgrp/dgrp_mon_ops.c
@@ -38,6 +38,7 @@
 #include <linux/sched.h>
 #include <asm/unaligned.h>
 #include <linux/proc_fs.h>
+#include <linux/uaccess.h>
 
 #include "dgrp_common.h"
 
diff --git a/drivers/staging/dgrp/dgrp_specproc.c b/drivers/staging/dgrp/dgrp_specproc.c
index 28f5c9a..b9b3fc5 100644
--- a/drivers/staging/dgrp/dgrp_specproc.c
+++ b/drivers/staging/dgrp/dgrp_specproc.c
@@ -40,6 +40,7 @@
 #include <linux/ctype.h>
 #include <linux/seq_file.h>
 #include <linux/vmalloc.h>
+#include <linux/uaccess.h>
 
 #include "dgrp_common.h"
 
diff --git a/drivers/staging/dgrp/dgrp_tty.c b/drivers/staging/dgrp/dgrp_tty.c
index 7d7de87..72f6fcf 100644
--- a/drivers/staging/dgrp/dgrp_tty.c
+++ b/drivers/staging/dgrp/dgrp_tty.c
@@ -40,6 +40,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/sched.h>
+#include <linux/uaccess.h>
 
 #include "dgrp_common.h"
 
