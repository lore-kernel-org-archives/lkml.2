Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2BOFBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 00:01:31 -0500
Received: from ozlabs.org ([203.10.76.45]:39403 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab2BOFAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 00:00:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Message-ID: <1329281884.9242.rusty@rustcorp.com.au>
Date: Wed, 15 Feb 2012 15:28:04 +1030
Subject: [PATCH 5/12] arch/parisc: remove references to cpu_*_map.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

This has been obsolescent for a while; time for the final push.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: linux-parisc@vger.kernel.org
---
 arch/parisc/kernel/smp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -291,8 +291,7 @@ smp_cpu_init(int cpunum)
 	mb();
 
 	/* Well, support 2.4 linux scheme as well. */
-	if (cpu_isset(cpunum, cpu_online_map))
-	{
+	if (cpu_online(cpunum))	{
 		extern void machine_halt(void); /* arch/parisc.../process.c */
 
 		printk(KERN_CRIT "CPU#%d already initialized!\n", cpunum);

