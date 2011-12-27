Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab1L0OEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:04:36 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:36721 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1L0OEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:04:33 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH -next] rcu: add missing __cpuinit annotation in rcutorture code
Date: Tue, 27 Dec 2011 15:04:26 +0100
Message-Id: <1324994666-4080-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.7.3
x-cbid: 11122714-6892-0000-0000-00000090C8C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"rcu: Add rcutorture CPU-hotplug capability" adds cpu hotplug operations
to the rcutorture code but produces a false positive warning about section
mismatches:

WARNING: vmlinux.o(.text+0x1e420c): Section mismatch in reference from the
	 function rcu_torture_onoff() to the function .cpuinit.text:cpu_up()
	 The function rcu_torture_onoff() references
	 the function __cpuinit cpu_up().
	 This is often because rcu_torture_onoff lacks a __cpuinit
	 annotation or the annotation of cpu_up is wrong.

Just add a __cpuinit annotation so the warning goes away.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/rcutorture.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index e29edc3..a58ac28 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1399,7 +1399,7 @@ rcu_torture_shutdown(void *arg)
  * Execute random CPU-hotplug operations at the interval specified
  * by the onoff_interval.
  */
-static int
+static int __cpuinit
 rcu_torture_onoff(void *arg)
 {
 	int cpu;
@@ -1447,7 +1447,7 @@ rcu_torture_onoff(void *arg)
 	return 0;
 }
 
-static int
+static int __cpuinit
 rcu_torture_onoff_init(void)
 {
 	if (onoff_interval <= 0)
-- 
1.7.7.3

