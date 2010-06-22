Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab0FVHPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 03:15:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228Ab0FVHPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 03:15:08 -0400
Message-ID: <4C2062D8.20609@redhat.com>
Date: Tue, 22 Jun 2010 09:14:32 +0200
From: Jes Sorensen <Jes.Sorensen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com
Subject: Re: [PATCH V2 1/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
References: <1277112680.2096.509.camel@ymzhang.sh.intel.com>	 <4C1F50D0.70205@redhat.com> <1277171344.2096.567.camel@ymzhang.sh.intel.com>
In-Reply-To: <1277171344.2096.567.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/10 03:49, Zhang, Yanmin wrote:
> On Mon, 2010-06-21 at 14:45 +0300, Avi Kivity wrote:
>>   Since the guest can use NMI to read the 
>> counter, it should have the highest possible priority, and thus it 
>> shouldn't see any overflow unless it configured the threshold really low.
>>
>> If we drop overflow, we can use the RDPMC instruction instead of 
>> KVM_PERF_OP_READ.  This allows the guest to allow userspace to read a 
>> counter, or prevent userspace from reading the counter, by setting cr4.pce.
> 1) para virt perf interface is to hide PMU hardware in host os. Guest os shouldn't
> access PMU hardware directly. We could expose PMU hardware to guest os directly, but
> that would be another guest os PMU support method. It shouldn't be a part of para virt
> interface.
> 2) Consider below scenario: PMU counter overflows and NMI causes guest os vmexit to
> host kernel. Host kernel schedules the vcpu thread to another physical cpu before
> vmenter the guest os again. So later on, guest os just RDPMC the counter on another
> cpu.
> 
> So I think above discussion is around how to expose PMU hardware to guest os. I will
> also check this method after the para virt interface is done.

You should be able to expose the counters as read-only to the guest. KVM
allows you to specify whether or not a guest has read, write or
read/write access. If you allowed read access of the counters that would
safe a fair bit of hyper calls.

Question is if it is safe to drop overflow support?

Cheers,
Jes

