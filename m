Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2ARCcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 21:32:22 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:40002 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab2ARCcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 21:32:20 -0500
Message-ID: <4F162F28.4010001@linux.vnet.ibm.com>
Date: Wed, 18 Jan 2012 10:32:08 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: improve trace events of vmexit/mmio/ioport
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F13EE9B.9020901@linux.vnet.ibm.com> <4F13EFFB.90706@redhat.com> <4F14DCBB.3060207@linux.vnet.ibm.com> <20120117115558.GB17420@amt.cnet> <4F15B08D.5090000@gmail.com>
In-Reply-To: <4F15B08D.5090000@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011802-8256-0000-0000-000000EC00E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 01:31 AM, David Ahern wrote:


>>>>
>>>> Relying on the existing tracepoints will make the tool work on older
>>>> kernels.
>>>>
>>>
>>>
>>> We can drop all new events, but unfortunately, the information of the origin
>>> tracepoints is not enough, at least vcpu_id need be traced in theses events
>>> to match its events. Yes?
>>
>> Yes, and if you don't add completed events, you'll have to use kvm_entry 
>> whose collection adds a lot of overhead.
> 
> 
> vcpus run as threads and hence have their own tid which is available in
> the perf samples.
> 


Nice, thanks for your information, David!

> There is an ongoing 'discussion' about modifying existing tracepoints
> which your proposed patch violates. This is the start of it:
> 


Hmm, i think we can still add completed tracepoints in the new version kernel,
if old version kernel is used, we can fall back to use kvm_entry instead?

And there is a exception for mmio read, in current code, the mmio read event is
actually used to trace the time when then read emulation is completed, i think
we can add a tracepoint like mmio_read_begin to trace the start time of mmio read.
So:
- for the new kernel, we use mmio_read_begion and kvm_mmio(READ...) to calculate
  start time and end time.
- for the old kernel, we use kvm_exit and kvm_mmio(READ...) to calculate start time
  and end time.

Your idea?

