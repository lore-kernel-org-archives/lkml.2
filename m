Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab2KFWZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:25:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42041 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab2KFWZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:25:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] xen/generic: Disable fallback build on ARM.
Date: Tue,  6 Nov 2012 17:13:01 -0500
Message-Id: <1352239982-17389-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352239982-17389-1-git-send-email-konrad.wilk@oracle.com>
References: <1352239982-17389-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As there is no need for it (the fallback code is for older
hypervisors and they won't run under ARM), and also b/c
we get:

drivers/xen/fallback.c: In function 'xen_event_channel_op_compat':
drivers/xen/fallback.c:10:19: error: storage size of 'op' isn't known
drivers/xen/fallback.c:15:2: error: implicit declaration of function '_hypercall1' [-Werror=implicit-function-declaration]
drivers/xen/fallback.c:15:19: error: expected expression before 'int'
drivers/xen/fallback.c:18:7: error: 'EVTCHNOP_close' undeclared (first use in this function)
drivers/xen/fallback.c:18:7: note: each undeclared identifier is reported only once for each function it appears in
.. and more

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 46de6cd..273d2b9 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,8 +1,8 @@
 ifneq ($(CONFIG_ARM),y)
-obj-y	+= manage.o balloon.o
+obj-y	+= manage.o balloon.o fallback.o
 obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
 endif
-obj-y	+= grant-table.o features.o events.o fallback.o
+obj-y	+= grant-table.o features.o events.o
 obj-y	+= xenbus/
 
 nostackp := $(call cc-option, -fno-stack-protector)
-- 
1.7.7.6

