Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab1CCC0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:26:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:26958 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058Ab1CCC0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:26:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,256,1297065600"; 
   d="scan'208";a="663266673"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/4] perf: offcore event monitoring patches
Date: Thu,  3 Mar 2011 10:34:46 +0800
Message-Id: <1299119690-13991-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

v2 -> v3:
- Remove redundant "c = NULL" in intel_percore_constraints
- Fix comment of perf_event_attr::config1

v2:
Here is the updated offcore patches. I merged small changes and fixes
into the first patch, see the change logs.

Change logs against Andi's original version:
- Extends perf_event_attr:config to config{,1,2} (Peter Zijlstra)
- Fixed a major event scheduling issue. There cannot be a ref++ on an
event that has already done ref++ once and without calling
put_constraint() in between. (Stephane Eranian)
- Use thread_cpumask for percore allocation. (Lin Ming)
- Use MSR names in the extra reg lists. (Lin Ming)

Peter,
The event scheduling issue was fixed, could you please consider merging
this series?

Thanks,
Lin Ming
