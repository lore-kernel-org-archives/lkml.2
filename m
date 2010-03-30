Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0CaANz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:13:55 -0400
Received: from kroah.org ([198.145.64.141]:51889 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab0C3XRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:48 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:18 2010
Message-Id: <20100330225617.649306092@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>,
       Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [031/116] sched: Mark boot-cpu active before smp_init()
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 933b0618d8b2a59c7a0742e43836544e02f1e9bd upstream.

A UP machine has 1 active cpu, not having the boot-cpu in the
active map when starting the scheduler confuses things.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.423469527@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 init/main.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/init/main.c
+++ b/init/main.c
@@ -369,12 +369,6 @@ static void __init smp_init(void)
 {
 	unsigned int cpu;
 
-	/*
-	 * Set up the current CPU as possible to migrate to.
-	 * The other ones will be done by cpu_up/cpu_down()
-	 */
-	set_cpu_active(smp_processor_id(), true);
-
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
@@ -486,6 +480,7 @@ static void __init boot_cpu_init(void)
 	int cpu = smp_processor_id();
 	/* Mark the boot cpu "present", "online" etc for SMP and UP case */
 	set_cpu_online(cpu, true);
+	set_cpu_active(cpu, true);
 	set_cpu_present(cpu, true);
 	set_cpu_possible(cpu, true);
 }


