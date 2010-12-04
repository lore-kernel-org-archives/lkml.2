Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0LDNDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 08:03:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab0LDNDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 08:03:04 -0500
Message-ID: <4CFA3BE7.4050905@redhat.com>
Date: Sat, 04 Dec 2010 08:02:31 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: vatsa@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
References: <20101202144129.4357fe00@annuminas.surriel.com>	 <20101202144423.3ad1908d@annuminas.surriel.com>	 <1291382619.32004.2124.camel@laptop>	 <20101203133056.GF27994@linux.vnet.ibm.com>	 <1291385010.32004.2165.camel@laptop>	 <20101203140607.GA9800@linux.vnet.ibm.com>	 <20101203141037.GE16411@linux.vnet.ibm.com> <1291411391.2032.4.camel@laptop>
In-Reply-To: <1291411391.2032.4.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 04:23 PM, Peter Zijlstra wrote:
> On Fri, 2010-12-03 at 19:40 +0530, Srivatsa Vaddagiri wrote:
>> On Fri, Dec 03, 2010 at 07:36:07PM +0530, Srivatsa Vaddagiri wrote:
>>> On Fri, Dec 03, 2010 at 03:03:30PM +0100, Peter Zijlstra wrote:
>>>> No, because they do receive service (they spend some time spinning
>>>> before being interrupted), so the respective vruntimes will increase, at
>>>> some point they'll pass B0 and it'll get scheduled.
>>>
>>> Is that sufficient to ensure that B0 receives its fair share (1/3 cpu in this
>>> case)?
>>
>> Hmm perhaps yes, althought at cost of tons of context switches, which would be
>> nice to minimize on?
>
> Don't care, as long as the guys calling yield_to() pay for that time its
> their problem.

Also, the context switches are cheaper than spinning
entire time slices on spinlocks we're not going to get
(because the VCPU holding the lock is not running).

-- 
All rights reversed
