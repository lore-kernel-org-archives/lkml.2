Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2BACam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 21:30:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab2BACak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 21:30:40 -0500
Date: Wed, 1 Feb 2012 10:33:14 +0800
From: Dave Young <dyoung@redhat.com>
To: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] add kernel param to force disable module load
Message-ID: <20120201023314.GA9722@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we need to test a kernel of same version with code or config
option changes.

We already have sysctl to disable module load, but add a kernel
parameter will be more convenient.

Since modules_disabled is int, so here use bint type in core_param.
TODO: make sysctl accept bool and change modules_disabled to bool

Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/kernel-parameters.txt |    2 ++
 kernel/module.c                     |    1 +
 2 files changed, 3 insertions(+)

--- linux-2.6.orig/Documentation/kernel-parameters.txt	2012-01-31 13:07:06.000000000 +0800
+++ linux-2.6/Documentation/kernel-parameters.txt	2012-01-31 13:07:09.393362159 +0800
@@ -1833,6 +1833,8 @@ bytes respectively. Such letter suffixes
 			shutdown the other cpus.  Instead use the REBOOT_VECTOR
 			irq.
 
+	nomodule	Disable module load
+
 	nopat		[X86] Disable PAT (page attribute table extension of
 			pagetables) support.
 
--- linux-2.6.orig/kernel/module.c	2012-01-31 13:07:06.000000000 +0800
+++ linux-2.6/kernel/module.c	2012-01-31 13:07:34.196695573 +0800
@@ -105,6 +105,7 @@ struct list_head *kdb_modules = &modules
 
 /* Block module loading/unloading? */
 int modules_disabled = 0;
+core_param(nomodule, modules_disabled, bint, 0);
 
 /* Waiting for a module to finish initializing? */
 static DECLARE_WAIT_QUEUE_HEAD(module_wq);
