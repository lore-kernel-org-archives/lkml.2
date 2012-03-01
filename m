Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab2CAJ4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:56:42 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:51705 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758791Ab2CAJ4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:56:40 -0500
Message-ID: <4F4F47CA.2060900@linux.vnet.ibm.com>
Date: Thu, 01 Mar 2012 15:26:26 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <ak@linux.intel.com>, linux-fsdevel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, mc@linux.vnet.ibm.com
Subject: Re: [PATCH] cpumask: fix lg_lock/br_lock.
References: <87ehtf3lqh.fsf@rustcorp.com.au> <20120227155338.7b5110cd.akpm@linux-foundation.org> <20120228084359.GJ21106@elte.hu> <20120228132719.f375071a.akpm@linux-foundation.org> <4F4DBB26.2060907@linux.vnet.ibm.com> <20120229091732.GA11505@elte.hu> <4F4E083A.2080304@linux.vnet.ibm.com> <20120301073845.GA5350@elte.hu> <4F4F3E16.5080703@linux.vnet.ibm.com> <20120301094529.GA366@elte.hu>
In-Reply-To: <20120301094529.GA366@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12030109-8878-0000-0000-0000018052BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 03:15 PM, Ingo Molnar wrote:

> 
> * Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> 
>> We wanted to avoid doing for_each_possible_cpu() to avoid the 
>> unnecessary performance hit. [...]
> 
> That was done at the cost of making the code rather complex.
>


Sadly, yes..

 
> The thing is, *ANY* cpu-mask loop is an utter slowpath, so the 
> "performance hit" is an overstatement. There's already dozens of 
> of for_each_possible_cpu() loops in the kernel, and it's a 
> perfectly acceptable solution in such cases.
> 
> I suspect it does not matter much now as the code appears to be 
> correct, but in general we want to opt for simpler designs for 
> rare and fragile codepaths.
> 


Ok, makes sense. And now looking back at the amount of complexity
we built into this just to avoid the for_each_possible_cpu() loop,
I wonder why we went to such lengths at all! (considering what you
said above about any cpu-mask loop..)

Regards,
Srivatsa S. Bhat

