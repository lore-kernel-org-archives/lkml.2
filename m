Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2IYLuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:50:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40097 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab2IYLuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:50:19 -0400
Message-ID: <1348573806.3881.35.camel@twins>
Subject: Re: [PATCH] Update sched_domains_numa_masks when new cpus are
 onlined.
From: Peter Zijlstra <peterz@infradead.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-numa@vger.kernel.org, wency@cn.fujitsu.com, mingo@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 25 Sep 2012 13:50:06 +0200
In-Reply-To: <5061996E.8070301@cn.fujitsu.com>
References: <1347963128-25942-1-git-send-email-tangchen@cn.fujitsu.com>
	  <1348479536.11847.25.camel@twins> <50611946.9080601@cn.fujitsu.com>
	 <1348569232.3881.1.camel@twins> <5061996E.8070301@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 19:45 +0800, Tang Chen wrote:


> Let's have an example here.
> 
> sched_init_numa()
> {
> 	...
> 	// A loop set sched_domains_numa_levels to level.-------------1
> 
> 	// I set sched_domains_numa_levels to 0.
> 	sched_domains_numa_levels = 0;--------------------------------2

Ah, ok, so this 'idiot in a hurry' (aka. me) placed the hunk wrong and
thought it was at the start of the function.

> 	// A loop allocating memory for sched_domains_numa_masks[][]
> 	for (i = 0; i < level; i++) {
> 		......
> 		// Allocate memory for sched_domains_numa_masks[i]----3
> 		......
> 	}
> 	......
> 
> 	// I reset sched_domains_numa_levels to level.
> 	sched_domains_numa_levels = level;----------------------------4
> }

Yes this makes sense, it might be best to have this as a separate patch.
