Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0IWDFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:05:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52347 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab0IWDFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:05:53 -0400
X-Authority-Analysis: v=1.1 cv=QPMnOuvfoRK4nyqTv0NRvva4Xk0fUUuJArrqv1I9dZo= c=1 sm=0 a=KV-GooFRjiIA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=tHz9FfFoAAAA:8 a=meVymXHHAAAA:8 a=-c5dxv9MMpfpE0UBnCsA:9 a=kBv3AoNz2_AmokwDLDG9_nLszYIA:4 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=6O0IECtVFhoA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100923030551.518776502@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 22 Sep 2010 23:04:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, stable@kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH 2/2] tracing/x86: Dont use mcount in kvmclock.c
References: <20100923030359.649647055@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-x86-Don-t-use-mcount-in-kvmclock.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The guest can use the paravirt clock in kvmclock.c which is used
by sched_clock(), which in turn is used by the tracing mechanism
for timestamps, which leads to infinite recursion.

Disable mcount/tracing for kvmclock.o.

Cc: stable@kernel.org
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 882bbff..fedf32a 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -12,6 +12,7 @@ CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
 CFLAGS_REMOVE_pvclock.o = -pg
+CFLAGS_REMOVE_kvmclock.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
-- 
1.7.1


