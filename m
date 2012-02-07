Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab2BGQ3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:29:33 -0500
Received: from goliath.siemens.de ([192.35.17.28]:23622 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab2BGQ3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:29:31 -0500
Message-ID: <4F315161.3050304@siemens.com>
Date: Tue, 07 Feb 2012 17:29:21 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Avi Kivity <avi@redhat.com>, qemu-devel <qemu-devel@nongnu.org>,
        Rob Earhart <earhart@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <CAB9FdM9M2DWXBxxyG-ez_5igT61x5b7ptw+fKfgaqMBU_JS5aA@mail.gmail.com> <4F2E80A7.5040908@redhat.com> <CAB9FdM9pPJx8x4y=uvRFh-T4fKBR9xChocUVG_GfNGffTWtMNQ@mail.gmail.com> <4F3025FB.1070802@codemonkey.ws>	<4F31132F.3010100@redhat.com> <4F31408F.80901@codemonkey.ws>	<4F314B2A.4000709@redhat.com> <4F314EEE.8080401@siemens.com> <4F314F87.60807@codemonkey.ws>
In-Reply-To: <4F314F87.60807@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-07 17:21, Anthony Liguori wrote:
> On 02/07/2012 10:18 AM, Jan Kiszka wrote:
>> On 2012-02-07 17:02, Avi Kivity wrote:
>>> On 02/07/2012 05:17 PM, Anthony Liguori wrote:
>>>> On 02/07/2012 06:03 AM, Avi Kivity wrote:
>>>>> On 02/06/2012 09:11 PM, Anthony Liguori wrote:
>>>>>>
>>>>>> I'm not so sure. ioeventfds and a future mmio-over-socketpair have
>>>>>> to put the
>>>>>> kthread to sleep while it waits for the other end to process it.
>>>>>> This is
>>>>>> effectively equivalent to a heavy weight exit. The difference in
>>>>>> cost is
>>>>>> dropping to userspace which is really neglible these days (<  100
>>>>>> cycles).
>>>>>
>>>>> On what machine did you measure these wonderful numbers?
>>>>
>>>> A syscall is what I mean by "dropping to userspace", not the cost of a
>>>> heavy weight exit.
>>>
>>> Ah.  But then ioeventfd has that as well, unless the other end is in the
>>> kernel too.
>>>
>>>> I think a heavy weight exit is still around a few thousand cycles.
>>>>
>>>> Any nehalem class or better processor should have a syscall cost of
>>>> around that unless I'm wildly mistaken.
>>>>
>>>
>>> That's what I remember too.
>>>
>>>>>
>>>>> But I agree a heavyweight exit is probably faster than a double
>>>>> context switch
>>>>> on a remote core.
>>>>
>>>> I meant, if you already need to take a heavyweight exit (and you do to
>>>> schedule something else on the core), than the only additional cost is
>>>> taking a syscall return to userspace *first* before scheduling another
>>>> process.  That overhead is pretty low.
>>>
>>> Yeah.
>>>
>>
>> Isn't there another level in between just scheduling and full syscall
>> return if the user return notifier has some real work to do?
> 
> Depends on whether you're scheduling a kthread or a userspace process, no?  If 

Kthreads can't return, of course. User space threads /may/ do so. And
then there needs to be a differences between host and guest in the
tracked MSRs. I think to recall it's a question of another few hundred
cycles.

Jan

> you're eventually going to end up in userspace, you have to do the full heavy 
> weight exit.
> 
> If you're scheduling to a kthread, it's better to do the type of trickery that 
> ioeventfd does and just turn it into a function call.
> 
> Regards,
> 
> Anthony Liguori
> 
>>
>> Jan
>>
> 

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
