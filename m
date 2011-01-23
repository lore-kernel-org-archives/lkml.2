Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab1AWLTi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 06:19:38 -0500
Received: from trent.utfs.org ([194.246.123.103]:47697 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab1AWLTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 06:19:37 -0500
Date: Sun, 23 Jan 2011 03:19:34 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: efault@gmx.de, Michael Witten <mfwitten@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 'autogroup' sched code KILLING responsiveness
In-Reply-To: <alpine.DEB.2.01.1101230243370.7903@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1101230314100.7903@trent.utfs.org>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com> <alpine.DEB.2.01.1101230243370.7903@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jan 2011 at 02:50, Christian Kujau wrote:
> On Fri, 21 Jan 2011 at 10:20, Michael Witten wrote:
> > With that code in place, a resource-intensive activity (such as
> > compiling the Linux kernel) causes my computer to become
> > unresponsive for many seconds at a time; the entire screen
> > does not refresh, typed keys are dropped or are handled very
> > late, etc (even in Linux's plain virtual consoles).
> 
> Unfortunately, I'd like to add a "me too". 2.6.38-rc1 behaves fine, but 
> with CONFIG_SCHED_AUTOGROUP=y and doing I/O and CPU intensive work (git 
> prune/git repack on a Linux git tree), system load goes up to ~13 and 
> becomes unresponse for some time too. This even happens when I start the 
> jobs with nice -n10.

"unresponsive for some time" turned out to be "system unusable, unless 
rebooted". When I started the "git repack" with the autogroup feature 
turned on, load would go to 4 very quickly (as compared to 1 or 2 w/o 
autogroup), after a while (seconds, minutes) it would go to 10 or 14 and I 
cannot use the system any more, after a while it goes back to 4 but then 
it goes up again, the last load number I see is 11.56 and now the system 
is stuck or so busy that I cannot login any more, not even locally. This 
happened before with 2.6.38-rc1 & CONFIG_SCHED_AUTOGROUP=y, so it's quite 
reproducible for me.

Christian.

> 
> Without CONFIG_SCHED_AUTOGROUP enabled and doing the same work,
> systemload goes up to 1 or maybe 2.
> 
> I'm on UP as well (PowerPC G4), disabling CONFIG_SCHED_AUTOGROUP helps 
> here too.
> 
> Thanks,
> Christian.

-- 
BOFH excuse #356:

the daemons! the daemons! the terrible daemons!
