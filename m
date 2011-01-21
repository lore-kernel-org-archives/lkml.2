Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab1AUOuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:50:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab1AUOuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:50:24 -0500
Message-ID: <4D399CBD.10506@redhat.com>
Date: Fri, 21 Jan 2011 09:48:29 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?UTF-8?B?QW3DqXJpY28g?= =?UTF-8?B?V2FuZw==?= 
	<xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        kvm@vger.kernel.org, suzuki@in.ibm.com
Subject: Re: [PATCH 2/3] kvm hypervisor : Add hypercalls to support pv-ticketlock
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com> <20110119164432.GA30669@linux.vnet.ibm.com> <20110119171239.GB726@linux.vnet.ibm.com> <1295457672.28776.144.camel@laptop> <4D373340.60608@goop.org> <20110120115958.GB11177@linux.vnet.ibm.com> <4D38774B.6070704@goop.org> <20110121140208.GA13609@linux.vnet.ibm.com>
In-Reply-To: <20110121140208.GA13609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2011 09:02 AM, Srivatsa Vaddagiri wrote:
> On Thu, Jan 20, 2011 at 09:56:27AM -0800, Jeremy Fitzhardinge wrote:
>>>   The key here is not to
>>> sleep when waiting for locks (as implemented by current patch-series, which can
>>> put other VMs at an advantage by giving them more time than they are entitled
>>> to)
>>
>> Why?  If a VCPU can't make progress because its waiting for some
>> resource, then why not schedule something else instead?
>
> In the process, "something else" can get more share of cpu resource than its
> entitled to and that's where I was bit concerned. I guess one could
> employ hard-limits to cap "something else's" bandwidth where it is of real
> concern (like clouds).

I'd like to think I fixed those things in my yield_task_fair +
yield_to + kvm_vcpu_on_spin patch series from yesterday.

https://lkml.org/lkml/2011/1/20/403

-- 
All rights reversed
