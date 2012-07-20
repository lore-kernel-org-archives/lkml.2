Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2GTRKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:10:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:46683 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab2GTRKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:10:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181493698"
Date: Fri, 20 Jul 2012 10:10:02 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <borislav.petkov@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
Message-ID: <20120720171002.GE13032@tassilo.jf.intel.com>
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com>
 <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +					unsigned int *msr_ext_cpuid_mask)
> +{
> +	unsigned int msr, msr_ext;
> +
> +	msr = msr_ext = 0;
> +
> +	switch (c->x86_model) {

You have to check the family too.

> +
> +	return msr;
> +}
> +
> +static void __cpuinit intel_mask_cpu_caps(struct cpuinfo_x86 *c)
> +{
> +	u32 low, high;
> +	unsigned int msr_cpuid_mask, msr_ext_cpuid_mask;
> +
> +	msr_cpuid_mask = intel_cpuid_mask_msr(c, &msr_ext_cpuid_mask);
> +	if (msr_cpuid_mask) {
> +		set_cpu_cap(c, X86_FEATURE_CPUIDMASK);
> +
> +		rdmsr(msr_cpuid_mask, low, high);

And please use rdmsrl(), rdmsr() is so 90ies

Other than that patch looks good. I presume it will be useful for
other things than just migration too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
