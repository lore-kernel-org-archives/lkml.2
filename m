Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0EHL1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 07:27:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62645 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab0EHL1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 07:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=nXApnHmWMocHBSz+Ve1lmADUXEbRYCsxgvSESyDDpZAu/q5u9IlfQUpEZ/m/VHaRQo
         gi1SleH9moKHruqN64OM8fcAXoT7YpT4GowSWaYYaxetIoz8IecoHRVqtUa1m42XSQ9V
         7zqO2wf2g3iU7ok4mPZMpj1/DM1QDefI5SnLo=
Message-Id: <20100508112717.130386882@openvz.org>
User-Agent: quilt/0.47-1
Date: Sat, 08 May 2010 15:25:53 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 3/4] x86,perf: P4 PMU -- Get rid of redundant check for array index
References: <20100508112550.187421916@openvz.org>
Content-Disposition: inline; filename=x86-perf-p4-redundant-check
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The caller already has done such a check.
And it was wrong anyway, it had to be '>=' rather then '>'

CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -406,11 +406,6 @@ static u64 p4_pmu_event_map(int hw_event
 	unsigned int esel;
 	u64 config;
 
-	if (hw_event > ARRAY_SIZE(p4_general_events)) {
-		printk_once(KERN_ERR "P4 PMU: Bad index: %i\n", hw_event);
-		return 0;
-	}
-
 	config = p4_general_events[hw_event];
 	bind = p4_config_get_bind(config);
 	esel = P4_OPCODE_ESEL(bind->opcode);

