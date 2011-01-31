Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab1AaP7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:59:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50076 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab1AaP7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:59:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nbUbJLc+E2JBC+8TZK6wyT0FXqfDoMfUa12g9IzcBTG3AnXFZlyMdxlL6BmzQw+I1r
         pCFRJM4wukXfhFq2/nmlVjM6RcNsHhWWBKvqISlCzzKP/DOpMdpETPlZNNZdHMZJ6TS+
         hm8rpxY6hnIhmM5s9EJ4pO4wFWSqZT7B9eXG4=
Date: Mon, 31 Jan 2011 16:59:05 +0100
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        x86@kernel.org
Cc: yinghai@kernel.org
Subject: [PATCH tip/x86/numa] x86: Rename incorrectly named parameter of
 numa_cpu_node()
Message-ID: <20110131155905.GM7459@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

numa_cpu_node() prototype in numa_32.h has wrongly named parameter
@apicid when it actually takes the CPU number.  Change it to @cpu.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/numa_32.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/numa_32.h b/arch/x86/include/asm/numa_32.h
index bc66031..c6beed1 100644
--- a/arch/x86/include/asm/numa_32.h
+++ b/arch/x86/include/asm/numa_32.h
@@ -6,7 +6,7 @@ extern int numa_off;
 extern int pxm_to_nid(int pxm);
 
 #ifdef CONFIG_NUMA
-extern int __cpuinit numa_cpu_node(int apicid);
+extern int __cpuinit numa_cpu_node(int cpu);
 #else	/* CONFIG_NUMA */
 static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
 #endif	/* CONFIG_NUMA */
