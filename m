Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762855Ab2KBNvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:51:54 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59090 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab2KBNvw convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 2 Nov 2012 09:51:52 -0400
Message-Id: <5093DE3002000078000A60C0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Nov 2012 13:52:32 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/perf_events: build fix
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least some older gcc versions dislike mixing constant and non-const
data in the same section ("... causes a section type confict").

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/cpu/perf_event_p6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.7-rc3/arch/x86/kernel/cpu/perf_event_p6.c
+++ 3.7-rc3-x86-perf-p6-section/arch/x86/kernel/cpu/perf_event_p6.c
@@ -19,7 +19,7 @@ static const u64 p6_perfmon_event_map[] 
 
 };
 
-static __initconst u64 p6_hw_cache_event_ids
+static const u64 __initconst p6_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =



