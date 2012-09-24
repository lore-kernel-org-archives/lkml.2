Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab2IXOUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:20:05 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48137 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2IXOUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:20:03 -0400
Message-ID: <50606B33.1040102@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2012 19:46:19 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <1348486479.11847.46.camel@twins> <50604988.2030506@linux.vnet.ibm.com> <1348490165.11847.58.camel@twins> <50606050.309@linux.vnet.ibm.com> <1348494895.11847.64.camel@twins>
In-Reply-To: <1348494895.11847.64.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092414-3568-0000-0000-000002818335
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 07:24 PM, Peter Zijlstra wrote:
> On Mon, 2012-09-24 at 18:59 +0530, Raghavendra K T wrote:
>> However Rik had a genuine concern in the cases where runqueue is not
>> equally distributed and lockholder might actually be on a different run
>> queue but not running.
>
> Load should eventually get distributed equally -- that's what the
> load-balancer is for -- so this is a temporary situation.
>
> We already try and favour the non running vcpu in this case, that's what
> yield_to_task_fair() is about. If its still not eligible to run, tough
> luck.

Yes, I agree.

>
>> Do you think instead of using rq->nr_running, we could get a global
>> sense of load using avenrun (something like avenrun/num_onlinecpus)
>
> To what purpose? Also, global stuff is expensive, so you should try and
> stay away from it as hard as you possibly can.

Yes, that concern only had made me to fall back to rq->nr_running.

Will come back with the result soon.

