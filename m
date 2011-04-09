Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1DIC5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 22:57:04 -0400
Received: from mx2.parallels.com ([64.131.90.16]:34417 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab1DIC5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 22:57:02 -0400
Message-ID: <4D9FCAF6.5030301@parallels.com>
Date: Fri, 8 Apr 2011 21:56:54 -0500
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Pete Clements <clem@clem.clem-digital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
References: <201103291551.p2TFpDqZ001692@clem.clem-digital.net> <4D92C874.7040104@parallels.com> <4D931634.5030807@fusionio.com> <4D933584.5050005@parallels.com> <4D94432D.5080601@fusionio.com> <4D944544.9040705@parallels.com> <4D945247.4080404@fusionio.com> <4D945976.8000401@fusionio.com> <4D945BAD.10309@parallels.com> <4D9460F8.7080606@fusionio.com>
In-Reply-To: <4D9460F8.7080606@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.54.86.208]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 06:09 AM, Jens Axboe wrote:
> On 2011-03-31 12:47, Rob Landley wrote:
>> On 03/31/2011 05:37 AM, Jens Axboe wrote:
>>>>>> Can you send me your .config?
>>>>>
>>>>> It was attached to the first message in this series, here it is again.
>>>>>
>>>>> I update it via "make oldconfig" and hold down return.
>>>>>
>>>>> I boot it via:
>>>>>
>>>>> qemu-system-x86_64 -m 1024 -kernel arch/x86/boot/bzImage \
>>>>>   -hda ~/sid.ext3 -append "root=/dev/hda rw"
>>>>
>>>> Much better, I see the hang now! Now to try and diagnose...
>>>
>>> It seems to hard hang, looks very odd:
>>
>> I should have mentioned that: when it hangs, you can't page back up in
>> the console display anymore.
> 
> Data point - only seems to happen on UP. If you add -smp X to kvm, then
> it boots and works just fine. It smells oddly like some sort of irq
> event.
> 

The workaround for this is to disable preemption, by the way.

Rob
