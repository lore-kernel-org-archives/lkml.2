Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab1LXQv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 11:51:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50920 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1LXQvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 11:51:25 -0500
MIME-Version: 1.0
In-Reply-To: <d71755af705048a4868348343417a4c4@CITESHT4.ad.uillinois.edu>
References: <CAMDbWJG4u62qmBgxhaYZCuL+5897defC1cy5tNMd+M+9BhWS+g@mail.gmail.com>
 <CAMDbWJGjGo4BVpL+vwZJgBBJxradjzp2gvwVUqk-H9CvCL6XFg@mail.gmail.com> <d71755af705048a4868348343417a4c4@CITESHT4.ad.uillinois.edu>
From: Phil Miller <mille121@illinois.edu>
Date: Sat, 24 Dec 2011 10:51:03 -0600
X-Google-Sender-Auth: _u2Hdq_m2LmAWd6cft7PTRU4S38
Message-ID: <CAMDbWJGzMKgRLjU3QznPJt1s-hizSyWqzGJv1bYZKvKDJzWYig@mail.gmail.com>
Subject: Re: [REGRESSION,STABLE,BISECTED] Hang on resume from standby in
 3.1.[56], 3.2-rc*
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <greg@kroah.com>,
        "stable@kernel.org" <stable@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 24, 2011 at 03:09, Michael Tokarev <mjt@tls.msk.ru> wrote:
> On 24.12.2011 10:40, Phil Miller wrote:
>> On Fri, Dec 23, 2011 at 11:31, Phil Miller <mille121@illinois.edu> wrote:
>>> I've got a Dell Precision T1500 (lspci, dmidecode, and dmesg output at
>>> http://charm.cs.uiuc.edu/~phil/linux-suspend-hang/ ) that I generally
>>> suspend when I'm out of the house or asleep, and wake up when I want
>>> to use it. Sadly, a recent change to the kernel has disrupted that
>>> happy state of affairs. When I run the most recent stable or
>>> pre-release versions, the kernel hangs on resume. I can still switch
>>> virtual consoles, and get keyboard output echoed to the screen, but no
>>> userspace code seems to be running (e.g. login doesn't give me a
>>> password prompt after entering a username), nor does the system
>>> respond to ping or SSH connections.
>>>
>>> Bisection between v3.1 and v3.1.6 points to the following commit as the culprit:
>>> =====
>>> commit aeed6baa702a285cf03b7dc4182ffc1a7f4e4ed6
>>> Author: Thomas Gleixner <tglx@linutronix.de>
>>> Date:   Fri Dec 2 16:02:45 2011 +0100
>>>
>>>    clockevents: Set noop handler in clockevents_exchange_device()
>>
>> I just went digging through the history, and it looks like the commit
>> I found to be problematic partially reverts
>> 7c1e76897492d92b6a1c2d6892494d39ded9680c, from 2008.
>
> I  noticed that my host also stopped resuming with 3.1, and noted that
> with 3.1.3 it works ok.  I'm now trying to revert this commit too, to
> see if that's the problem.

I first noticed this using Debian unstable's packaged kernels, which
call themselves 3.x.0, but actually get revved through the stable
versions 3.x.y (I'll probably complain about that misnaming to them).
The upgrade from 3.1.4 to 3.1.5 is where it broke, matching the
bisection's results.

Thanks for the confirmation.

Phil
