Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0LIK2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:28:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932Ab0LIK2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:28:49 -0500
Message-ID: <4D00AF3C.40603@redhat.com>
Date: Thu, 09 Dec 2010 12:28:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 3/3] kvm: use yield_to instead of sleep in kvm_vcpu_on_spin
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101202144516.45a0385d@annuminas.surriel.com> <4CFB8BFA.4040100@redhat.com> <4D0008D5.1040102@redhat.com>
In-Reply-To: <4D0008D5.1040102@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 12:38 AM, Rik van Riel wrote:
>
>>> - /* Sleep for 100 us, and hope lock-holder got scheduled */
>>> - expires = ktime_add_ns(ktime_get(), 100000UL);
>>> - schedule_hrtimeout(&expires, HRTIMER_MODE_ABS);
>>> + if (first_round&& last_boosted_vcpu == kvm->last_boosted_vcpu) {
>>> + /* We have not found anyone yet. */
>>> + first_round = 0;
>>> + goto again;
>>
>> Need to guarantee termination.
>
> We do that by setting first_round to 0 :)
>
> We at most walk N+1 VCPUs in a VM with N VCPUs, with
> this patch.
>

Right.  May be clearer by using a for () loop instead of the goto.

-- 
error compiling committee.c: too many arguments to function

