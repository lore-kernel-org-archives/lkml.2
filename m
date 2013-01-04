Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3ADIar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 03:30:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16088 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3ADIap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 03:30:45 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fa66d0000004cf-8b-50e69333da87
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] vfs: fix build break in include/linux/namei.h
Date: Fri, 04 Jan 2013 09:30:26 +0100
Message-id: <1357288226-11365-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jAV3jyc8CDFq7dCz27D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDIurr/OXLCHveJNWytTA+Nyti5GTg4JAROJmQ8eskPY
	YhIX7q0HinNxCAksYpTY2zMXLMErICjxY/I9li5GDg5mAXmJI5eyQcLMAuoSk+YtYoaob2eS
	mLN0MthQNgFDia63XWwg9SIC9hK3F/tA1EdL3Fy9lBnEFhawk2hZeoIFxGYRUJX4MKuBEWKV
	h0T71T1grRICChJzJtlMYOSbheSIWQhHzEJyxAJG5lWMoqkFyQXFSem5hnrFibnFpXnpesn5
	uZsYwUH1TGoH48oGi0OMAhyMSjy8lneeBgixJpYVV+YeYpTgYFYS4f2s/SxAiDclsbIqtSg/
	vqg0J7X4EKM0B4uSOC/jqScBQgLpiSWp2ampBalFMFkmDk6pBkbh+dd+T08Mu18uENGqcCug
	+X/3f17OqAl3L+jH/WBL0Gv17BY//rm646zBSqH6UF0P9j2zPgidNtHk+Wj7YsbMiC/b4x58
	qfIqyZxRoRLLe7N4T8a0A1G7bhvr1bzvb7vz82+wStWl+s0HzFQ9e3/8Xd5+YlZuzx1piymv
	HvFFZfLW1rA3BCixFGckGmoxFxUnAgCW0bbRJgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build break which I've observed in v3.8-rc1:

In file included from fs/nfs/nfs4namespace.c:12:0:
include/linux/namei.h: In function ‘retry_estale’:
include/linux/namei.h:114:19: error: ‘ESTALE’ undeclared (first use in this function)
include/linux/namei.h:114:19: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [fs/nfs/nfs4namespace.o] Error 1
make[1]: *** [fs/nfs] Error 2
make: *** [fs] Error 2

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 include/linux/namei.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/namei.h b/include/linux/namei.h
index e998c03..5a5ff57 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -2,6 +2,7 @@
 #define _LINUX_NAMEI_H
 
 #include <linux/dcache.h>
+#include <linux/errno.h>
 #include <linux/linkage.h>
 #include <linux/path.h>
 
-- 
1.7.9.5

