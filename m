Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab1ISXDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:03:45 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:32016 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1ISXDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:03:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-131.messagelabs.com!1316473415!1375690!8
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: use the same node_distance for 32 and 64-bit
Date: Mon, 19 Sep 2011 16:03:14 -0700
User-Agent: KMail/1.9.9
CC: <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <tj@kernel.org>, <yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109191603.15560.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The node_distance function is not x86 64-bit specific.  Having the #ifdef
around the extern function declaration and the #define causes the default
node_distance macro to be used in asm-generic/topology.h. This also causes
a sparse warning in arch/x86/mm/numa.c when CONFIG_X86_64 is not set:

warning: symbol '__node_distance' was not declared. Should it be static?

Remove the #ifdef to fix both issues.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>

---

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index c006924..800f77c 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -130,10 +130,8 @@ extern void setup_node_to_cpumask_map(void);
 	.balance_interval	= 1,					\
 }
 
-#ifdef CONFIG_X86_64
 extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
-#endif
 
 #else /* !CONFIG_NUMA */
 
