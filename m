Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab0FVJyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 05:54:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab0FVJyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 05:54:18 -0400
Message-ID: <4C20882C.80709@redhat.com>
Date: Tue, 22 Jun 2010 12:53:48 +0300
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
References: <1277112680.2096.509.camel@ymzhang.sh.intel.com>	 <4C1F50D0.70205@redhat.com>	 <1277171344.2096.567.camel@ymzhang.sh.intel.com>	 <4C2062D8.20609@redhat.com>	 <1277192873.2096.690.camel@ymzhang.sh.intel.com>	 <1277193305.1875.537.camel@laptop>  <4C206D8B.4080105@redhat.com>	 <1277198943.2096.724.camel@ymzhang.sh.intel.com>	 <1277199060.1875.675.camel@laptop>  <4C2084BB.3040501@redhat.com> <1277200010.1875.692.camel@laptop>
In-Reply-To: <1277200010.1875.692.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2010 12:46 PM, Peter Zijlstra wrote:
>
>> Avi's suggestion of using virtual MSRs makes a ton of sense for this
>> though, and it makes it possible to switch direct access on/off for the
>> cases where direct access is possible, and go emulated when it isn't.
>>      
> /me has no clue what virtual MSRs are,

MSRs that are not defined by the hardware, but instead by the hypervisor.

> but yeah, that sounds about
> right. Anyway, the generic case is full trap and emulate get that
> working first, then try and be smart and avoid some traps.
>    

I doubt we can avoid traps for the paravirt PMU since the counter 
indexes will not match.

When emulating the hardware PMU we can be clever at times and allow 
RDPMC not to trap.

-- 
error compiling committee.c: too many arguments to function

