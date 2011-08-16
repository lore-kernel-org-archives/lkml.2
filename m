Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab1HPElq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 00:41:46 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:54327 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750721Ab1HPElp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 00:41:45 -0400
Date: Mon, 15 Aug 2011 21:41:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3.1-rc2] xen: self-balloon needs module.h
Message-Id: <20110815214143.ed2fa458.rdunlap@xenotime.net>
In-Reply-To: <CA+55aFycTvbuNzdgbHjoiNkTeDpzgu6Yf=vx9DU+PDOtC_17zA@mail.gmail.com>
References: <CA+55aFycTvbuNzdgbHjoiNkTeDpzgu6Yf=vx9DU+PDOtC_17zA@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build errors (found when CONFIG_SYSFS is not enabled):

drivers/xen/xen-selfballoon.c:446: warning: data definition has no type or storage class
drivers/xen/xen-selfballoon.c:446: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
drivers/xen/xen-selfballoon.c:446: warning: parameter names (without types) in function declaration
drivers/xen/xen-selfballoon.c:485: error: expected declaration specifiers or '...' before string constant
drivers/xen/xen-selfballoon.c:485: warning: data definition has no type or storage class
drivers/xen/xen-selfballoon.c:485: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/xen/xen-selfballoon.c:485: warning: function declaration isn't a prototype

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/xen/xen-selfballoon.c |    1 +
 1 file changed, 1 insertion(+)

and will need <linux/export.h> when module.h is split up.

--- lnx-31-rc2.orig/drivers/xen/xen-selfballoon.c
+++ lnx-31-rc2/drivers/xen/xen-selfballoon.c
@@ -70,6 +70,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
+#include <linux/module.h>
 #include <linux/workqueue.h>
 #include <xen/balloon.h>
 #include <xen/tmem.h>
