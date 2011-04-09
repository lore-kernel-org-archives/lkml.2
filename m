Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1DIDA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 23:00:26 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:42943 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab1DIDAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 23:00:25 -0400
X-ASG-Debug-ID: 1302318022-01de284cf8125410001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D9FCBC3.9040206@fusionio.com>
Date: Sat, 9 Apr 2011 05:00:19 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Rob Landley <rlandley@parallels.com>
CC: Pete Clements <clem@clem.clem-digital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
References: <201103291551.p2TFpDqZ001692@clem.clem-digital.net> <4D92C874.7040104@parallels.com> <4D931634.5030807@fusionio.com> <4D933584.5050005@parallels.com> <4D94432D.5080601@fusionio.com> <4D944544.9040705@parallels.com> <4D945247.4080404@fusionio.com> <4D945976.8000401@fusionio.com> <4D945BAD.10309@parallels.com> <4D9460F8.7080606@fusionio.com> <4D9FCAF6.5030301@parallels.com>
X-ASG-Orig-Subj: Re: Commit 7eaceaccab5f40 causing boot hang.
In-Reply-To: <4D9FCAF6.5030301@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302318022
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60314
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-09 04:56, Rob Landley wrote:
> On 03/31/2011 06:09 AM, Jens Axboe wrote:
>> On 2011-03-31 12:47, Rob Landley wrote:
>>> On 03/31/2011 05:37 AM, Jens Axboe wrote:
>>>>>>> Can you send me your .config?
>>>>>>
>>>>>> It was attached to the first message in this series, here it is again.
>>>>>>
>>>>>> I update it via "make oldconfig" and hold down return.
>>>>>>
>>>>>> I boot it via:
>>>>>>
>>>>>> qemu-system-x86_64 -m 1024 -kernel arch/x86/boot/bzImage \
>>>>>>   -hda ~/sid.ext3 -append "root=/dev/hda rw"
>>>>>
>>>>> Much better, I see the hang now! Now to try and diagnose...
>>>>
>>>> It seems to hard hang, looks very odd:
>>>
>>> I should have mentioned that: when it hangs, you can't page back up in
>>> the console display anymore.
>>
>> Data point - only seems to happen on UP. If you add -smp X to kvm, then
>> it boots and works just fine. It smells oddly like some sort of irq
>> event.
>>
> 
> The workaround for this is to disable preemption, by the way.

Indeed, I think those bits were mentioned earlier. I will get to this
early next week, been away traveling and not back yet.

-- 
Jens Axboe

