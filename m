Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2KFWZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:25:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42043 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2KFWZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:25:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/arm: Fix compile errors when drivers are compiled as modules.
Date: Tue,  6 Nov 2012 17:13:02 -0500
Message-Id: <1352239982-17389-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352239982-17389-1-git-send-email-konrad.wilk@oracle.com>
References: <1352239982-17389-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We end up with:

ERROR: "HYPERVISOR_event_channel_op" [drivers/xen/xen-gntdev.ko] undefined!
ERROR: "privcmd_call" [drivers/xen/xen-privcmd.ko] undefined!
ERROR: "HYPERVISOR_grant_table_op" [drivers/net/xen-netback/xen-netback.ko] undefined!

and this patch exports said function (which is implemented in hypercall.S).

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/arm/xen/enlighten.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 59bcb96..96d969d 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -166,3 +166,8 @@ void free_xenballooned_pages(int nr_pages, struct page **pages)
 	*pages = NULL;
 }
 EXPORT_SYMBOL_GPL(free_xenballooned_pages);
+
+/* In the hypervisor.S file. */
+EXPORT_SYMBOL_GPL(HYPERVISOR_event_channel_op);
+EXPORT_SYMBOL_GPL(HYPERVISOR_grant_table_op);
+EXPORT_SYMBOL_GPL(privcmd_call);
-- 
1.7.7.6

