Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783Ab1D3XML (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 19:12:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35398 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1D3XMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 19:12:07 -0400
Message-ID: <4DBC9730.8030407@kernel.org>
Date: Sat, 30 Apr 2011 16:11:44 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, mingo@redhat.com, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, numa: Rename setup_node_bootmem to setup_node_data
References: <1304090924-8197-1-git-send-email-tj@kernel.org>	<1304090924-8197-9-git-send-email-tj@kernel.org>	<4DBAF498.40007@kernel.org>	<20110430120307.GE29280@htj.dyndns.org>	<4DBC37D0.3070408@kernel.org> <BANLkTimaDnFZbSAitJOPdKb2fuuHKS0HpQ@mail.gmail.com>
In-Reply-To: <BANLkTimaDnFZbSAitJOPdKb2fuuHKS0HpQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DBC9739.0011,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


after using memblock to replace bootmem, that function only setup node_data
now.

Change the name to reflecting the real work.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/numa.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/numa.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa.c
+++ linux-2.6/arch/x86/mm/numa.c
@@ -189,8 +189,8 @@ int __init numa_add_memblk(int nid, u64
 	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
 }
 
-/* Initialize bootmem allocator for a node */
-static void __init setup_node_bootmem(int nid, u64 start, u64 end)
+/* Initialize NODE_DATA for a node on the local memory */
+static void __init setup_node_data(int nid, u64 start, u64 end)
 {
 	const u64 nd_low = PFN_PHYS(MAX_DMA_PFN);
 	const u64 nd_high = PFN_PHYS(max_pfn_mapped);
@@ -522,7 +522,7 @@ static int __init numa_register_memblks(
 		}
 
 		if (start < end)
-			setup_node_bootmem(nid, start, end);
+			setup_node_data(nid, start, end);
 	}
 
 	return 0;
