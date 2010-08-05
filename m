Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522Ab0HEA1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:27:14 -0400
Received: from prod-mail-xrelay03.akamai.com ([96.6.114.84]:37723 "EHLO
	prod-mail-xrelay03.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759418Ab0HEA1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:27:11 -0400
From: Josh Hunt <johunt@akamai.com>
To: oprofile-list@lists.sf.net, robert.richter@amd.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Cc: juhlenko@akamai.com
Subject: [PATCH] oprofile: add support for Intel processor model 30
Date: Wed,  4 Aug 2010 17:27:05 -0700
Message-Id: <1280968025-16969-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer Intel processors identifying themselves as model 30 are not recognized by
oprofile.

<cpuinfo snippet>
model           : 30
model name      : Intel(R) Xeon(R) CPU           X3470  @ 2.93GHz
</cpuinfo snippet>

Running oprofile on these machines gives the following:
+ opcontrol --init
+ opcontrol --list-events
oprofile: available events for CPU type "Intel Architectural Perfmon"

See Intel 64 and IA-32 Architectures Software Developer's Manual
Volume 3B (Document 253669) Chapter 18 for architectural perfmon events
This is a limited set of fallback events because oprofile doesn't know your CPU
CPU_CLK_UNHALTED: (counter: all)
        Clock cycles when not halted (min count: 6000)
INST_RETIRED: (counter: all)
        number of instructions retired (min count: 6000)
LLC_MISSES: (counter: all)
        Last level cache demand requests from this core that missed the LLC
(min count: 6000)
        Unit masks (default 0x41)
        ----------
        0x41: No unit mask
LLC_REFS: (counter: all)
        Last level cache demand requests from this core (min count: 6000)
        Unit masks (default 0x4f)
        ----------
        0x4f: No unit mask
BR_MISS_PRED_RETIRED: (counter: all)
        number of mispredicted branches retired (precise) (min count: 500)
+ opcontrol --shutdown

Tested using oprofile 0.9.6.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 arch/x86/oprofile/nmi_int.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index b28d2f1..6f95251 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -657,6 +657,7 @@ static int __init ppro_init(char **cpu_type)
 		break;
 	case 0x2e:
 	case 26:
+	case 30:
 		spec = &op_arch_perfmon_spec;
 		*cpu_type = "i386/core_i7";
 		break;
-- 
1.7.0.4

