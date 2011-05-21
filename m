Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1EUMMQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 08:12:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44575 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677Ab1EUMMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 08:12:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/3] PM / Hibernate: Update some comments in core hibernate code
Date: Sat, 21 May 2011 14:09:33 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Frank Hofmann <frank.hofmann@tomtom.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <201105211408.28671.rjw@sisk.pl>
In-Reply-To: <201105211408.28671.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105211409.34012.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Some comments in the core hibernate code are outdated, some aren't
necessary any more and at least one of them is plain wrong.  Remove
those comments or update them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/hibernate.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

Index: linux-2.6/kernel/power/hibernate.c
===================================================================
--- linux-2.6.orig/kernel/power/hibernate.c
+++ linux-2.6/kernel/power/hibernate.c
@@ -248,12 +248,6 @@ static int create_image(int platform_mod
 	if (error)
 		return error;
 
-	/* At this point, dpm_suspend_start() has been called, but *not*
-	 * dpm_suspend_noirq(). We *must* call dpm_suspend_noirq() now.
-	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
-	 * become desynchronized with the actual state of the hardware
-	 * at resume time, and evil weirdness ensues.
-	 */
 	error = dpm_suspend_noirq(PMSG_FREEZE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
@@ -297,9 +291,6 @@ static int create_image(int platform_mod
 
  Power_up:
 	syscore_resume();
-	/* NOTE:  dpm_resume_noirq() is just a resume() for devices
-	 * that suspended with irqs off ... no overall powerup.
-	 */
 
  Enable_irqs:
 	local_irq_enable();
@@ -416,24 +407,26 @@ static int resume_target_kernel(bool pla
 	if (error)
 		goto Enable_irqs;
 
-	/* We'll ignore saved state, but this gets preempt count (etc) right */
 	save_processor_state();
 	error = restore_highmem();
 	if (!error) {
 		error = swsusp_arch_resume();
 		/*
 		 * The code below is only ever reached in case of a failure.
-		 * Otherwise execution continues at place where
-		 * swsusp_arch_suspend() was called
+		 * Otherwise, execution continues at the place where
+		 * swsusp_arch_suspend() was called.
 		 */
 		BUG_ON(!error);
-		/* This call to restore_highmem() undos the previous one */
+		/*
+		 * This call to restore_highmem() reverts the changes made by
+		 * the previous one.
+		 */
 		restore_highmem();
 	}
 	/*
 	 * The only reason why swsusp_arch_resume() can fail is memory being
 	 * very tight, so we have to free it as soon as we can to avoid
-	 * subsequent failures
+	 * subsequent failures.
 	 */
 	swsusp_free();
 	restore_processor_state();

