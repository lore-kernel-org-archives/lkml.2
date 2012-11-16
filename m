Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab2KPG0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:26:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37771 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2KPG0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:26:48 -0500
Date: Fri, 16 Nov 2012 09:26:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tim Waugh <tim@cyberelk.net>, Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] paride: enable extra verbose debugging
Message-ID: <20121116062631.GA11771@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This debug settings here are:

	0 - Off
	1 - Some
	2 - Lots

The module_param() was incorrectly set to bool and later the variable
was updated to be bool to match.  Really they should both be int.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index 4a27b1d..ab99ac9 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -137,7 +137,7 @@
 
 */
 
-static bool verbose = 0;
+static int verbose;
 static int major = PG_MAJOR;
 static char *name = PG_NAME;
 static int disable = 0;
@@ -168,7 +168,7 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_SLV, D_DLY};
 
 #include <asm/uaccess.h>
 
-module_param(verbose, bool, 0644);
+module_param(verbose, int, 0644);
 module_param(major, int, 0);
 module_param(name, charp, 0);
 module_param_array(drive0, int, NULL, 0);
