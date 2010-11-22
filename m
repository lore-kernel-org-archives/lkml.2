Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab0KVUNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 15:13:42 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:17186 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab0KVUNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 15:13:41 -0500
Date: Mon, 22 Nov 2010 12:12:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: werner <w.landgraf@ru.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: easycap needs  smp_lock.h, fixes build error
Message-Id: <20101122121237.38cdd369.randy.dunlap@oracle.com>
In-Reply-To: <20101122194736.GA29830@kroah.com>
References: <web-407197955@zbackend1.aha.ru>
	<20101122043520.GA10958@kroah.com>
	<20101121205626.4589e544.randy.dunlap@oracle.com>
	<20101121211311.05963007.randy.dunlap@oracle.com>
	<20101122194736.GA29830@kroah.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add header file to fix build error:

drivers/staging/easycap/easycap_main.c:4251: error: implicit declaration of function 'lock_kernel'
drivers/staging/easycap/easycap_main.c:4254: error: implicit declaration of function 'unlock_kernel'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/easycap/easycap.h |    1 +
 1 file changed, 1 insertion(+)

--- lnx-2637-rc3.orig/drivers/staging/easycap/easycap.h
+++ lnx-2637-rc3/drivers/staging/easycap/easycap.h
@@ -75,6 +75,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/kref.h>
 #include <linux/usb.h>
