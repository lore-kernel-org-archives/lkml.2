Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1AFAyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:54:06 -0500
Received: from kroah.org ([198.145.64.141]:35642 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab1AFA3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:37 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:01 2011
Message-Id: <20110106002301.108161545@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [047/152] sparc64: Unexport prom_service_exists().
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit f7b5f55ac1623dfde24ef5319ad77c1746645f3f ]

Only used by functions in misc_64.c so make it private
to that file.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/oplib_64.h |    1 -
 arch/sparc/prom/misc_64.c         |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/arch/sparc/include/asm/oplib_64.h
+++ b/arch/sparc/include/asm/oplib_64.h
@@ -258,7 +258,6 @@ extern int prom_setprop(int node, const
 			int value_size);
 
 extern int prom_inst2pkg(int);
-extern int prom_service_exists(const char *service_name);
 extern void prom_sun4v_guest_soft_state(void);
 
 extern int prom_ihandle2path(int handle, char *buffer, int bufsize);
--- a/arch/sparc/prom/misc_64.c
+++ b/arch/sparc/prom/misc_64.c
@@ -18,7 +18,7 @@
 #include <asm/system.h>
 #include <asm/ldc.h>
 
-int prom_service_exists(const char *service_name)
+static int prom_service_exists(const char *service_name)
 {
 	unsigned long args[5];
 


