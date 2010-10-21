Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab0JUD1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 23:27:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42730 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab0JUD1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 23:27:04 -0400
Date: Wed, 20 Oct 2010 21:26:57 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>
Subject: Re: linux-next: build warning after merge of the devicetree tree
Message-ID: <20101021032657.GB13335@angua.secretlab.ca>
References: <20101021133726.d1e5f433.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021133726.d1e5f433.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 01:37:26PM +1100, Stephen Rothwell wrote:
> Hi Grant,
> 
> After merging the devicetree tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> arch/x86/kernel/irq.c:280: warning: 'struct device_node' declared inside parameter list
> 
> Introduced by commit 27f4e2b1060be8bc38146fd30986e7c2858e2a5f ("x86/of:
> define irq functions to allow drivers/of/* to build on x86").  This build
> has CONFIG_OF not set.

Thanks Stephen.  Does the following patch fix things?

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 4417f49..23216f7 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -276,12 +276,14 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
 
+#ifdef CONFIG_OF
 unsigned int irq_create_of_mapping(struct device_node *controller,
                const u32 *intspec, unsigned int intsize)
 {
        return intspec[0];
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
+#endif
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */

