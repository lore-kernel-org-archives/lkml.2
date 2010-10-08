Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0JHHm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:42:57 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:33996 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610Ab0JHHm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:42:56 -0400
Date: Fri, 8 Oct 2010 00:43:54 -0700
From: Andres Salomon <dilinger@queued.net>
To: sparclinux@vger.kernel.org
Cc: davem@davemloft.net, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 1/2 v2] of: move phandle/ihandle into types.h and export to
 userspace
Message-ID: <20101008004354.13b5b254@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We need phandle for some exported sparc headers; of.h isn't an
exported header, and it would be silly to export it when all we
really need is one or two types from it.  Also, later patches
use phandle in structs that are exported to userspace, so export
a __kernel_phandle type.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 include/linux/of.h    |    3 ---
 include/linux/types.h |    7 +++++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index cad7cf0..db184dc 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -25,9 +25,6 @@
 
 #ifdef CONFIG_OF
 
-typedef u32 phandle;
-typedef u32 ihandle;
-
 struct property {
 	char	*name;
 	int	length;
diff --git a/include/linux/types.h b/include/linux/types.h
index 01a082f..67a034a 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -178,10 +178,17 @@ typedef __u64 __bitwise __be64;
 typedef __u16 __bitwise __sum16;
 typedef __u32 __bitwise __wsum;
 
+/* Basic openboot/openfirmware types */
+typedef __u32 __kernel_phandle;
+typedef __u32 __kernel_ihandle;
+
 #ifdef __KERNEL__
 typedef unsigned __bitwise__ gfp_t;
 typedef unsigned __bitwise__ fmode_t;
 
+typedef __kernel_phandle phandle;
+typedef __kernel_ihandle ihandle;
+
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
 typedef u64 phys_addr_t;
 #else
-- 
1.5.6.5

