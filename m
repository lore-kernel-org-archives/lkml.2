Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0H3DwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 23:52:11 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:59997 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab0H3DwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 23:52:10 -0400
Date: Sun, 29 Aug 2010 23:53:52 -0400
From: Andres Salomon <dilinger@queued.net>
To: devicetree-discuss@lists.ozlabs.org
Cc: sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, cjb@laptop.org,
        Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        grant.likely@secretlab.ca,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: [PATCH 1/9] of: move phandle/ihandle into types.h
Message-ID: <20100829235352.1744e7e3@debxo>
In-Reply-To: <20100829235100.6dcedcb8@debxo>
References: <20100628215407.2017bf2f@debian>
	<20100829235100.6dcedcb8@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We need phandle for some exported sparc headers; of.h isn't an
exported header, and it would be silly to export it when all we
really need is one or two types from it.  So, move the phandle/ihandle
definitions into types.h.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 include/linux/of.h    |    3 ---
 include/linux/types.h |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

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
index 01a082f..26526ea 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -219,6 +219,10 @@ struct ustat {
 	char			f_fpack[6];
 };
 
+/* Basic openboot/openfirmware types */
+typedef u32 phandle;
+typedef u32 ihandle;
+
 #endif	/* __KERNEL__ */
 #endif /*  __ASSEMBLY__ */
 #endif /* _LINUX_TYPES_H */
-- 
1.5.6.5

