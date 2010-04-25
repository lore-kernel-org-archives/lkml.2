Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab0DYTIG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 15:08:06 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36284 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753727Ab0DYTIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 15:08:05 -0400
Date: Sun, 25 Apr 2010 14:13:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Rik van Riel <riel@redhat.com>, John Stoffel <john@stoffel.org>,
       Hedi Berriche <hedi@sgi.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
Message-ID: <20100425121331.GA2009@ucw.cz>
References: <20100421193350.GU16427@zorg.emea.sgi.com>
 <19407.23456.469074.256306@stoffel.org>
 <20100421222414.GA26241@suse.de>
 <4BCF80F2.2010906@redhat.com>
 <20100421232200.GA22877@suse.de>
 <20100422102852.72837494@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1004220743080.9086@i5.linux-foundation.org>
 <20100425071606.GB1275@ucw.cz>
 <alpine.LFD.2.00.1004251002480.3739@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004251021520.3739@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004251021520.3739@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Iirc, some _really_ old code used 'short' for pid_t, and we wanted to be 
> > really safe when we raised the limits. 
> 
> .. I dug into the history, and this is from August 2002..
> 
> We used to limit it to sixteen bits, but that was too tight even then for 
> some people, so first we did this:
> 
>     Author: Linus Torvalds <torvalds@home.transmeta.com>
>     Date:   Thu Aug 8 03:57:42 2002 -0700
>     
>         Make pid allocation use 30 of the 32 bits, instead of 15.
...
> which just upped the limits.  That, in turn, _did_ end up breaking some
> silly old binaries, so then a month later Ingo did a "pid-max" patch
> that made the maximum dynamic, with a default of the old 15-bit limit,
> and a sysctl to raise it. 
> 
> And then a couple of weeks later, Ingo did another patch to fix the
> scalability problems we had with lots of pids (avoiding the whole
> "for_each_task()" crud to figure out which pids were ok, and using a
> 'struct pid' instead).
> 
> So the whole worry about > 15-bit pids goes back to 2002.  I think we're
> pretty safe now. 

>From principle of least surprise PoV: breaking old userspace when you
pass special config option is less surpising than breaking old
userspace when you add more CPUs.

Whether the breakage will be common enough that this matters is other
question.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
