Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab0KSRao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:30:44 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24774 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab0KSRam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:30:42 -0500
Date: Fri, 19 Nov 2010 09:30:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Pavel Machek <pavel@ucw.cz>,
        gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] staging: fix winbond build, needs delay.h
Message-Id: <20101119093018.340dab03.randy.dunlap@oracle.com>
In-Reply-To: <20101119143207.b2d5731e.sfr@canb.auug.org.au>
References: <20101119143207.b2d5731e.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

winbond drivers use msleep() and delay(), so include linux/delay.h
in a common header file to prevent build errors.

drivers/staging/winbond/phy_calibration.c:987: error: implicit declaration of function 'msleep'
drivers/staging/winbond/phy_calibration.c:1556: error: implicit declaration of function 'udelay'
drivers/staging/winbond/reg.c:894: error: implicit declaration of function 'msleep'
drivers/staging/winbond/reg.c:1178: error: implicit declaration of function 'udelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/winbond/sysdef.h |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20101119.orig/drivers/staging/winbond/sysdef.h
+++ linux-next-20101119/drivers/staging/winbond/sysdef.h
@@ -2,6 +2,9 @@
 
 #ifndef SYS_DEF_H
 #define SYS_DEF_H
+
+#include <linux/delay.h>
+
 #define WB_LINUX
 #define WB_LINUX_WPA_PSK
 
