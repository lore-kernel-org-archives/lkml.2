Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab2FDQzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:55:10 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37897 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab2FDQyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:54:10 -0400
Message-ID: <4FCCE7FB.3000301@linux.vnet.ibm.com>
Date: Mon, 04 Jun 2012 22:23:15 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Sam Ravnborg <sam@ravnborg.org>, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        yong.zhang0@gmail.com, akpm@linux-foundation.org,
        vatsa@linux.vnet.ibm.com, rjw@sisk.pl, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikunj@linux.vnet.ibm.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH 01/27] smpboot: Provide a generic method to boot secondary
 processors
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091008.31979.93586.stgit@srivatsabhat.in.ibm.com> <20120601165113.GA18870@merkur.ravnborg.org> <4FC9424E.9060009@linux.vnet.ibm.com> <alpine.LFD.2.02.1206041228330.3086@ionos> <4FCCB31B.6060302@linux.vnet.ibm.com> <alpine.LFD.2.02.1206041513000.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206041513000.3086@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12060406-7014-0000-0000-000001522F51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 06:48 PM, Thomas Gleixner wrote:

> On Mon, 4 Jun 2012, Srivatsa S. Bhat wrote:
>> On 06/04/2012 04:02 PM, Thomas Gleixner wrote:
>> I can add the prototype w/o the __weak prefix and the #ifndef magic in
>> include/linux/smpboot.h (which I will, and include it in v2).
>>
>> However, I can't get rid of the #ifndef magic in kernel/smpboot.c because
>> it will cause build failures on x86.
>>
>> I addressed this same issue in another email:
>> https://lkml.org/lkml/2012/6/3/33
> 
>> In short, to avoid breaking build on x86.
>> We wanted to follow the x86 convention of having static inline functions in
>> arch/x86/include/asm/smp.h and use the smp_ops structure to route the calls
>> to x86 or xen as appropriate (see patch 4 in this series).
> 
> Oh no. That's not really a good argument.
> 
> There is no reason why this _must_ be an inline function on x86. It
> can be a proper function in arch/x86/kernel/smpboot.c as well.
> 


Ok, I'll adopt this approach.

> The alternative solution is to generalize the smp_ops approach and get
> rid of the weak implementations completely.
> 


Ok, but this would mean changes to all architectures, which could be avoided.

One reason why x86 uses that smp_ops structure is because it decides the
implementation routines between x86 and xen at run-time. Such requirements don't
exist on other architectures, from what I saw (except sparc32).

So I'll stick with the former approach of adding a proper function for x86, and
retaining the default weak implementations in kernel/smpboot.c.
 
Regards,
Srivatsa S. Bhat

