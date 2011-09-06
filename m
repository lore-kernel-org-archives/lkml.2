Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1IFJRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 05:17:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab1IFJQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 05:16:54 -0400
Message-ID: <4E65E4E9.4050101@redhat.com>
Date: Tue, 06 Sep 2011 11:16:25 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110805 Red Hat/3.1.12-1.el6_1 Lightning/1.0b2 Thunderbird/3.1.12
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH v2] xen: x86_32: do not enable iterrupts
 when returning from exception in interrupt context
References: <4E5EB794.7050909@goop.org> <1314877615-18280-1-git-send-email-imammedo@redhat.com> <4E5FB700.1070908@goop.org> <4E60914F.7080208@redhat.com> <20110902134032.GA6064@dumpdata.com> <4E60E1BF.2020206@redhat.com> <20110902144702.GA1704@dumpdata.com>
In-Reply-To: <20110902144702.GA1704@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 04:47 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 02, 2011 at 04:01:35PM +0200, Igor Mammedov wrote:
>> On 09/02/2011 03:40 PM, Konrad Rzeszutek Wilk wrote:
>>> On Fri, Sep 02, 2011 at 10:18:23AM +0200, Igor Mammedov wrote:
>>>> On 09/01/2011 06:46 PM, Jeremy Fitzhardinge wrote:
>>>>> On 09/01/2011 04:46 AM, Igor Mammedov wrote:
>>>>>> If vmalloc page_fault happens inside of interrupt handler with interrupts
>>>>>> disabled then on exit path from exception handler when there is no pending
>>>>>> interrupts, the following code (arch/x86/xen/xen-asm_32.S:112):
>>>>>>
>>>>>> 	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
>>>>>> 	sete XEN_vcpu_info_mask(%eax)
>>>>>>
>>>>>> will enable interrupts even if they has been previously disabled according to
>>>>>> eflags from the bounce frame (arch/x86/xen/xen-asm_32.S:99)
>>>>>>
>>>>>> 	testb $X86_EFLAGS_IF>>8, 8+1+ESP_OFFSET(%esp)
>>>>>> 	setz XEN_vcpu_info_mask(%eax)
>>>>>>
>>>>>> Solution is in setting XEN_vcpu_info_mask only when it should be set
>>>>>> according to
>>>>>> 	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
>>>>>> but not clearing it if there isn't any pending events.
>>>>>>
>>>>>> Reproducer for bug is attached to RHBZ 707552
>>>>>>
>>>>>> Signed-off-by: Igor Mammedov<imammedo@redhat.com>
>>>>>> Signed-off-by: Jeremy Fitzhardinge<jeremy@goop.org>
>>>>>
>>>>> One nit, this should be acked-by or reviewed-by, not signed-off-by,
>>>>> since the patch isn't passing through my hands.
>>>>>
>>>>>      J
>>>>
>>>> I'm new to this stuff, would you like me to re-post it?
>>>
>>> That is OK.  I fixed it up in the git commit. Thanks for finding this one!
>>
>> You're welcome!
>> I've learned a lot while debugging it. In particular, how to use kvm and qemu's
>> gdbstub to debug xen and guest using gdb.
>
> Oh, would you be interested in writting a blog article on xen.org by any chance?
> That sounds pretty nifty!

Sure, that is on my todo list. I'll just gather separated bits of information
together, on how to prepare host for debugging. And description of problems and
limitations of this approach, that I've stumbled on.


-- 
Thanks,
  Igor
