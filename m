Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2GONDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 09:03:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab2GONDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 09:03:31 -0400
Message-ID: <5002BF9B.8090306@redhat.com>
Date: Sun, 15 Jul 2012 16:03:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <1341845396.3462.81.camel@twins> <4FFAEFF1.9000706@redhat.com> <1341845999.3462.86.camel@twins> <4FFCBD00.1030109@gmail.com> <20120711071006.GF23898@redhat.com> <1342000187.3462.134.camel@twins> <20120711095337.GJ23898@redhat.com> <4FFE4E8D.90606@gmail.com> <20120712042923.GG7298@redhat.com> <4FFEEB55.5070009@gmail.com> <20120712160634.GI7298@redhat.com> <50027A36.9070509@redhat.com> <5002BEE3.5060506@gmail.com>
In-Reply-To: <5002BEE3.5060506@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2012 04:00 PM, David Ahern wrote:
> On 7/15/12 2:07 AM, Avi Kivity wrote:
>> On 07/12/2012 07:06 PM, Gleb Natapov wrote:
>>>>
>>>> Note the :pH this time.
>>> I am not sure what perf kvm does with :pH modifier, but H modifier does
>>> not make sense with perf kvm and should be reported as an error by
>>> perf tool.
>>
>> Maybe it should refer to the guest vs. the nested guest...
> 
> :H = host mode; you are thinking of :h for hypervisor mode. From
> perf-list documentation:
> 
> "Modifiers allow the user to restrict when events are
> counted with 'u' for user-space, 'k' for kernel, 'h' for hypervisor.
> Additional modifiers are 'G' for guest counting (in KVM guests) and 'H'
> for host counting (not in KVM guests)."

No, it's an additional distinction.  A kvm guest can be in kernel mode,
user mode, or in a nested guest mode (which has its own user mode and
kernel mode).  Currently we have no way of distinguishing between guest
kernel mode and nested guest kernel mode.

I assume 'h' means profiling the hypervisor from a guest (i.e. xen dom0)?

-- 
error compiling committee.c: too many arguments to function


