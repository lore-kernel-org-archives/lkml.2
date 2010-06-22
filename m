Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab0FVLBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 07:01:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab0FVLB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 07:01:29 -0400
Message-ID: <4C2097F4.1080402@redhat.com>
Date: Tue, 22 Jun 2010 14:01:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jes Sorensen <Jes.Sorensen@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com
Subject: Re: [PATCH V2 1/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
References: <1277112680.2096.509.camel@ymzhang.sh.intel.com>	 <4C1F50D0.70205@redhat.com>	 <1277171344.2096.567.camel@ymzhang.sh.intel.com>	 <4C2062D8.20609@redhat.com>	 <1277192873.2096.690.camel@ymzhang.sh.intel.com>	 <1277193305.1875.537.camel@laptop>  <4C206D8B.4080105@redhat.com>	 <1277198943.2096.724.camel@ymzhang.sh.intel.com>	 <1277199060.1875.675.camel@laptop>  <4C2084BB.3040501@redhat.com>	 <1277200010.1875.692.camel@laptop>  <4C20882C.80709@redhat.com>	 <1277200942.1875.694.camel@laptop>  <4C208B09.9030003@redhat.com> <1277201428.1875.696.camel@laptop>
In-Reply-To: <1277201428.1875.696.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2010 01:10 PM, Peter Zijlstra wrote:
> On Tue, 2010-06-22 at 13:06 +0300, Avi Kivity wrote:
>
>    
>> You have a set of MSRs for real hardware (actually several sets)
>> discoverable by cpuid bits.  You have another set of MSRs, using other
>> indexes, discoverable by more CPUID bits.
>>
>> The new MSR indexes will always #GP on real hardware, but will be
>> trapped and serviced by kvm.  In effect kvm will pretend to have a
>> hardware-like PMU but done according to its own specifications.
>>      
> So what's the point?

We already have infrastructure for save/restore around MSRs.  They are 
state-based (as opposed to function-based hypercalls), so it's easy to 
live migrate by copying the MSR values.

> I thought the whole MSR interface thing was purely
> to let other-o$ play with the PMU, but if you move it around like that
> and make it KVM specific, nobody will find it...
>    

Other-os support will be achieved by emulating an existing interface.

-- 
error compiling committee.c: too many arguments to function

