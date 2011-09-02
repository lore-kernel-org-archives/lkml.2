Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab1IBOBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:01:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab1IBOBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:01:52 -0400
Message-ID: <4E60E1BF.2020206@redhat.com>
Date: Fri, 02 Sep 2011 16:01:35 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110805 Red Hat/3.1.12-1.el6_1 Lightning/1.0b2 Thunderbird/3.1.12
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH v2] xen: x86_32: do not enable iterrupts
 when returning from exception in interrupt context
References: <4E5EB794.7050909@goop.org>	<1314877615-18280-1-git-send-email-imammedo@redhat.com>	<4E5FB700.1070908@goop.org> <4E60914F.7080208@redhat.com> <20110902134032.GA6064@dumpdata.com>
In-Reply-To: <20110902134032.GA6064@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 03:40 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 02, 2011 at 10:18:23AM +0200, Igor Mammedov wrote:
>> On 09/01/2011 06:46 PM, Jeremy Fitzhardinge wrote:
>>> On 09/01/2011 04:46 AM, Igor Mammedov wrote:
>>>> If vmalloc page_fault happens inside of interrupt handler with interrupts
>>>> disabled then on exit path from exception handler when there is no pending
>>>> interrupts, the following code (arch/x86/xen/xen-asm_32.S:112):
>>>>
>>>> 	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
>>>> 	sete XEN_vcpu_info_mask(%eax)
>>>>
>>>> will enable interrupts even if they has been previously disabled according to
>>>> eflags from the bounce frame (arch/x86/xen/xen-asm_32.S:99)
>>>>
>>>> 	testb $X86_EFLAGS_IF>>8, 8+1+ESP_OFFSET(%esp)
>>>> 	setz XEN_vcpu_info_mask(%eax)
>>>>
>>>> Solution is in setting XEN_vcpu_info_mask only when it should be set
>>>> according to
>>>> 	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
>>>> but not clearing it if there isn't any pending events.
>>>>
>>>> Reproducer for bug is attached to RHBZ 707552
>>>>
>>>> Signed-off-by: Igor Mammedov<imammedo@redhat.com>
>>>> Signed-off-by: Jeremy Fitzhardinge<jeremy@goop.org>
>>>
>>> One nit, this should be acked-by or reviewed-by, not signed-off-by,
>>> since the patch isn't passing through my hands.
>>>
>>>      J
>>
>> I'm new to this stuff, would you like me to re-post it?
>
> That is OK.  I fixed it up in the git commit. Thanks for finding this one!

You're welcome!
I've learned a lot while debugging it. In particular, how to use kvm and qemu's
gdbstub to debug xen and guest using gdb.

-- 
Thanks,
  Igor
