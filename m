Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab0CQPWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:22:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:45998 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab0CQPWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:22:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,657,1262592000"; 
   d="scan'208";a="549843775"
Subject: Re: [patch 1/2] x86,pat Update the page flags for memtype
 atomically instead of using memtype_lock. -V3
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "holt@sgi.com" <holt@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <20100315132110.688234145@gulag1.americas.sgi.com>
References: <20100315132103.228021253@gulag1.americas.sgi.com>
	 <20100315132110.688234145@gulag1.americas.sgi.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 17 Mar 2010 08:21:16 -0800
Message-Id: <1268842876.2696.9.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 06:21 -0700, holt@sgi.com wrote:
> While testing an application using the xpmem (out of kernel) driver, we
> noticed a significant page fault rate reduction of x86_64 with respect
> to ia64.  For one test running with 32 cpus, one thread per cpu, it
> took 01:08 for each of the threads to vm_insert_pfn 2GB worth of pages.
> For the same test running on 256 cpus, one thread per cpu, it took 14:48
> to vm_insert_pfn 2 GB worth of pages.
> 
> The slowdown was tracked to lookup_memtype which acquires the
> spinlock memtype_lock.  This heavily contended lock was slowing down
> vm_insert_pfn().
> 
> With the cmpxchg on page->flags method, both the 32 cpu and 256 cpu
> cases take approx 00:01.3 seconds to complete.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

