Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab1AVVXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 16:23:16 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51854 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1AVVXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 16:23:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:subject:from:to:cc:in-reply-to:references
         :mime-version;
        b=YSdkFdVzAaNiIBebkj+EYm0CiraiNlLjVwpC0BOxRhpl8u/a6/0bPUhV4cTXYjx3KA
         CIbsf4rhqDzRgzJx0fKv1etM7zLym15Z+cryJKnMjzSG1cPBFit3Og2EFlCY1ApzYB7i
         C9L2LPuoVwHfn8Te73Gq+ITdAphYi9ZrKIuTo=
Message-ID: <4d3b4ac1.26092a0a.6f30.ffffcf6b@mx.google.com>
Date: Sat, 22 Jan 2011 13:23:13 -0800 (PST)
Subject: Re: 'autogroup' sched code KILLING responsiveness
From: Michael Witten <mfwitten@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1295648870.23779.15.camel@marge.simson.net>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com> <1295648870.23779.15.camel@marge.simson.net>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 23:27:50 +0100, Mike Galbraith wrote:
>On Fri, 2011-01-21 at 10:20 -0800, Michael Witten wrote:
>> Bisecting shows that this commit:
>> 
>>   5091faa449ee0b7d73bc296a93bca9540fc51d0a
>>   sched: Add 'autogroup' scheduling feature: automated per session task groups
>>   Date:   Tue Nov 30 14:18:03 2010 +0100
>> 
>> is the reason that my computer has become unusable.
>> 
>> With that code in place, a resource-intensive activity (such as
>> compiling the Linux kernel) causes my computer to become
>> unresponsive for many seconds at a time; the entire screen
>> does not refresh, typed keys are dropped or are handled very
>> late, etc (even in Linux's plain virtual consoles).
>
> That's not what I'm experiencing with a UP kernel...

Firstly, I apologize for the rather unhelpful email that
follows.

On my machine (x86, Dell Latitude D810), the problem is so
incredibly debilitating that it is incomprehensible others would
not notice if they were subject to the same problem; basically,
I don't know what to do at this point (I've played around with
`oprofile' and `tools/perf', but nothing looks very odd to me
either).

I'd appreciate it if you could give me some direction; I wish
I could give you more with which to work. Should I send you a
copy of my kernel configuration? (I was going to inline it,
as well as the results of `lspci' and `cat /proc/cpuinfo', but
I thought that might be unhelpful if not rude).

Invariably, running:

    yes
    
in a Linux virtual console completely locks me out of my system
(it's not even possible to login remotely via ssh); however,
running it within a terminal emulator in X doesn't seem to cause
the problems I've been seeing.

Things get stranger.

When I run the following in a Linux VC:

  sleep 10; yes | head -2500000

and then switch to X before `yes' begins to run, I can move my
mouse cursor around without trouble for the entire time that
`yes' is allowed to run. HOWEVER, if I ever press (and release if
you like) a key on my keyboard while `yes' is running, then the
entire screen freezes, including the mouse cursor; I only regain
control when `yes' finishes.

Similarly, if I build the Linux kernel:

  make

(this time even within a terminal emulator in X), then I can
move my mouse cursor around without trouble UNTIL I also press
keyboard keys (actually, I'm just holding one key down), at which
point the mouse cursor periodically freezes; the whole screen
freezes with each new status line of the build and then briefly
unfreezes before the next status line can appear (that is, before
the next file can be compiled); the indications are that nothing
else is getting the CPU, as keypresses are sometimes dropped.

Of course, I have none of these problems when I disable:

  CONFIG_AUTOGROUP_SCHED

Sincerely,
Michael Witten
