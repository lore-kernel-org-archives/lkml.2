Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab2IURko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:40:44 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47477 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2IURkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:40:41 -0400
Message-ID: <505CA5BA.4020801@linux.vnet.ibm.com>
Date: Fri, 21 Sep 2012 23:06:58 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Chegu Vinod <chegu_vinod@hp.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <505C691D.4080801@hp.com>
In-Reply-To: <505C691D.4080801@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092117-7014-0000-0000-000001EDE5ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 06:48 PM, Chegu Vinod wrote:
> On 9/21/2012 4:59 AM, Raghavendra K T wrote:
>> In some special scenarios like #vcpu <= #pcpu, PLE handler may
>> prove very costly,
>
> Yes.
>> because there is no need to iterate over vcpus
>> and do unsuccessful yield_to burning CPU.
>>
>> An idea to solve this is:
>> 1) As Avi had proposed we can modify hardware ple_window
>> dynamically to avoid frequent PL-exit.
>
> Yes. We had to do this to get around some scaling issues for large
> (>20way) guests (with no overcommitment)

Do you mean you already have some solution tested for this?

>
> As part of some experimentation we even tried "switching off" PLE too :(
>

Honestly,
Your this experiment and Andrew Theurer's observations were the
motivation for this patch.

>
>
>> (IMHO, it is difficult to
>> decide when we have mixed type of VMs).
>
> Agree.
>
> Not sure if the following alternatives have also been looked at :
>
> - Could the behavior associated with the "ple_window" be modified to be
> a function of some [new] per-guest attribute (which can be conveyed to
> the host as part of the guest launch sequence). The user can choose to
> set this [new] attribute for a given guest. This would help avoid the
> frequent exits due to PLE (as Avi had mentioned earlier) ?

Ccing Drew also. We had a good discussion on this idea last time.
(sorry that I forgot to include in patch series)

May be a good idea when we know the load in advance..

>
> - Can the PLE feature ( in VT) be "enhanced" to be made a per guest
> attribute ?
>
>
> IMHO, the approach of not taking a frequent exit is better than taking
> an exit and returning back from the handler etc.

I entirely agree on this point. (though have not tried above
approaches). Hope to see more expert opinions pouring in.

