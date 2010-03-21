Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0CUHSz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 03:18:55 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:56036 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab0CUHSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 03:18:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 16/20] x86: use num_processors for possible cpus
Date: Sun, 21 Mar 2010 00:13:17 -0700
Message-Id: <1269155601-18247-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BA5C7E9.01BD,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some systems that have disable cpus entries because same
  BIOS will support 2 sockets and 4 sockets and more at
  same time, BIOS just leave some disable entries, but
  those system do not support cpu hotplug. we don't need
  treat disabled_cpus as hotplug cpus.
so we can make nr_cpu_ids smaller and save more space
  (pcpu data allocations), and could make some systems run
  with logical flat instead of physical flat apic mode

-v2: change to black list instead
-v3: just remove that, and the one use possible_cpus= directly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/smpboot.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a1483ac..3f92885 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1251,7 +1251,6 @@ early_param("possible_cpus", _setup_possible_cpus);
  * - Ashok Raj
  *
  * Three ways to find out the number of additional hotplug CPUs:
- * - If the BIOS specified disabled CPUs in ACPI/mptables use that.
  * - The user can overwrite it with possible_cpus=NUM
  * - Otherwise don't reserve additional CPUs.
  * We do this because additional CPUs waste a lot of memory.
@@ -1266,7 +1265,7 @@ __init void prefill_possible_map(void)
 		num_processors = 1;
 
 	if (setup_possible_cpus == -1)
-		possible = num_processors + disabled_cpus;
+		possible = num_processors;
 	else
 		possible = setup_possible_cpus;
 
-- 
1.6.4.2

