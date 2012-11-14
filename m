Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423340Ab2KNS6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:58:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18628 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423286Ab2KNS5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:57:46 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: sjenning@linux.vnet.ibm.com, dan.magenheimer@oracle.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, minchan@kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de
Cc: fschmaus@gmail.com, andor.daam@googlemail.com, ilendir@googlemail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 8/8] xen/tmem: Remove the subsys call.
Date: Wed, 14 Nov 2012 13:57:12 -0500
Message-Id: <1352919432-9699-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352919432-9699-1-git-send-email-konrad.wilk@oracle.com>
References: <1352919432-9699-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We get:
drivers/xen/xen-selfballoon.c:577:134: warning: initialization from incompatible pointer type [enabled by default]

We actually do not need this function to be called
before tmem is loaded. So lets remove the subsys_init.

If tmem is built in as a module this is still OK as
xen_selfballoon_init ends up being exported and can
be called by the tmem module.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-selfballoon.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
index f4808aa..0bd551e 100644
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@ -572,7 +572,3 @@ int xen_selfballoon_init(bool use_selfballooning, bool use_frontswap_selfshrink)
 	return 0;
 }
 EXPORT_SYMBOL(xen_selfballoon_init);
-
-#ifndef CONFIG_XEN_TMEM_MODULE
-subsys_initcall(xen_selfballoon_init);
-#endif
-- 
1.7.7.6

