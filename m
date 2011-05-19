Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab1ESHZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 03:25:39 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:53915 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293Ab1ESHZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 03:25:38 -0400
X-ASG-Debug-ID: 1305789936-01de28096b4cdc0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DD4C5EC.8060200@fusionio.com>
Date: Thu, 19 May 2011 09:25:32 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tony Luck <tony.luck@gmail.com>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: New boot time message: detected capacity change
References: <BANLkTin3T8msxSSbTLJOvC5WLNFGspPEcg@mail.gmail.com> <BANLkTimY+y3vXa0R7Evs6dYLVjJ==KVq1A@mail.gmail.com>
X-ASG-Orig-Subj: Re: New boot time message: detected capacity change
In-Reply-To: <BANLkTimY+y3vXa0R7Evs6dYLVjJ==KVq1A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1305789936
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64168
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-18 22:50, Linus Torvalds wrote:
> On Wed, May 18, 2011 at 1:32 PM, Tony Luck <tony.luck@gmail.com> wrote:
>> Today's pull from Linus' tree (HEAD = 258-ga2b9c1f) gave me some new
>> messages during boot:
>>
>> sda: detected capacity change from 0 to 146815737856
>> sdb: detected capacity change from 0 to 146815737856
>>
>> They weren't there yesterday (HEAD = 211-gc1d10d1) ... nor do they
>> show up in any of my saved boot time dmesg files for the last few
>> months.
>>
>> Harmless?  Or something to worry about in the last few commits
>> before 2.6.39 goes final?
> 
> I htink it's 02e352287a40 ("block: rescan partitions on invalidated
> devices on -ENOMEDIA too"), which was reported to fix a bugzilla
> entry.
> 
> However, now that I look closer, that bugzilla entry was two years old
> and reported for 2.6.29.
> 
> So it wasn't a regression fix like the changelog made me think (with a
> stable pointer for 38)
> 
> Jens, Tejun - stop this messing around! The block layer has been one
> of the problem children in the last releases, the *LAST* thing we need
> is things like this happening this late in the -rc series!

This release has not been great, mostly early in the cycle. I will take
complete blame for pushing this change so late, that's why I asked Tejun
about the three patches queues up yesterday. We've had more churn in
this cycle due to both the plugging and media event notification
changes, both have caused way more commits and later in the cycle that
I'm usually comfortable with. I do _always_ try to push the big stuff
before -rc1, so I don't think it's completely fair to quote earlier
releases as problematic.

> Seriously. I'm really upset. I need to be able to trust you, and you
> are not being trust-worthy. F*&^ you, in other words. This was *NOT* a
> regression.
> 
> I don't care if it fixes a long-standing bug, you do not send fixes
> like that to me. It should have gone into the merge window for 40, and
> at *that* point it might be marked for stable.
> 
> As it was, I feel that those commit descriptions were actively
> misleading me into thinking this was a regression.
> 
> Maybe it won't cause any problems, but -rc7 is not the time to make
> these kinds of experiments!

I agree. And not that it's an excuse, but it has been well tested here
on my test and primary machines. Arguably this particular patch should
just have waited for 2.6.40 and with a stable backport instead.

Will not happen again.

-- 
Jens Axboe

