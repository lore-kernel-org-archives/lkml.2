Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0LEMlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 07:41:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab0LEMlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 07:41:10 -0500
Message-ID: <4CFB8842.4010003@redhat.com>
Date: Sun, 05 Dec 2010 14:40:34 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Chris Wright <chrisw@sous-sol.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/3] kvm: keep track of which task is running a KVM
 vcpu
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101202144324.4a79263b@annuminas.surriel.com> <20101203011810.GV10050@sequoia.sous-sol.org> <4CF903A6.5050209@redhat.com>
In-Reply-To: <4CF903A6.5050209@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 04:50 PM, Rik van Riel wrote:
> On 12/02/2010 08:18 PM, Chris Wright wrote:
>> * Rik van Riel (riel@redhat.com) wrote:
>>> Keep track of which task is running a KVM vcpu.  This helps us
>>> figure out later what task to wake up if we want to boost a
>>> vcpu that got preempted.
>>>
>>> Unfortunately there are no guarantees that the same task
>>> always keeps the same vcpu, so we can only track the task
>>> across a single "run" of the vcpu.
>>
>> So shouldn't it confine to KVM_RUN?  The other vcpu_load callers aren't
>> always a vcpu in a useful runnable state.
>
> Yeah, probably.  If you want I can move the setting of
> vcpu->task to kvm_vcpu_ioctl.
>

No need, it's not like something bad will happen.

What I'd really like to see is a soft binding between a vcpu and its 
thread, so directed yield works even if we're in qemu while we were 
scheduled out.  In fact it's not an unlikely pattern:

   spin_lock(&lock)
   ...
   writel(some_port_handled_by_qemu)
   ...
   spin_unlock(&lock)

but that can wait.

-- 
error compiling committee.c: too many arguments to function

