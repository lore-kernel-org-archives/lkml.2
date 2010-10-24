Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab0JXGqE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 02:46:04 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:42391 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab0JXGqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 02:46:02 -0400
X-ASG-Debug-ID: 1287902761-1696702f0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CC3D620.2090401@fusionio.com>
Date: Sun, 24 Oct 2010 08:45:52 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] disk_free_ptbl_rcu_cb() crash
References: <1287868201.2658.563.camel@edumazet-laptop>	 <4CC3CC6F.8090606@fusionio.com> <1287902670.2658.580.camel@edumazet-laptop>
X-ASG-Orig-Subj: Re: [BUG] disk_free_ptbl_rcu_cb() crash
In-Reply-To: <1287902670.2658.580.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1287902761
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4999 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.44578
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-24 08:44, Eric Dumazet wrote:
> Le dimanche 24 octobre 2010 à 08:04 +0200, Jens Axboe a écrit :
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
> Sure, I did right now and it works too, thanks !

Thanks for the (very) quick turn-around, I'll get this one expedited
as well.

-- 
Jens Axboe

