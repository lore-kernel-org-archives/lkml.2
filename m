Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab0IWDFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:05:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62153 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab0IWDFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:05:53 -0400
X-Authority-Analysis: v=1.1 cv=Yii9LXZpONf3Dl4H+sCjsa4WyoNNo7yi1hAau1xJxWE= c=1 sm=0 a=4KA99kSbpuIA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ZfRw4ET0AAAA:8 a=VwQbUJbxAAAA:8 a=tHz9FfFoAAAA:8 a=meVymXHHAAAA:8 a=hDT1lKg8xDEjUwcjMVIA:9 a=0850CylRBBiZTwSpMXefthhVkowA:4 a=KciULlu47koA:10 a=LI9Vle30uBYA:10 a=6O0IECtVFhoA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100923030551.193325145@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 22 Sep 2010 23:04:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, stable@kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 1/2] tracing/x86: Dont use mcount in pvclock.c
References: <20100923030359.649647055@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-x86-Don-t-use-mcount-in-pvclock.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>

When using a paravirt clock, pvclock.c can be used by sched_clock(),
which in turn is used by the tracing mechanism for timestamps,
which leads to infinite recursion.

Disable mcount/tracing for pvclock.o.

Cc: stable@kernel.org
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
LKML-Reference: <4C9A9A3F.4040201@goop.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..882bbff 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -11,6 +11,7 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
+CFLAGS_REMOVE_pvclock.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
-- 
1.7.1


