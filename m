Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab1BRTBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 14:01:04 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:39039 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab1BRTBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 14:01:02 -0500
Message-ID: <4D5EC184.6000505@kernel.org>
Date: Fri, 18 Feb 2011 10:59:16 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 2/4] x86, numa: Do not adjust start/end for early_node_mem()
References: <4D5EC05A.60103@kernel.org>
In-Reply-To: <4D5EC05A.60103@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D5EC1D9.011F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We have top-down allocation already. So do not bothter to adjust
start/end to make sure get high addr on local hode.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/numa_64.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -164,14 +164,9 @@ static void * __init early_node_mem(int
 	unsigned long mem;
 
 	/*
-	 * put it on high as possible
-	 * something will go with NODE_DATA
+	 * memblock find will follow top-down, so don't need to adjust
+	 *   start anymore
 	 */
-	if (start < (MAX_DMA_PFN<<PAGE_SHIFT))
-		start = MAX_DMA_PFN<<PAGE_SHIFT;
-	if (start < (MAX_DMA32_PFN<<PAGE_SHIFT) &&
-	    end > (MAX_DMA32_PFN<<PAGE_SHIFT))
-		start = MAX_DMA32_PFN<<PAGE_SHIFT;
 	mem = memblock_x86_find_in_range_node(nodeid, start, end, size, align);
 	if (mem != MEMBLOCK_ERROR)
 		return __va(mem);
