Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2IYLHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:07:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34451 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab2IYLHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:07:35 -0400
Message-ID: <1348571242.3881.11.camel@twins>
Subject: Re: [PATCH] Update sched_domains_numa_masks when new cpus are
 onlined.
From: Peter Zijlstra <peterz@infradead.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-numa@vger.kernel.org, wency@cn.fujitsu.com, mingo@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 25 Sep 2012 13:07:22 +0200
In-Reply-To: <50611946.9080601@cn.fujitsu.com>
References: <1347963128-25942-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1348479536.11847.25.camel@twins> <50611946.9080601@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 10:39 +0800, Tang Chen wrote:
> > We do this because nr_node_ids changed, right? This means the entire
> > distance table grew/shrunk, which means we should do the level scan
> > again.
> 
> It seems that nr_node_ids will not change once the system is up.
> I'm not quite sure. If I am wrong, please tell me. :) 

Ah, right you are..

So the problem is that cpumask_of_node() doesn't contain offline cpus,
and we might not boot the machine with all cpus present.

In that case I guess the suggested hotplug hooks are fine. Its just that
your changelog was confusing.
