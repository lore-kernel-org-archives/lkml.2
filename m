Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2IZIAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:00:45 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:39436 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2IZIAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:00:44 -0400
Message-ID: <5062B602.6000502@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 13:30:02 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86/fixup_irq: Clean the offlining CPU from the irq affinity
 mask
References: <1348669924.19514.6.camel@cliu38-desktop-build> <5062A442.2030207@linux.vnet.ibm.com> <27240C0AC20F114CBF8149A2696CBE4A189F97@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A189F97@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092607-3568-0000-0000-00000283D37A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 12:22 PM, Liu, Chuansheng wrote:
>>> +		} else if (cpumask_test_cpu(cpu, data->affinity))
>>> +			cpumask_clear_cpu(cpu, data->affinity);
>>>
>>
>> You meant to use 'affinity' (instead of data->affinity) in the above 2 statements
>> right? Note that we do chip->irq_set_affinity(data, affinity, true); further down.
>>
> 
> Yes, I have noticed it, used data->affinity here is just for avoiding compile warning.
> in fact affinity == data->affinity, but affinity pointer is const type,
> And cpumask_clear_cpu needs non-const type,so here I am using data->affinity,
> instead of changing code "const struct cpumask *affinity;"
> 

Hmm.. Then what happens to error handling in the case that you can't set
the affinity?

ie., if we take the 'else' branch in:
                if (chip->irq_set_affinity)
                        chip->irq_set_affinity(data, affinity, true);
                else if (!(warned++))
                        set_affinity = 0;

In that case, we would end up with an incorrect data->affinity right?

Btw, on a slightly different note, I'm also rather surprised that the above
code doesn't care about the return value of chip->irq_set_affinity() ..
Shouldn't we warn if that fails?

Regards,
Srivatsa S. Bhat

