Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab0LCOut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:50:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758556Ab0LCOur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:50:47 -0500
Message-ID: <4CF903A6.5050209@redhat.com>
Date: Fri, 03 Dec 2010 09:50:14 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/3] kvm: keep track of which task is running a KVM
 vcpu
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101202144324.4a79263b@annuminas.surriel.com> <20101203011810.GV10050@sequoia.sous-sol.org>
In-Reply-To: <20101203011810.GV10050@sequoia.sous-sol.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2010 08:18 PM, Chris Wright wrote:
> * Rik van Riel (riel@redhat.com) wrote:
>> Keep track of which task is running a KVM vcpu.  This helps us
>> figure out later what task to wake up if we want to boost a
>> vcpu that got preempted.
>>
>> Unfortunately there are no guarantees that the same task
>> always keeps the same vcpu, so we can only track the task
>> across a single "run" of the vcpu.
>
> So shouldn't it confine to KVM_RUN?  The other vcpu_load callers aren't
> always a vcpu in a useful runnable state.

Yeah, probably.  If you want I can move the setting of
vcpu->task to kvm_vcpu_ioctl.

-- 
All rights reversed
