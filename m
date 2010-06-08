Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0FHU4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:56:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:39414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425Ab0FHU4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:56:23 -0400
Date: Tue, 8 Jun 2010 20:55:50 GMT
From: tip-bot for Livio Soares <livio@eecg.toronto.edu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, arjan@linux.intel.com, a.p.zijlstra@chello.nl,
       livio@eecg.toronto.edu, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, livio@eecg.toronto.edu,
       a.p.zijlstra@chello.nl, arjan@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Small fix to cpuid10_edx
Message-ID: <tip-e768aee89c687a50e6a2110e30c5cae1fbf0d2da@git.kernel.org>
Git-Commit-ID: e768aee89c687a50e6a2110e30c5cae1fbf0d2da
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Jun 2010 20:55:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e768aee89c687a50e6a2110e30c5cae1fbf0d2da
Gitweb:     http://git.kernel.org/tip/e768aee89c687a50e6a2110e30c5cae1fbf0d2da
Author:     Livio Soares <livio@eecg.toronto.edu>
AuthorDate: Thu, 3 Jun 2010 15:00:31 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Jun 2010 20:27:04 +0200

perf, x86: Small fix to cpuid10_edx

Fixes to 'cpuid10_edx' to comply with Intel documentation.
According to the Intel Manual, Volume 2A, Table 3-12, the cpuid for
architecture performance monitoring returns, in EDX, two pieces of
information:

  1) Number of fixed-function counters (5 bits, not 4)
  2) Width of fixed-function counters (8 bits)

Signed-off-by: Livio Soares <livio@eecg.toronto.edu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 254883d..6ed3ae4 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -68,8 +68,9 @@ union cpuid10_eax {
 
 union cpuid10_edx {
 	struct {
-		unsigned int num_counters_fixed:4;
-		unsigned int reserved:28;
+		unsigned int num_counters_fixed:5;
+		unsigned int bit_width_fixed:8;
+		unsigned int reserved:19;
 	} split;
 	unsigned int full;
 };
