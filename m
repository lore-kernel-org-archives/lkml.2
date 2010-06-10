Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab0FJLYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:24:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41163 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758999Ab0FJLYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:24:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject;
	b=tcDIQTyBbqLz7tTO7A2c9SSd7oEWkDg9NHYA1RK5LSgTYHYX5n1/vvh/P+3vghuuF
	Pm9vzJyfyiJP7WGK0tQnw==
Message-ID: <4c10cb56.5120e30a.2eb4.ffffc3de@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Thu, 10 Jun 2010 13:25:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
       eranian@google.com
Subject: [PATCH] perf_events: update Intel Westmere event constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Intel Vol3b (March 2010), the event SNOOPQ_REQUEST_OUTSTANDING
is restricted to counters 0,1 so update the event table for Intel Westmere
accordingly.

Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index fdbc652..1f51d7f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -72,6 +72,7 @@ static struct event_constraint intel_westmere_event_constraints[] =
 	INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
 	INTEL_EVENT_CONSTRAINT(0x60, 0x1), /* OFFCORE_REQUESTS_OUTSTANDING */
 	INTEL_EVENT_CONSTRAINT(0x63, 0x3), /* CACHE_LOCK_CYCLES */
+        INTEL_EVENT_CONSTRAINT(0xb3, 0x1), /* SNOOPQ_REQUEST_OUTSTANDING */
 	EVENT_CONSTRAINT_END
 };
 
