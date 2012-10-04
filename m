Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab2JDMbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:31:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:33795 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab2JDMbE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:31:04 -0400
Message-ID: <1349353849.14388.2.camel@twins>
Subject: Re: [PATCH v2 2/2] Update sched_domains_numa_masks when new cpus
 are onlined.
From: Peter Zijlstra <peterz@infradead.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: srivatsa.bhat@linux.vnet.ibm.com, mingo@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-numa@vger.kernel.org, Wen Congyang <wency@cn.fujitsu.com>
Date: Thu, 04 Oct 2012 14:30:49 +0200
In-Reply-To: <1348578751-16904-3-git-send-email-tangchen@cn.fujitsu.com>
References: <1348578751-16904-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1348578751-16904-3-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 21:12 +0800, Tang Chen wrote:
> +static int sched_domains_numa_masks_update(struct notifier_block
> *nfb,
> +                                          unsigned long action,
> +                                          void *hcpu)
> +{
> +       int cpu = (int)hcpu; 

kernel/sched/core.c: In function ‘sched_domains_numa_masks_update’:
kernel/sched/core.c:6299:12: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

I've changed it to:

	int cpu = (long)hcpu;



