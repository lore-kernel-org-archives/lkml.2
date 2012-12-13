Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab2LMDKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 22:10:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:52406 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836Ab2LMDKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 22:10:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,270,1355126400"; 
   d="scan'208";a="230833352"
Message-ID: <50C9467F.3020205@intel.com>
Date: Thu, 13 Dec 2012 11:07:43 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@linux.intel.com>,
        Alex Shi <lkml.alex@gmail.com>, rob@landley.net, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        andre.przywara@amd.com, rjw@sisk.pl, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        vincent.guittot@linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/18] sched: simplified fork, enable load average into
 LB and power awareness scheduling
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <CAGjg+kGAokK0oOAOJL=apkcyi_deqtHHsaJCViCz9tOMKG56bw@mail.gmail.com> <50C722AC.3080806@intel.com> <20121211154819.GC8873@liondog.tnic> <50C75935.1040004@linux.intel.com> <20121211161320.GA28827@liondog.tnic> <50C76208.107@linux.intel.com> <20121212144140.GD8760@liondog.tnic>
In-Reply-To: <20121212144140.GD8760@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> now, on the other hand, if you have two threads of a process that
>> share a bunch of data structures, and you'd spread these over 2
>> sockets, you end up bouncing data between the two sockets a lot,
>> running inefficient --> bad for power.
> 
> Yeah, that should be addressed by the NUMA patches people are working on
> right now.


Yes, as to balance/powersaving policy, we can tight pack tasks firstly,
then NUMA balancing will make memory follow us.

BTW, NUMA balancing is more related with page in memory. not LLC.
> 
>> having said all this, if you have to tasks that don't have such
>> cache effects, the most efficient way of running things will be on 2
>> hyperthreading halves... it's very hard to beat the power efficiency
>> of that. But this assumes the tasks don't compete with resources much
>> on the HT level, and achieve good scaling. and this still has to
>> compete with "race to halt", because if you're done quicker, you can
>> put the memory in self refresh quicker.
> 
> Right, how are we addressing the breakeven in that case? AFAIK, we
> do schedule them now on two different cores (not HT threads, i.e. no
> resource sharing besides L2) so that we get done faster, i.e. race to

that's balance policy for. :)
> idle in the performance case. And in the powersavings' case we leave
> them as tightly packed as possible.
> 

