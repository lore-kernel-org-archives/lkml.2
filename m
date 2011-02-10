Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1BJJw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:52:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33850 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab1BJJw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:52:27 -0500
Subject: Re: [RFC PATCH V3 2/3] cpuidle: list based cpuidle driver
 registration and selection
From: Peter Zijlstra <peterz@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Trinabh Gupta <trinabh@linux.vnet.ibm.com>, arjan@linux.intel.com,
        lenb@kernel.org, suresh.b.siddha@intel.com, benh@kernel.crashing.org,
        venki@google.com, ak@linux.intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <20110210070031.GA5448@dirshya.in.ibm.com>
References: <20110208105146.9998.22103.stgit@tringupt.in.ibm.com>
	 <20110208105203.9998.35678.stgit@tringupt.in.ibm.com>
	 <1297250263.13327.159.camel@laptop>
	 <20110210070031.GA5448@dirshya.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 10:53:30 +0100
Message-ID: <1297331610.5226.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 12:30 +0530, Vaidyanathan Srinivasan wrote:

> We discussed this in the previous posts.  On ppc64 we would like to
> have single global registration, but for x86 Arjan recommended that we
> keep the per-cpu registration or else we may break legacy or buggy
> devices.
> 
> Ref: http://lkml.org/lkml/2009/10/7/210
> 
> One corner case that was against using lowest common C-State is that
> we could have cores/packages sporting a new lower C-State if they are
> at a thermal limit and want the OS to go to much lower C-State and
> sacrifice performance.  Our global design will prevent that cpu from
> going to a state lower than the rest of the system.
> 
> This is only a remote possibility, but could happen on battery
> operated devices, under low battery mode etc.  Basically we would have
> to keep our design open to allow individual CPUs to goto 'their'
> deepest allowed sleep state even in a asymmetric case.


But but but, its a stupid ACPI bug if it reports different C states for
different CPUs.

Len, does intel_idle also suffer this or does it simply ignore what ACPI
has to say?

Also, suppose for some daft reason it doesn't report C2 as available on
one of the CPUs, what happens if we use it anyway? (ie, use the union of
the reported states).



