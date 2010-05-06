Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0EFXpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:45:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29201 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0EFXpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:45:05 -0400
Date: Thu, 6 May 2010 16:44:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: [PATCH -next] staging: fix cxt1e1 semaphore build breakage
Message-Id: <20100506164408.412fed05.randy.dunlap@oracle.com>
In-Reply-To: <20100506151502.f97afe54.sfr@canb.auug.org.au>
References: <20100506151502.f97afe54.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4BE35478.0109:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors by including linux/semaphore.h:

drivers/staging/cxt1e1/pmcc4_private.h:144: error: field 'sr_sem_busy' has incomplete type
drivers/staging/cxt1e1/pmcc4_private.h:146: error: field 'sr_sem_wait' has incomplete type
drivers/staging/cxt1e1/pmcc4_private.h:189: error: field 'sem_wdbusy' has incomplete type
drivers/staging/cxt1e1/musycc.c:617: error: implicit declaration of function 'down'
drivers/staging/cxt1e1/musycc.c:641: error: implicit declaration of function 'up'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/cxt1e1/pmcc4_private.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100506.orig/drivers/staging/cxt1e1/pmcc4_private.h
+++ linux-next-20100506/drivers/staging/cxt1e1/pmcc4_private.h
@@ -20,6 +20,7 @@
 
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/semaphore.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>    /* support for tasklets */
 #include <linux/timer.h>        /* support for timer */
