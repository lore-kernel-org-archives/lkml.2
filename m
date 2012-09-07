Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343Ab2IGJ53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:57:29 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:43864 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab2IGJ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:57:27 -0400
Message-ID: <5049C4D7.50101@linux.vnet.ibm.com>
Date: Fri, 07 Sep 2012 17:56:39 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 12/12] KVM: indicate readonly access fault
References: <5032F8FD.2020306@linux.vnet.ibm.com> <5032FA78.9040405@linux.vnet.ibm.com> <5034CB60.30107@redhat.com> <5034D4E3.2080801@linux.vnet.ibm.com> <5048AE96.3050909@redhat.com>
In-Reply-To: <5048AE96.3050909@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12090709-4790-0000-0000-0000047F9FFC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 10:09 PM, Avi Kivity wrote:
> On 08/22/2012 03:47 PM, Xiao Guangrong wrote:
>> On 08/22/2012 08:06 PM, Avi Kivity wrote:
>>> On 08/21/2012 06:03 AM, Xiao Guangrong wrote:
>>>> Introduce write_readonly_mem in mmio-exit-info to indicate this exit is
>>>> caused by write access on readonly memslot
>>>
>>> Please document this in chapter 5 of apic.txt.
>>>
>>
>> Okay, please review this one.
>>
>> Subject: [PATCH v6 12/12] KVM: indicate readonly access fault
>>
>> Introduce write_readonly_mem in mmio-exit-info to indicate this exit is
>> caused by write access on readonly memslot
>>
> 
> I'm not sure whether this indication can be trusted by userspace.  By
> the time userspace gets to process this, the slot may no longer exist,
> or it may be writable.

The case of deleting memslot is ok, because userspace just skips this fault
if no readonly mem or no fault handler can be found.

Switching memslot from readonly to writable sounds strange, i agree with you
that this flag is untrusty under this case.

Marcelo, any comments?

> 
> (in the same way an mmio exit might actually hit RAM)

So, in the userspace, for the safe reason, we should walk all memslots not
just walking mmio handlers?

