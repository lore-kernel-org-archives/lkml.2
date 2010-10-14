Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab0JNP3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:29:34 -0400
Received: from adelie.canonical.com ([91.189.90.139]:41602 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab0JNP3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:29:33 -0400
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Chase Douglas <chase.douglas@canonical.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        tmhikaru@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>
In-Reply-To: <20101014145813.GA2185@brouette>
References: <20101014145813.GA2185@brouette>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 11:29:21 -0400
Message-ID: <1287070161.31864.243.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 16:58 +0200, Damien Wyart wrote:
> Hello,
> 
> > With 2.6.36-rc6, I'm seeing a load of around 0.60 when the machine is
> > completely idle. This is similar to what someone reported for the latest
> > 2.6.35.x stables. This is on a core i7 machine, but I've no time to
> > bisect or test earlier versions right now, but I guess this is easy to
> > reproduce on the same plateform.
> 
> After further investigation and cross-checking with the thread "PROBLEM:
> Unusually high load average when idle in 2.6.35, 2.6.35.1 and later",
> I came to the following results:
> 
> - the commit 74f5187ac873042f502227701ed1727e7c5fbfa9 isolated by Tim
>   seems to be the culprit;
> - reverting it solves the problem with 2.6.36-rc7 in NOHZ mode: the load
>   when idle goes down to 0.00 (which it never does with the patch
>   applied)
> - using nohz=no with the commit reverted still gives correct behaviour
>   (tested just in case)
> 
> - vanilla 2.6.36-rc7 with this commit applied has the problem (load is
>   around 0.60 when machine idle, sometimes less after several hours
>   of uptime, but never 0.00), and rebooting with nohz=no makes the
>   problem disappear: load goes down to 0.00 quickly after boot process
>   has finished.
> 
> I hope this answers the questions raised in the Tim's thread.
> 
> Could someone with knowledge of the commit take a look at the problem?
> It would be a bit annoying to have this problem in 2.6.36, since Tim's
> initial report dates back to 2 weeks ago...
> 
> I can help for further testing if needed.

Sorry I haven't been as responsive to this issue as I would have liked.
I've been rather busy on other work.

My biggest testing concern is that in reality, load on a normal desktop
machine (i.e. not some stripped down machine disconnected from network
or any other input running nothing but busybox) should not be 0.00.
Maybe load on a server doing absolutely nothing could be 0.00, but
there's usually something going on that should bump it up to a few
hundredths. Watch top, and if you see at least 1% constant cpu usage
there, your load average should be at least 0.01. That said, there does
seem to be a bug somewhere as a load of 0.60 on an idle machine seems
high.

-- Chase

