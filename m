Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2AQRcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:32:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46387 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2AQRcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:32:02 -0500
Message-ID: <4F15B08D.5090000@gmail.com>
Date: Tue, 17 Jan 2012 10:31:57 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: improve trace events of vmexit/mmio/ioport
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F13EE9B.9020901@linux.vnet.ibm.com> <4F13EFFB.90706@redhat.com> <4F14DCBB.3060207@linux.vnet.ibm.com> <20120117115558.GB17420@amt.cnet>
In-Reply-To: <20120117115558.GB17420@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 04:55 AM, Marcelo Tosatti wrote:
> On Tue, Jan 17, 2012 at 10:28:11AM +0800, Xiao Guangrong wrote:
>> On 01/16/2012 05:38 PM, Avi Kivity wrote:
>>
>>> On 01/16/2012 11:32 AM, Xiao Guangrong wrote:
>>>> - trace vcpu_id for these events
>>>
>>> We can infer the vcpu id from the kvm_entry tracepoints, no?
>>>
>>
>>
>> Thanks for your review, Avi!
>>
>> Hmm. i think it is hard to do since the vcpu thread can be scheduled
>> anytime, one example is as follow:
>>
>> CPU 0
>>
>> kvm_entry vcpu 0
>> ......
>> kvm_entry vcpu 1
>> ......
>> event1 occurs
>> ......
>> event2 occurs
>>
>> It is hard to know the event belong to which kvm_entry?
>>
>>>> - add kvm_mmio_done to trace the time when mmio/ioport emulation is completed
>>>
>>> ditto?
>>>
>>
>>
>> I think is ok to get the event end time by using kvm_entry.
>>
>>>
>>> Relying on the existing tracepoints will make the tool work on older
>>> kernels.
>>>
>>
>>
>> We can drop all new events, but unfortunately, the information of the origin
>> tracepoints is not enough, at least vcpu_id need be traced in theses events
>> to match its events. Yes?
> 
> Yes, and if you don't add completed events, you'll have to use kvm_entry 
> whose collection adds a lot of overhead.


vcpus run as threads and hence have their own tid which is available in
the perf samples.

There is an ongoing 'discussion' about modifying existing tracepoints
which your proposed patch violates. This is the start of it:

https://lkml.org/lkml/2012/1/16/41

David
