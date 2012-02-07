Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2BGQC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:02:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab2BGQCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:02:55 -0500
Message-ID: <4F314B2A.4000709@redhat.com>
Date: Tue, 07 Feb 2012 18:02:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Rob Earhart <earhart@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com>	<CAB9FdM9M2DWXBxxyG-ez_5igT61x5b7ptw+fKfgaqMBU_JS5aA@mail.gmail.com>	<4F2E80A7.5040908@redhat.com>	<CAB9FdM9pPJx8x4y=uvRFh-T4fKBR9xChocUVG_GfNGffTWtMNQ@mail.gmail.com>	<4F3025FB.1070802@codemonkey.ws> <4F31132F.3010100@redhat.com> <4F31408F.80901@codemonkey.ws>
In-Reply-To: <4F31408F.80901@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 05:17 PM, Anthony Liguori wrote:
> On 02/07/2012 06:03 AM, Avi Kivity wrote:
>> On 02/06/2012 09:11 PM, Anthony Liguori wrote:
>>>
>>> I'm not so sure. ioeventfds and a future mmio-over-socketpair have 
>>> to put the
>>> kthread to sleep while it waits for the other end to process it. 
>>> This is
>>> effectively equivalent to a heavy weight exit. The difference in 
>>> cost is
>>> dropping to userspace which is really neglible these days (< 100 
>>> cycles).
>>
>> On what machine did you measure these wonderful numbers?
>
> A syscall is what I mean by "dropping to userspace", not the cost of a 
> heavy weight exit. 

Ah.  But then ioeventfd has that as well, unless the other end is in the 
kernel too.

> I think a heavy weight exit is still around a few thousand cycles.
>
> Any nehalem class or better processor should have a syscall cost of 
> around that unless I'm wildly mistaken.
>

That's what I remember too.

>>
>> But I agree a heavyweight exit is probably faster than a double 
>> context switch
>> on a remote core.
>
> I meant, if you already need to take a heavyweight exit (and you do to 
> schedule something else on the core), than the only additional cost is 
> taking a syscall return to userspace *first* before scheduling another 
> process.  That overhead is pretty low.

Yeah.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

