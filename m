Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab0KIE7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 23:59:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:27057 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab0KIE7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 23:59:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,173,1288594800"; 
   d="scan'208";a="624870641"
Subject: Re: [DRAFT PATCH 2/3] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "paulus@samba.org" <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <87vd48qa6a.fsf@basil.nowhere.org>
References: <1288682905.12061.109.camel@minggr.sh.intel.com>
	 <87vd48qa6a.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 13:01:12 +0800
Message-ID: <1289278872.2430.17.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 20:20 +0800, Andi Kleen wrote:
> Lin Ming <ming.m.lin@intel.com> writes:
> 
> Looking at a an old patch.
> 
> > +
> > +static void uncore_pmu_disable_events(void)
> > +{
> > +	struct uncore_cpu_hw_events *cpuc = &__get_cpu_var(uncore_cpu_hw_events);
> > +	int node = numa_node_id();
> 
> Using numa_node_id() here implies this can't be used when NUMA is turned
> off. Better use the package id.

Right, will fix it with topology_physical_package_id.

Thanks.

> 
> -Andi
> 


