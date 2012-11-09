Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2KIQpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:45:14 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:34392 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2KIQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:45:05 -0500
Message-ID: <509D32C2.2090104@linux.vnet.ibm.com>
Date: Fri, 09 Nov 2012 22:13:46 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Mel Gorman <mgorman@suse.de>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, mjg59@srcf.ucam.org,
        paulmck@linux.vnet.ibm.com, maxime.coquelin@stericsson.com,
        loic.pallardy@stericsson.com, arjan@linux.intel.com,
        kmpark@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org,
        rjw@sisk.pl, gargankita@gmail.com, amit.kachhap@linaro.org,
        thomas.abraham@linaro.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8][Sorted-buddy] mm: Linux VM Infrastructure to
 support Memory Power Management
References: <20121106195026.6941.24662.stgit@srivatsabhat.in.ibm.com> <20121108180257.GC8218@suse.de> <20121109051247.GA499@dirshya.in.ibm.com> <20121109090052.GF8218@suse.de> <509D185D.8070307@linux.vnet.ibm.com> <509D200F.2000908@linux.vnet.ibm.com> <509D2B9B.4090305@linux.vnet.ibm.com> <509D3088.2060507@linux.vnet.ibm.com>
In-Reply-To: <509D3088.2060507@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
x-cbid: 12110916-5490-0000-0000-00000270BE4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 10:04 PM, Srivatsa S. Bhat wrote:
> On 11/09/2012 09:43 PM, Dave Hansen wrote:
>> On 11/09/2012 07:23 AM, Srivatsa S. Bhat wrote:
>>> FWIW, kernbench is actually (and surprisingly) showing a slight performance
>>> *improvement* with this patchset, over vanilla 3.7-rc3, as I mentioned in
>>> my other email to Dave.
>>>
>>> https://lkml.org/lkml/2012/11/7/428
>>>
>>> I don't think I can dismiss it as an experimental error, because I am seeing
>>> those results consistently.. I'm trying to find out what's behind that.
>>
>> The only numbers in that link are in the date. :)  Let's see the
>> numbers, please.
>>
> 
> Sure :) The reason I didn't post the numbers very eagerly was that I didn't
> want it to look ridiculous if it later turned out to be really an error in the
> experiment ;) But since I have seen it happening consistently I think I can
> post the numbers here with some non-zero confidence.
> 
>> If you really have performance improvement to the memory allocator (or
>> something else) here, then surely it can be pared out of your patches
>> and merged quickly by itself.  Those kinds of optimizations are hard to
>> come by!
>>
> 
> :-)
> 
> Anyway, here it goes:
> 
> Test setup:
> ----------
> x86 2-socket quad-core machine. (CONFIG_NUMA=n because I figured that my
> patchset might not handle NUMA properly). Mem region size = 512 MB.
> 

For CONFIG_NUMA=y on the same machine, the difference between the 2 kernels
was much lesser, but nevertheless, this patchset performed better. I wouldn't
vouch that my patchset handles NUMA correctly, but here are the numbers from
that run anyway (at least to show that I really found the results to be
repeatable):

Kernbench log for Vanilla 3.7-rc3
=================================
Kernel: 3.7.0-rc3-vanilla-numa-default
Average Optimal load -j 32 Run (std deviation):
Elapsed Time 589.058 (0.596171)
User Time 7461.26 (1.69702)
System Time 1072.03 (1.54704)
Percent CPU 1448.2 (1.30384)
Context Switches 2.14322e+06 (4042.97)
Sleeps 1847230 (2614.96)

Kernbench log for Vanilla 3.7-rc3
=================================
Kernel: 3.7.0-rc3-sorted-buddy-numa-default
Average Optimal load -j 32 Run (std deviation):
Elapsed Time 577.182 (0.713772)
User Time 7315.43 (3.87226)
System Time 1043 (1.12855)
Percent CPU 1447.6 (2.19089)
Context Switches 2117022 (3810.15)
Sleeps 1.82966e+06 (4149.82)


Regards,
Srivatsa S. Bhat

> Kernbench log for Vanilla 3.7-rc3
> =================================
> 
> Kernel: 3.7.0-rc3-vanilla-default
> Average Optimal load -j 32 Run (std deviation):
> Elapsed Time 650.742 (2.49774)
> User Time 8213.08 (17.6347)
> System Time 1273.91 (6.00643)
> Percent CPU 1457.4 (3.64692)
> Context Switches 2250203 (3846.61)
> Sleeps 1.8781e+06 (5310.33)
> 
> Kernbench log for this sorted-buddy patchset
> ============================================
> 
> Kernel: 3.7.0-rc3-sorted-buddy-default
> Average Optimal load -j 32 Run (std deviation):
> Elapsed Time 591.696 (0.660969)
> User Time 7511.97 (1.08313)
> System Time 1062.99 (1.1109)
> Percent CPU 1448.6 (1.94936)
> Context Switches 2.1496e+06 (3507.12)
> Sleeps 1.84305e+06 (3092.67)
> 

