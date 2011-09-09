Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab1IIXjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:39:10 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:17222 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1IIXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:39:06 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1315611545!16026661!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/x86/mm/numa.c: quiet sparse noise when CONFIG_X86_64 is not set
Date: Fri, 9 Sep 2011 16:38:48 -0700
User-Agent: KMail/1.9.9
CC: <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <tj@kernel.org>, <penberg@kernel.org>,
        <yinghai@kernel.org>, <rientjes@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109091638.49186.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_X86_64 is not set the function __node_distance is not declared in
<asm/topology.h>. This results in the following sparse noise.

warning: symbol '__node_distance' was not declared. Should it be static?

Fix this by putting an #ifdef around the function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>

---

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index fbeaaf4..11c60a7 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -455,6 +455,7 @@ void __init numa_set_distance(int from, int to, int distance)
 	numa_distance[from * numa_distance_cnt + to] = distance;
 }
 
+#ifdef CONFIG_X86_64
 int __node_distance(int from, int to)
 {
 	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
@@ -462,6 +463,7 @@ int __node_distance(int from, int to)
 	return numa_distance[from * numa_distance_cnt + to];
 }
 EXPORT_SYMBOL(__node_distance);
+#endif
 
 /*
  * Sanity check to catch more bad NUMA configurations (they are amazingly
