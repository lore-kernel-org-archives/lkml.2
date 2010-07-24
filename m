Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978Ab0GXBm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 21:42:28 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16620 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927Ab0GXBmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 21:42:17 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, wim@iguana.be
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 5/7] MIPS: Export __cpu_number_map and __cpu_logical_map.
Date: Fri, 23 Jul 2010 18:41:45 -0700
Message-Id: <1279935707-3997-6-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279935707-3997-1-git-send-email-ddaney@caviumnetworks.com>
References: <1279935707-3997-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 24 Jul 2010 01:42:17.0187 (UTC) FILETIME=[72BF6B30:01CB2AD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The forthcoming Octeon watchdog driver will use them.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/kernel/smp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 6cdca19..383aeb9 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -47,8 +47,12 @@
 #endif /* CONFIG_MIPS_MT_SMTC */
 
 volatile cpumask_t cpu_callin_map;	/* Bitmask of started secondaries */
+
 int __cpu_number_map[NR_CPUS];		/* Map physical to logical */
+EXPORT_SYMBOL(__cpu_number_map);
+
 int __cpu_logical_map[NR_CPUS];		/* Map logical to physical */
+EXPORT_SYMBOL(__cpu_logical_map);
 
 /* Number of TCs (or siblings in Intel speak) per CPU core */
 int smp_num_siblings = 1;
-- 
1.7.1.1

