Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1EDSSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:18:53 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:52826 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab1EDSSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:18:52 -0400
Date: Wed, 4 May 2011 20:18:45 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [PATCH 6/8] arch/x86/xen/time: Cleanup code/data sections definitions
Message-ID: <20110504181845.GG29218@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup code/data sections definitions
accordingly to include/linux/init.h.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 arch/x86/xen/time.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 2e2d370..bd4ffd7 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -439,11 +439,11 @@ void xen_timer_resume(void)
 	}
 }
 
-static const struct pv_time_ops xen_time_ops __initdata = {
+static const struct pv_time_ops xen_time_ops __initconst = {
 	.sched_clock = xen_clocksource_read,
 };
 
-static __init void xen_time_init(void)
+static void __init xen_time_init(void)
 {
 	int cpu = smp_processor_id();
 	struct timespec tp;
@@ -468,7 +468,7 @@ static __init void xen_time_init(void)
 	xen_setup_cpu_clockevents();
 }
 
-__init void xen_init_time_ops(void)
+void __init xen_init_time_ops(void)
 {
 	pv_time_ops = xen_time_ops;
 
@@ -490,7 +490,7 @@ static void xen_hvm_setup_cpu_clockevents(void)
 	xen_setup_cpu_clockevents();
 }
 
-__init void xen_hvm_init_time_ops(void)
+void __init xen_hvm_init_time_ops(void)
 {
 	/* vector callback is needed otherwise we cannot receive interrupts
 	 * on cpu > 0 and at this point we don't know how many cpus are
-- 
1.5.6.5
