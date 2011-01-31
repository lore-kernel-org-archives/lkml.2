Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab1AaUKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:10:04 -0500
Received: from usaga03-in.huawei.com ([206.16.17.220]:54001 "EHLO
	usaga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab1AaUKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:10:01 -0500
Date: Mon, 31 Jan 2011 12:10:04 -0800
From: Kaushik Barde <kbarde@huawei.com>
Subject: RE: One (possible) x86 get_user_pages bug
In-reply-to: <4D46F9AE.80606@goop.org>
To: "'Jeremy Fitzhardinge'" <jeremy@goop.org>
Cc: "'Avi Kivity'" <avi@redhat.com>, "'Jan Beulich'" <JBeulich@novell.com>,
        "'Xiaowei Yang'" <xiaowei.yang@huawei.com>,
        "'Nick Piggin'" <npiggin@kernel.dk>,
        "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>, fanhenglong@huawei.com,
        "'Kenneth Lee'" <liguozhu@huawei.com>,
        "'linqaingmin'" <linqiangmin@huawei.com>, wangzhenguo@huawei.com,
        "'Wu Fengguang'" <fengguang.wu@intel.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        "'Marcelo Tosatti'" <mtosatti@redhat.com>
Message-id: <003301cbc182$da3affc0$8eb0ff40$@com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: en-us
Content-transfer-encoding: 7BIT
Thread-index: AcvBcYgoa/90xZeyTW60Kt7EGFmB7AADqAQA
iPlanet-SMTP-Warning: Lines longer than SMTP allows found and truncated.
x-cr-hashedpuzzle: GNyS LRST YKek 2UV6 3Trn 4mQU /d0T AIRl1Q== ANT7yg==
 AOQxcA== APVaFA== ATBCWg== ATzzLQ== AUWPHg== AVRLaw==
 AXwAcA==;14;YQAuAHAALgB6AGkAagBsAHMAdAByAGEAQABjAGgAZQBsAGwAbwAuAG4AbAA7AGEAdgBpAEAAcgBlAGQAaABhAHQALgBjAG8AbQA7AGYAYQBuAGgAZQBuAGcAbABvAG4AZwBAAGgAdQBhAHcAZQBpAC4AYwBvAG0AOwBmAGUAbgBnAGcAdQBhAG4AZwAuAHcAdQBAAGkAbgB0AGUAbAAuAGMAbwBtADsAagBiAGUAdQBsAGkAYwBoAEAAbgBvAHYAZQBsAGwALgBjAG8AbQA7AGoAZQByAGUAbQB5AEAAZwBvAG8AcAAuAG8AcgBnADsAbABpAGcAdQBvAHoAaAB1AEAAaAB1AGEAdwBlAGkALgBjAG8AbQA7AGwAaQBuAHEAaQBhAG4AZwBtAGkAbgBAAGgAdQBhAHcAZQBpAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbQB0AG8AcwBhAHQAdABpAEAAcgBlAGQAaABhAHQALgBjAG8AbQA7AG4AcABpAGcAZwBpAG4AQABrAGUAcgBuAGUAbAAuAGQAawA7AHcAYQBuAGcAegBoAGUAbgBnAHUAbwBAAGgAdQBhAHcAZQBpAC4AYwBvAG0AOwB4AGUAbgAtAGQAZQB2AGUAbABAAGwAaQBzAHQAcwAuAHgAZQBuAHMAbwB1AHIAYwBlAC4AYwBvAG0AOwB4AGkAYQBvAHcAZQBpAC4AeQBhAG4AZwBAAGgAdQBhAHcAZQBpAC4AYwBvAG0A;Sosha1_v1;7;{9B16F811-C532-486E-A4C3-F04425
	GUAQABoAHUAYQB3AGUAaQAuAGMAbwBtAA==;Mon,
 31 Jan 2011 20:09:35 GMT;UgBFADoAIABPAG4AZQAgACgAcABvAHMAcwBpAGIAbABlACkAIAB4ADgANgAgAGcAZQB0AF8AdQBzAGUAcgBfAHAAYQBnAGUAcwAgAGIAdQBnAA==
x-cr-puzzleid: {9B16F811-C532-486E-A4C3-F044250DF9A3}
References: <4D416D9A.9010603@huawei.com>
 <4D419416020000780002ECB7@vpn.id2.novell.com> <4D41B90D.5000305@goop.org>
 <4D456139.4090508@redhat.com> <001801cbc0cc$00d98d70$028ca850$@com>
 <4D46F9AE.80606@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<< I'm not sure I follow you here.  The issue with TLB flush IPIs is that
the hypervisor doesn't know the purpose of the IPI and ends up
(potentially) waking up a sleeping VCPU just to flush its tlb - but
since it was sleeping there were no stale TLB entries to flush.>>

That's what I was trying understand, what is "Sleep" here? Is it ACPI sleep
or some internal scheduling state? If vCPUs  are asynchronous to pCPU in
terms of ACPI sleep state, then they need to synced-up. That's where entire
ACPI modeling needs to be considered. That's where KVM may not see this
issue. Maybe I am missing something here.

<< A "few hundred uSecs" is really very slow - that's nearly a
millisecond.  It's worth spending some effort to avoid those kinds of
delays.>>

Actually, just checked IPIs are usually 1000-1500 cycles long (comparable to
VMEXIT). My point is ideal solution should be where virtual platform
behavior is closer to bare metal interrupts, memory, cpu state etc.. How to
do it ? well that's what needs to be figured out :-)

-Kaushik


-----Original Message-----
From: Jeremy Fitzhardinge [mailto:jeremy@goop.org] 
Sent: Monday, January 31, 2011 10:05 AM
To: Kaushik Barde
Cc: 'Avi Kivity'; 'Jan Beulich'; 'Xiaowei Yang'; 'Nick Piggin'; 'Peter
Zijlstra'; fanhenglong@huawei.com; 'Kenneth Lee'; 'linqaingmin';
wangzhenguo@huawei.com; 'Wu Fengguang'; xen-devel@lists.xensource.com;
linux-kernel@vger.kernel.org; 'Marcelo Tosatti'
Subject: Re: One (possible) x86 get_user_pages bug

On 01/30/2011 02:21 PM, Kaushik Barde wrote:
> I agree i.e. deviation from underlying arch consideration is not a good
> idea.
>
> Also, agreed, hypervisor knows which page entries are ready for TLB flush
> across vCPUs. 
>
> But, using above knowledge, along with TLB flush based on IPI is a better
> solution.  Its ability to synchronize it with pCPU based IPI and TLB flush
> across vCPU. is key. 

I'm not sure I follow you here.  The issue with TLB flush IPIs is that
the hypervisor doesn't know the purpose of the IPI and ends up
(potentially) waking up a sleeping VCPU just to flush its tlb - but
since it was sleeping there were no stale TLB entries to flush.

Xen's TLB flush hypercalls can optimise that case by only sending a real
IPI to PCPUs which are actually running target VCPUs.  In other cases,
where a PCPU is known to have stale entries but it isn't running a
relevant VCPU, it can just mark a deferred TLB flush which gets executed
before the VCPU runs again.

In other words, Xen can take significant advantage of getting a
higher-level call ("flush these TLBs") compared just a simple IPI.

Are you suggesting that the hypervisor should export some kind of "known
dirty TLB" table to the guest, and have the guest work out which VCPUs
need IPIs sent to them?  How would that work?

> IPIs themselves should be in few hundred uSecs in terms latency. Also, why
> should pCPU be in sleep state for active vCPU scheduled page workload?

A "few hundred uSecs" is really very slow - that's nearly a
millisecond.  It's worth spending some effort to avoid those kinds of
delays.

    J

> -Kaushik
>
> -----Original Message-----
> From: Avi Kivity [mailto:avi@redhat.com] 
> Sent: Sunday, January 30, 2011 5:02 AM
> To: Jeremy Fitzhardinge
> Cc: Jan Beulich; Xiaowei Yang; Nick Piggin; Peter Zijlstra;
> fanhenglong@huawei.com; Kaushik Barde; Kenneth Lee; linqaingmin;
> wangzhenguo@huawei.com; Wu Fengguang; xen-devel@lists.xensource.com;
> linux-kernel@vger.kernel.org; Marcelo Tosatti
> Subject: Re: One (possible) x86 get_user_pages bug
>
> On 01/27/2011 08:27 PM, Jeremy Fitzhardinge wrote:
>> And even just considering virtualization, having non-IPI-based tlb
>> shootdown is a measurable performance win, since a hypervisor can
>> optimise away a cross-VCPU shootdown if it knows no physical TLB
>> contains the target VCPU's entries.  I can imagine the KVM folks could
>> get some benefit from that as well.
> It's nice to avoid the IPI (and waking up a cpu if it happens to be 
> asleep) but I think the risk of deviating too much from the baremetal 
> arch is too large, as demonstrated by this bug.
>
> (well, async page faults is a counterexample, I wonder if/when it will 
> bite us)
>

