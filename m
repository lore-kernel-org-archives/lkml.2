Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1DTNbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:31:55 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:53630 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab1DTNbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:31:53 -0400
X-ASG-Debug-ID: 1303306312-01de284cf816e490001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAEE049.7050407@fusionio.com>
Date: Wed, 20 Apr 2011 15:31:53 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer  dereference
 at  0000000c IP: cfq_insert_request+0x1d/0x3f5
References: <20110420125824.GA3507@tiehlicka.suse.cz> <4DAEDBEB.7060904@fusionio.com> <20110420132903.GA13554@tiehlicka.suse.cz>
X-ASG-Orig-Subj: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer  dereference
 at  0000000c IP: cfq_insert_request+0x1d/0x3f5
In-Reply-To: <20110420132903.GA13554@tiehlicka.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303306312
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.20
X-Barracuda-Spam-Status: No, SCORE=0.20 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=PR0N_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61410
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.20 PR0N_SUBJECT           Subject has letters around special characters (pr0n)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-20 15:29, Michal Hocko wrote:
> On Wed 20-04-11 15:13:15, Jens Axboe wrote:
>> On 2011-04-20 14:58, Michal Hocko wrote:
>>> Hi,
>>> I am not able to boot with the current git tree
>>> (2.6.39-rc4-00089-g2f666bc). 2.6.39-rc3 boots just fine.
>>>
>>> The backtrace [1] looks really messy.
>>>
>>> I have seen a similar backtrace at https://lkml.org/lkml/2011/3/25/169
>>> and tried the patch from https://lkml.org/lkml/2011/3/25/173 but it
>>> didn't help. The backtrace looks similar (much smaller) but the machine
>>> ends up dead as well with unbalanced preempt counter[2].
>>>
>>> The config is attached.
>>>
>>> Is this a known problem?
>>>
>>> ---
>>> * [1] backtrace with the current git tree (2f666bc)
>>>
>>> [   31.207283] BUG: unable to handle kernel NULL pointer dereference at 0000000c
>>> NULL pointer dereference[   31.207540] IP: at 0000000c
>>> [   31.207540] IP: [<c028dece>] cfq_insert_request+0x1d/0x3f5
>>> [   31.207720] *pde = 00000000  [<c028dece>] cfq_insert_request+0x1d/0x3f5
>>> NULL pointer dereference[   31.207720] *pde = 00000000
>>>  at 0000000c
>>> [   31.207888] Oops: 0000 [#1]
>>> PREEMPT [   31.207540] IP:[   31.207888] Oops: 0000 [#1] SMP PREEMPT DEBUG_PAGEALLOC [<c028dece>] cfq_insert_request+0x1d/0x3f5
>>> SMP DEBUG_PAGEALLOC[   31.207720] *pde = 00000000
>>> [   31.207888] Oops: 0000 [#1] PREEMPT [   31.208186] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/queue/scheduler
>>
>> Ahh hang on, this may be a good clue. Does your boot scripts change the
>> IO scheduler?
> 
> Good one...
> Yes, I have:
> echo deadline > /sys/block/sda/queue/scheduler
> in /etc/rc.local
> 
> I am able to boot after I remove it. This is the first time I have seen
> "last sysfs file" being useful.

Haha, good point, it's the first time for me as well IO think.

> Still want me to test the patch from the other email?

No, that wont help you. I do wonder why this is a rc3 vs rc4 change.
I'll dig around and send you something to try.

-- 
Jens Axboe

