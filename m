Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1LXJJQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 04:09:16 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:52241 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab1LXJJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 04:09:05 -0500
Message-ID: <4EF596AD.1030402@msgid.tls.msk.ru>
Date: Sat, 24 Dec 2011 13:09:01 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110805 Icedove/5.0
MIME-Version: 1.0
To: Phil Miller <mille121@illinois.edu>
CC: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <greg@kroah.com>,
        stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [REGRESSION,STABLE,BISECTED] Hang on resume from standby in 3.1.[56],
 3.2-rc*
References: <CAMDbWJG4u62qmBgxhaYZCuL+5897defC1cy5tNMd+M+9BhWS+g@mail.gmail.com> <CAMDbWJGjGo4BVpL+vwZJgBBJxradjzp2gvwVUqk-H9CvCL6XFg@mail.gmail.com>
In-Reply-To: <CAMDbWJGjGo4BVpL+vwZJgBBJxradjzp2gvwVUqk-H9CvCL6XFg@mail.gmail.com>
X-Enigmail-Version: 1.2.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.12.2011 10:40, Phil Miller wrote:
> I just went digging through the history, and it looks like the commit
> I found to be problematic partially reverts
> 7c1e76897492d92b6a1c2d6892494d39ded9680c, from 2008.
> 
> On Fri, Dec 23, 2011 at 11:31, Phil Miller <mille121@illinois.edu> wrote:
>> I've got a Dell Precision T1500 (lspci, dmidecode, and dmesg output at
>> http://charm.cs.uiuc.edu/~phil/linux-suspend-hang/ ) that I generally
>> suspend when I'm out of the house or asleep, and wake up when I want
>> to use it. Sadly, a recent change to the kernel has disrupted that
>> happy state of affairs. When I run the most recent stable or
>> pre-release versions, the kernel hangs on resume. I can still switch
>> virtual consoles, and get keyboard output echoed to the screen, but no
>> userspace code seems to be running (e.g. login doesn't give me a
>> password prompt after entering a username), nor does the system
>> respond to ping or SSH connections.
>>
>> Bisection between v3.1 and v3.1.6 points to the following commit as the culprit:
>> =====
>> commit aeed6baa702a285cf03b7dc4182ffc1a7f4e4ed6
>> Author: Thomas Gleixner <tglx@linutronix.de>
>> Date:   Fri Dec 2 16:02:45 2011 +0100
>>
>>    clockevents: Set noop handler in clockevents_exchange_device()

I  noticed that my host also stopped resuming with 3.1, and noted that
with 3.1.3 it works ok.  I'm now trying to revert this commit too, to
see if that's the problem.

/mjt
