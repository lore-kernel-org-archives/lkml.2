Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0JXHBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 03:01:17 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:57006 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab0JXHBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 03:01:15 -0400
X-ASG-Debug-ID: 1287903665-08b79dfb0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CC3D9A1.1050703@fusionio.com>
Date: Sun, 24 Oct 2010 09:00:49 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] disk_free_ptbl_rcu_cb() crash
References: <1287868201.2658.563.camel@edumazet-laptop> <4CC3CC6F.8090606@fusionio.com> <20101024065239.GC7474@redhat.com>
X-ASG-Orig-Subj: Re: [BUG] disk_free_ptbl_rcu_cb() crash
In-Reply-To: <20101024065239.GC7474@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1287903665
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.44580
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-24 08:52, Vivek Goyal wrote:
> On Sun, Oct 24, 2010 at 08:04:31AM +0200, Jens Axboe wrote:
>> On 2010-10-23 23:10, Eric Dumazet wrote:
>>> Current Linus tree makes my machine crash in disk_free_ptbl_rcu_cb(),
>>> while booting...
>>>
>>> commit 7681bfeeccff5ef seems the problem ?
>>>
>>> Following patch solves the NULL dereference, but this is only to show
>>> you where the problem is, not a real fix, of course.
>>
>> Darn. Your fix is on the right path, you missed one though. I think it's
>> cleaner to move this into the elevator helpers, so that the callers can
>> remain clean.
>>
>> Can you verify that this works too?
> 
> Hi Jens,
> 
> I am wondering if this fix is safe. Looking at the memstick backtrace in
> other mail thread, it looks like request queue itself has been freed. So we
> probably should be checking for request queue being valid before we try to
> check q->elevator being valid.

Looking at that trace, it's not yet deleted. But if it's in the to-free
path, by the time we invoke the rcu callback and do the quiesce end it
could be gone.

Needs a bit of thought, feel free to poke at it today if you have time
(because I really do not :-/)

I will ask Linus to revert this commit for now.

> P.S. I tried sending the same response from gmail account but it bounced.
> So if you get this mail twice, please ignore.

Didn't get it twice.

-- 
Jens Axboe

