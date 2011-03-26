Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1CZIZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 04:25:33 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:58009 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab1CZIZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 04:25:30 -0400
X-ASG-Debug-ID: 1301127929-03d6a52c5b00eb0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8DA2F5.1050008@fusionio.com>
Date: Sat, 26 Mar 2011 09:25:25 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39
References: <4D8B4A89.80608@fusionio.com>	<AANLkTi=zJbUpcT+vbLARyxhA34F1se8pYq9No799Zqzh@mail.gmail.com>	<4D8D87B0.3080107@fusionio.com> <AANLkTimy1QZiHtQGUrXLPMRGEy3iXNOB=34tFjgezhEu@mail.gmail.com>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block IO bits for 2.6.39
In-Reply-To: <AANLkTimy1QZiHtQGUrXLPMRGEy3iXNOB=34tFjgezhEu@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301127929
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59005
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-26 08:21, Geert Uytterhoeven wrote:
> On Sat, Mar 26, 2011 at 07:29, Jens Axboe <jaxboe@fusionio.com> wrote:
>> On 2011-03-25 22:35, Geert Uytterhoeven wrote:
>>> On Thu, Mar 24, 2011 at 14:43, Jens Axboe <jaxboe@fusionio.com> wrote:
>>>> Jens Axboe (20):
>>>>      block: remove per-queue plugging
>>>
>>> This one (commit 7eaceaccab5f40bbfda044629a6298616aeaed50) breaks IDE
>>> on Atari/m68k under ARAnyM. It hangs on:
>>>
>>> | ide: Falcon IDE controller
>>> | Probing IDE interface ide0...
>>> | hda: Sarge m68k, ATA DISK drive
>>> | ide0 at 0xfff00000 on irq 15 (serialized)
>>> | ide-gd driver 1.18
>>> | hda: max request size: 128KiB
>>> | hda: 2118816 sectors (1084 MB) w/256KiB Cache, CHS=2102/16/63
>>>
>>> The next expected line is the partition parsing:
>>>
>>> | hda: AHDI hda1 hda2
>>
>> Geert, does this work for you?
> 
> Yep.Thanks!

Great! I think we should place those blk_delay_queue() calls under the
if (rq), that should workd to and be more optimal. Can I ask you to
check that, too?

So:

if (rq) {
        blk_requeue_request(q, rq);
        blk_delay_queue(q, msecs_to_jiffies(3));
}

in both locations.

-- 
Jens Axboe

