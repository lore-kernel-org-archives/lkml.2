Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab2F1W5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 18:57:03 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:36216 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab2F1W5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 18:57:00 -0400
From: "Vinod, Chegu" <chegu_vinod@hp.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Jones <drjones@redhat.com>
CC: Rik van Riel <riel@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>
Date: Thu, 28 Jun 2012 23:55:54 +0100
Subject: RE: [PATCH] kvm: handle last_boosted_vcpu = 0 case
Thread-Topic: [PATCH] kvm: handle last_boosted_vcpu = 0 case
Thread-Index: Ac1VSnX5gsZdDJc5SbynXrzHOFihywABcMgw
Message-ID: <C4FA8004DBDF864387014E5EA4383B0F580BD0F5E7@GVW1336EXC.americas.hpqcorp.net>
References: <168f205d-d65f-4864-99c8-363b12818a9b@zmail17.collab.prod.int.phx2.redhat.com>
 <4FEC84BD.6030304@linux.vnet.ibm.com>
In-Reply-To: <4FEC84BD.6030304@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5SMvEs3023396

Hello,

I am just catching up on this email thread... 

Perhaps one of you may be able to help answer this query.. preferably along with some data.  [BTW, I do understand the basic intent behind PLE in a typical [sweet spot] use case where there is over subscription etc. and the need to optimize the PLE handler in the host etc. ]

In a use case where the host has fewer but much larger guests (say 40VCPUs and higher) and there is no over subscription (i.e. # of vcpus across guests <= physical cpus in the host  and perhaps each guest has their vcpu's pinned to specific physical cpus for other reasons), I would like to understand if/how  the PLE really helps ?  For these use cases would it be ok to turn PLE off (ple_gap=0) since is no real need to take an exit and find some other VCPU to yield to ? 

Thanks
Vinod

-----Original Message-----
From: Raghavendra K T [mailto:raghavendra.kt@linux.vnet.ibm.com] 
Sent: Thursday, June 28, 2012 9:22 AM
To: Andrew Jones
Cc: Rik van Riel; Marcelo Tosatti; Srikar; Srivatsa Vaddagiri; Peter Zijlstra; Nikunj A. Dadhania; KVM; LKML; Gleb Natapov; Vinod, Chegu; Jeremy Fitzhardinge; Avi Kivity; Ingo Molnar
Subject: Re: [PATCH] kvm: handle last_boosted_vcpu = 0 case

On 06/28/2012 09:30 PM, Andrew Jones wrote:
>
>
> ----- Original Message -----
>> In summary, current PV has huge benefit on non-PLE machine.
>>
>> On PLE machine, the results become very sensitive to load, type of 
>> workload and SPIN_THRESHOLD. Also PLE interference has significant 
>> effect on them. But still it has slight edge over non PV.
>>
>
> Hi Raghu,
>
> sorry for my slow response. I'm on vacation right now (until the 9th 
> of July) and I have limited access to mail.

Ok. Happy Vacation :)

Also, thanks for
> continuing the benchmarking. Question, when you compare PLE vs.
> non-PLE, are you using different machines (one with and one without), 
> or are you disabling its use by loading the kvm module with the 
> ple_gap=0 modparam as I did?

Yes, I am doing the same when I say with PLE disabled and comparing the benchmarks (i.e loading kvm module with ple_gap=0).

But older non-PLE results were on a different machine altogether. (I had limited access to PLE machine).


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
