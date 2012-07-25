Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2GYLvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:51:50 -0400
Received: from relay.parallels.com ([195.214.232.42]:57041 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab2GYLvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:51:49 -0400
Message-ID: <500FDDD1.5080805@parallels.com>
Date: Wed, 25 Jul 2012 15:51:45 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com> <20120720171002.GE13032@tassilo.jf.intel.com>
In-Reply-To: <20120720171002.GE13032@tassilo.jf.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 09:10 PM, Andi Kleen wrote:
>> +					unsigned int *msr_ext_cpuid_mask)
>> +{
>> +	unsigned int msr, msr_ext;
>> +
>> +	msr = msr_ext = 0;
>> +
>> +	switch (c->x86_model) {
> You have to check the family too.
>
>> +
>> +	return msr;
>> +}
>> +
>> +static void __cpuinit intel_mask_cpu_caps(struct cpuinfo_x86 *c)
>> +{
>> +	u32 low, high;
>> +	unsigned int msr_cpuid_mask, msr_ext_cpuid_mask;
>> +
>> +	msr_cpuid_mask = intel_cpuid_mask_msr(c,&msr_ext_cpuid_mask);
>> +	if (msr_cpuid_mask) {
>> +		set_cpu_cap(c, X86_FEATURE_CPUIDMASK);
>> +
>> +		rdmsr(msr_cpuid_mask, low, high);
> And please use rdmsrl(), rdmsr() is so 90ies
>
> Other than that patch looks good. I presume it will be useful for
> other things than just migration too.
>
> -Andi
>

Thank you for review, but we've decided to drop this since the kernel 
does not seem to be a suitable place for such "tweaking".
