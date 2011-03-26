Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1CZQxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 12:53:54 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:53380 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab1CZQxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 12:53:52 -0400
X-ASG-Debug-ID: 1301158431-03d6a5102e006b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8E1A1A.8010300@fusionio.com>
Date: Sat, 26 Mar 2011 17:53:46 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39
References: <4D8B4A89.80608@fusionio.com> <AANLkTi=zJbUpcT+vbLARyxhA34F1se8pYq9No799Zqzh@mail.gmail.com> <4D8D87B0.3080107@fusionio.com> <AANLkTi=jcm8pLQCTwYPK_Ey1SbMYSqQhYD4fJmCNz7sS@mail.gmail.com>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block IO bits for 2.6.39
In-Reply-To: <AANLkTi=jcm8pLQCTwYPK_Ey1SbMYSqQhYD4fJmCNz7sS@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301158431
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59039
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-26 17:48, Linus Torvalds wrote:
> On Fri, Mar 25, 2011 at 11:29 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>> +
>> +       /* Use 3ms as that was the old plug delay */
>> +       blk_delay_queue(q, msecs_to_jiffies(3));
> 
> That's bogus. blk_delay_queue() already takes msecs, not jiffies.

You are right, braino.

> Also, do we really need to delay every unplug like this? It seems sad.
> A 3ms delay is a long time these days - admittedly most people
> hopefully use ATA these days if they have an SSD or something, but
> still..

Depends on whether you want the 'call me back, I ran into busy this
time' or the 'recall me immediately'.

I'll take a look at the IDE case tonight and submit a real fix.

-- 
Jens Axboe

