Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab2EJDlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:41:44 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:51094 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab2EJDln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:41:43 -0400
Message-ID: <4FAB38ED.5050200@linux.vnet.ibm.com>
Date: Thu, 10 May 2012 11:41:33 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Diwakar Tundlam <dtundlam@nvidia.com>, "'Ingo Molnar'" <mingo@kernel.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH] sched: Make nr_uninterruptible count a signed value
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10C@HQMAIL04.nvidia.com> <1336514192.8226.52.camel@twins> <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10D@HQMAIL04.nvidia.com> <1336516020.8226.57.camel@twins> <1336516174.8226.59.camel@twins> <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10E@HQMAIL04.nvidia.com> <1336551100.27020.84.camel@laptop>
In-Reply-To: <1336551100.27020.84.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12051003-8256-0000-0000-0000026107DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 04:11 PM, Peter Zijlstra wrote:

> On Tue, 2012-05-08 at 15:46 -0700, Diwakar Tundlam wrote:
>> Maybe it is an artifact of 32-bit machine displaying 64-bit print format.
>> An (unsigned long)(-24) promoted to (signed long long) ends up as 4294967272.
>> As seen in my output of sched_debug.
> 
> Ah, quite possible. %Ld is indeed %lld and the value is long, not long
> long. So the proper fix is to fudge that printk statement somehow.


Could we use SEQ_printf for nr_uninterruptible, just like we did on
rq->load.weight?

Regards,
Michael Wang

> 
>> Your machine is probably natively 64-bit. 
> 
> Yeah, I gave up on 32bit computing a while ago..
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


