Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab0DSLfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 07:35:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab0DSLfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 07:35:48 -0400
Message-ID: <4BCC4006.8000501@redhat.com>
Date: Mon, 19 Apr 2010 14:35:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>	 <1271356648-5108-2-git-send-email-glommer@redhat.com>	 <4BCA026D.3070309@redhat.com>  <1271673975.1674.763.camel@laptop>	 <1271674154.1674.771.camel@laptop>  <4BCC3617.6050106@redhat.com> <1271674745.1674.802.camel@laptop>
In-Reply-To: <1271674745.1674.802.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 01:59 PM, Peter Zijlstra wrote:
>
>> So what do we need?  test for both TSC_RELIABLE and NONSTOP_TSC?  IMO
>> TSC_RELIABLE should imply NONSTOP_TSC.
>>      
> Yeah, I think RELIABLE does imply NONSTOP and CONSTANT, but NONSTOP&&
> CONSTANT does not make RELIABLE.
>    

The manual says:

> 16.11.1 Invariant TSC
>
> The time stamp counter in newer processors may support an enhancement, 
> referred
> to as invariant TSC. Processor’s support for invariant TSC is indicated by
> CPUID.80000007H:EDX[8].
> The invariant TSC will run at a constant rate in all ACPI P-, C-. and 
> T-states. This is
> the architectural behavior moving forward. On processors with 
> invariant TSC
> support, the OS may use the TSC for wall clock timer services (instead 
> of ACPI or
> HPET timers). TSC reads are much more efficient and do not incur the 
> overhead
> associated with a ring transition or access to a platform resource.

and this maps to NONSTOP, so I think we're fine.

-- 
error compiling committee.c: too many arguments to function

