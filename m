Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab2ICIGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:06:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:37955 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab2ICIGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:06:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,359,1344182400"; 
   d="scan'208";a="5773057"
Message-ID: <5044665C.5020909@cn.fujitsu.com>
Date: Mon, 03 Sep 2012 16:12:12 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, linux-pm@vger.kernel.org
CC: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, tglx@linutronix.de,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, rusty@rustcorp.com.au,
        bhelgaas@google.com, David Rientjes <rientjes@google.c>
Subject: [PATCH 2/2] numa: don't check if node is NUMA_NO_NODE
References: <504457C8.10209@cn.fujitsu.com>
In-Reply-To: <504457C8.10209@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/03 16:06:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/03 16:06:26,
	Serialize complete at 2012/09/03 16:06:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't debug per_cpu maps, the cpu's node is stored in per_cpu variable
numa_node. If node is NUMA_NO_NODE, it means the caller want to clear the
cpu's node. So we should also call set_cpu_numa_node() in this case.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 arch/x86/mm/numa.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 2d125be..21d02f0 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -97,8 +97,7 @@ void __cpuinit numa_set_node(int cpu, int node)
 #endif
 	per_cpu(x86_cpu_to_node_map, cpu) = node;
 
-	if (node != NUMA_NO_NODE)
-		set_cpu_numa_node(cpu, node);
+	set_cpu_numa_node(cpu, node);
 }
 
 void __cpuinit numa_clear_node(int cpu)
-- 
1.7.1

