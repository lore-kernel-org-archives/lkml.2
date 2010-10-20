Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab0JTQDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:03:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:12039 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab0JTQDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:03:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,356,1283756400"; 
   d="scan'208";a="669186221"
Message-ID: <4CBF12CB.9050604@linux.intel.com>
Date: Wed, 20 Oct 2010 09:03:23 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Trinabh Gupta <trinabh@linux.vnet.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>, peterz@infradead.org,
        lenb@kernel.org, suresh.b.siddha@intel.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC V1] cpuidle: add idle routine registration and cleanup pm_idle
 pointer
References: <20101019183522.17992.86937.stgit@tringupt.in.ibm.com> <4CBDE5AB.4040401@linux.intel.com> <AANLkTi=cetw_mdp_3s+T4OxTfcMT2u4cdVPKxOp7jbVU@mail.gmail.com> <4CBDEB14.2030304@linux.vnet.ibm.com> <4CBF06D5.7020508@linux.vnet.ibm.com> <4CBF0854.6080903@linux.intel.com> <4CBF0C04.5070705@linux.intel.com>
In-Reply-To: <4CBF0C04.5070705@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/20/2010 8:34 AM, Andi Kleen wrote:
>
>> but now you're duplicating this functionality adding code for everyone.
>>
>> 99.999% of the people today run cpuidle... (especially embedded x86 
>> where they really care about power)
>> all x86 going forward also has > 1 idle option anyway.
>>
>> and you're adding and extra layer in the middle that just duplicates 
>> the layer that's in use in practice above it.
>>
>> seriously, this sounds like the wrong tradeoff to make.
>
> I think the right option is still to put cpuidle on a diet.
> There's no reason an idle handler needs to be that bloated.
>
> If it was 2K or so just including it into the core would be fine.
>
> Ignoring code size completely is generally a wrong trade off imho.

I'm not ignoring code size.
I'm saying that a 7Kb component that everyone on this architecture uses 
in practice versus adding 0.5Kb in ADDITION to that for everyone for the 
theoretical case
of someone NOT using cpuidle is the wrong tradeoff.

having it go on a diet? I'm all for it. Killing off the ladder governor 
for example is a step.
But really. 7Kb. There's lots of lower hanging fruit as well. 7Kb is not 
a reason to make such a bad tradeoff.

