Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965039Ab2EWDJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 23:09:42 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:58691 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933520Ab2EWDJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 23:09:25 -0400
Message-ID: <4FBC54DC.5060301@linux.vnet.ibm.com>
Date: Wed, 23 May 2012 11:09:16 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: fix async page fault working for readonly mapping
References: <4FB9E499.2010505@linux.vnet.ibm.com> <20120521080856.GS10209@redhat.com> <4FB9F9B6.50101@linux.vnet.ibm.com> <20120521193041.GA25940@amt.cnet> <20120522053110.GT10209@redhat.com> <4FBBA263.6070600@redhat.com>
In-Reply-To: <4FBBA263.6070600@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052303-5564-0000-0000-000002E21416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 10:27 PM, Avi Kivity wrote:

> On 05/22/2012 08:31 AM, Gleb Natapov wrote:
>> On Mon, May 21, 2012 at 04:30:41PM -0300, Marcelo Tosatti wrote:
>>> On Mon, May 21, 2012 at 04:15:50PM +0800, Xiao Guangrong wrote:
>>>> On 05/21/2012 04:08 PM, Gleb Natapov wrote:
>>>>
>>>>> On Mon, May 21, 2012 at 02:45:45PM +0800, Xiao Guangrong wrote:
>>>>>> If we map a readonly memory space from host to guest and the page is
>>>>>> not currently mapped in the host, we will get a fault-pfn and async
>>>>>> is not allowed, then the vm will crash
>>>>>>
>>>>> Why would we want to map a readonly memory space from host to guest?
>>>>> We may want to do it to support memory semantics on read and mmio on
>>>>> write, but do not right now unless something changed while I was not
>>>>> looking.
>>>>
>>>>
>>>> Some test cases in kvm-unit-tests and the benchmark i am writing for KVM
>>>> need map the function on host to guest.
>>>
>>> Or ROM. Or read-only mappings of IVSHMEM (which don't exist yet).
>> True. KVM should ignore writes to such areas, not kill a guest. Is this
>> how the code works today?
>>
> 
> Right now qemu maps ROM as RAM.  There is no way to tell kvm that
> something is ROM (or ROMD).
> 
> There are two options for that:
> - mprotect() the ROM, and teach kvm about read-only areas (this patch);
> but that doesn't work if we have a read-only and a writable alias of the
> same area
> - add a flag indicating that an area is ROM or ROMD
> 
> I prefer the latter, because of the alias issue.
> 


I agree.

Will post a new patch to do it if other guys do not object it. :)

