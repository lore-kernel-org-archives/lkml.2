Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0JOM5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:57:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:49216 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405Ab0JOM53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:57:29 -0400
Message-ID: <4CB84FAF.5080608@kernel.org>
Date: Fri, 15 Oct 2010 14:57:19 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Karsten Keil <isdn@linux-pingi.de>, Armin Schindler <mac@melware.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2.6.36-rc7] isdn/eicon: don't call flush_scheduled_work()
 from diva_os_remove_soft_isr()
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 12:57:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diva doesn't use workqueue and there is no reason to flush the system
workqueue from diva_os_remove_soft_isr().  Remove it.

This is to prepare for the deprecation and removal of
flush_scheduled_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/isdn/hardware/eicon/divasmain.c |    2 --
 1 file changed, 2 deletions(-)

Index: work/drivers/isdn/hardware/eicon/divasmain.c
===================================================================
--- work.orig/drivers/isdn/hardware/eicon/divasmain.c
+++ work/drivers/isdn/hardware/eicon/divasmain.c
@@ -15,7 +15,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/ioport.h>
-#include <linux/workqueue.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
@@ -546,7 +545,6 @@ void diva_os_remove_soft_isr(diva_os_sof
 		void *mem;

 		tasklet_kill(&pdpc->divas_task);
-		flush_scheduled_work();
 		mem = psoft_isr->object;
 		psoft_isr->object = NULL;
 		diva_os_free(0, mem);
