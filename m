Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1HRTYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:24:43 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:33589 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab1HRTYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:24:42 -0400
X-ASG-Debug-ID: 1313695481-03d6a510a62edac0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E4D66F3.60402@fusionio.com>
Date: Thu, 18 Aug 2011 21:24:35 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Lukas Czerner <lczerner@redhat.com>
CC: Milan Broz <mbroz@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "achender@linux.vnet.ibm.com" <achender@linux.vnet.ibm.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] loop: add discard support for loop devices
References: <1313063143-14473-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1108171511070.3699@dhcp-27-109.brq.redhat.com> <x497h6aspj1.fsf@segfault.boston.devel.redhat.com> <alpine.LFD.2.00.1108181743440.3957@dhcp-27-109.brq.redhat.com> <4E4D610D.9010701@redhat.com> <alpine.LFD.2.00.1108182104390.22042@dhcp-27-109.brq.redhat.com> <4E4D641E.5030100@fusionio.com> <alpine.LFD.2.00.1108182119270.22042@dhcp-27-109.brq.redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] loop: add discard support for loop devices
In-Reply-To: <alpine.LFD.2.00.1108182119270.22042@dhcp-27-109.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1313695481
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.72147
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-18 21:20, Lukas Czerner wrote:
> On Thu, 18 Aug 2011, Jens Axboe wrote:
> 
>> On 2011-08-18 21:08, Lukas Czerner wrote:
>>> On Thu, 18 Aug 2011, Milan Broz wrote:
>>>
>>>> On 08/18/2011 05:49 PM, Lukas Czerner wrote:
>>>>> On Thu, 18 Aug 2011, Jeff Moyer wrote:
>>>>>> Seems you missed the bizarre case of configuring a loop device over top
>>>>>> of a block device.
>>>>>
>>>>> Wow, that is a bizarre case I did not think about at all. But since it
>>>>> is so bizarre, do we even care ? The thing is that the only case where
>>>>> it would make a difference is if the loop device is put on top of block
>>>>> device which actually supports discard.
>>>>>
>>>>> In order to fix that I would need to dig out the actual limits for that
>>>>> device and set that appropriately for the loop device. Is that worth it
>>>>> ? It is not like someone will ever do that (or should) :).
>>>>
>>>> It is bizarre (and being device-mapper developer I surely know better way :-)
>>>> but people are still using that.
>>>>
>>>> Historically one of the use of underlying block device was cryptoloop, but here
>>>> I think it should be completely deprecated (cryptsetup can handle all old loop
>>>> modes as well and default modes for cryptoloop are not safe).
>>>> [Can we finally remove crypto loop option it from kernel? ... ok, just tried:)]
>>>>
>>>> There is also out of tree loop-aes based on heavily patched loop device
>>>> which usually uses block device underneath
>>>> (cryptsetup already can handle all loop-aes modes as well).
>>>>
>>>> Sometimes it is used with --offset parameter for some reason
>>>> (like linear device-mapper mapping).
>>>>
>>>> So I do not care if you do not support discard here but please do not break
>>>> support for block device mapped through loop.
>>>
>>> I do not think that this is the case with my patch. Also, as you know using
>>> discard on encrypted device is not a good idea.
>>
>> It's not a bizarre use case at all, so would be nice to support like we
>> support anything else over a bdev as well. Your patch should not break
>> it, so looks fine.
>>
>> Shall we queue it up for 3.2? It's a good way to beat on fs discard
>> support, fio could be easily configured for that.
>>
> 
> That would be great, thanks!

Alright, lets do that.

> Btw I am not sure what do you mean by "beat on fs discard support" :).

Perhaps worded a bit weird, what I mean was "thoroughly exercise and
test file system discard support" :-)

-- 
Jens Axboe

