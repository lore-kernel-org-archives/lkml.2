Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2AXMoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 07:44:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063Ab2AXMoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 07:44:06 -0500
Message-ID: <4F1EA791.1000703@redhat.com>
Date: Tue, 24 Jan 2012 14:44:01 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: improve trace events of vmexit/mmio/ioport
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F13EE9B.9020901@linux.vnet.ibm.com> <4F13EFFB.90706@redhat.com> <4F14DCBB.3060207@linux.vnet.ibm.com>
In-Reply-To: <4F14DCBB.3060207@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 04:28 AM, Xiao Guangrong wrote:
> On 01/16/2012 05:38 PM, Avi Kivity wrote:
>
> > On 01/16/2012 11:32 AM, Xiao Guangrong wrote:
> >> - trace vcpu_id for these events
> > 
> > We can infer the vcpu id from the kvm_entry tracepoints, no?
> > 
>
>
> Thanks for your review, Avi!
>
> Hmm. i think it is hard to do since the vcpu thread can be scheduled
> anytime, one example is as follow:
>
> CPU 0
>
> kvm_entry vcpu 0
> ......
> kvm_entry vcpu 1
> ......
> event1 occurs
> ......
> event2 occurs
>
> It is hard to know the event belong to which kvm_entry?
>

Why is it hard?  Correlate the task IDs.

-- 
error compiling committee.c: too many arguments to function

