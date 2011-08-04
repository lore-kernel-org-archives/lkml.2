Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1HDOzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:55:52 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59589 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1HDOzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:55:51 -0400
MIME-Version: 1.0
Date: Thu, 4 Aug 2011 22:55:49 +0800
Message-ID: <CAJd=RBDv1wsdVYmwdtr2BGOCuya1eKg4PeWeggPbz5u_5545ig@mail.gmail.com>
Subject: [RFC patch] MIPS/netlogic: dont setup boot CPU twice
From: Hillf Danton <dhillf@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When do smp setup, check for boot CPU is added, then it is impossible to be
initialized twice.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 arch/mips/netlogic/xlr/smp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/mips/netlogic/xlr/smp.c b/arch/mips/netlogic/xlr/smp.c
index b495a7f..e6f8c62 100644
--- a/arch/mips/netlogic/xlr/smp.c
+++ b/arch/mips/netlogic/xlr/smp.c
@@ -167,6 +167,8 @@ void __init nlm_smp_setup(void)

 	num_cpus = 1;
 	for (i = 0; i < NR_CPUS; i++) {
+		if (i == boot_cpu)
+			continue;
 		if (nlm_cpu_ready[i]) {
 			cpu_set(i, phys_cpu_present_map);
 			__cpu_number_map[i] = num_cpus;
