Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab2AQC2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:28:20 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:46881 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2AQC2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:28:18 -0500
Message-ID: <4F14DCBB.3060207@linux.vnet.ibm.com>
Date: Tue, 17 Jan 2012 10:28:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: improve trace events of vmexit/mmio/ioport
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F13EE9B.9020901@linux.vnet.ibm.com> <4F13EFFB.90706@redhat.com>
In-Reply-To: <4F13EFFB.90706@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011702-9574-0000-0000-000000F8C97D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 05:38 PM, Avi Kivity wrote:

> On 01/16/2012 11:32 AM, Xiao Guangrong wrote:
>> - trace vcpu_id for these events
> 
> We can infer the vcpu id from the kvm_entry tracepoints, no?
> 


Thanks for your review, Avi!

Hmm. i think it is hard to do since the vcpu thread can be scheduled
anytime, one example is as follow:

CPU 0

kvm_entry vcpu 0
......
kvm_entry vcpu 1
......
event1 occurs
......
event2 occurs

It is hard to know the event belong to which kvm_entry?

>> - add kvm_mmio_done to trace the time when mmio/ioport emulation is completed
> 
> ditto?
> 


I think is ok to get the event end time by using kvm_entry.

> 
> Relying on the existing tracepoints will make the tool work on older
> kernels.
> 


We can drop all new events, but unfortunately, the information of the origin
tracepoints is not enough, at least vcpu_id need be traced in theses events
to match its events. Yes?

