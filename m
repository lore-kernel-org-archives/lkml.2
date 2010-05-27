Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab0E0UPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:15:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49719 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045Ab0E0UPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:15:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] CPU: Avoid using unititialized error variable in disable_nonboot_cpus()
Date: Thu, 27 May 2010 22:16:22 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005272216.22472.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If there's only one CPU online when disable_nonboot_cpus() is called,
the error variable will not be initialized and that may lead to
erroneous behavior.  Fix this issue by initializing error in
disable_nonboot_cpus() as appropriate.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -394,7 +394,7 @@ static cpumask_var_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
 {
-	int cpu, first_cpu, error;
+	int cpu, first_cpu, error = 0;
 
 	cpu_maps_update_begin();
 	first_cpu = cpumask_first(cpu_online_mask);
