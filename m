Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab0JUIsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:48:46 -0400
Received: from smtp-out-181.synserver.de ([212.40.180.181]:1636 "HELO
	smtp-out-181.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754809Ab0JUIso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:48:44 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 25392
Date: Thu, 21 Oct 2010 10:48:38 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
Message-ID: <20101021084838.GA1590@arch.trippelsdorf.de>
References: <1287479765.9920.9.camel@marge.simson.net>
 <1287487757.24189.40.camel@marge.simson.net>
 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
 <1287511983.7417.45.camel@marge.simson.net>
 <1287514410.7368.10.camel@marge.simson.net>
 <20101020025652.GB26822@elte.hu>
 <1287648715.9021.20.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287648715.9021.20.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 10:11:55AM +0200, Mike Galbraith wrote:
> On Wed, 2010-10-20 at 04:56 +0200, Ingo Molnar wrote:
> 
> > Mind doing more of the tty->desktop renames/generalizations as Linus suggested, and 
> > resend the patch?
> 
> Here she comes.  Better/Worse?
> 
> Changes:
> - tty->autogroup.
> - only autogroup fair class tasks.
> - removed dainbramaged sleeper vruntime twiddling.
> - removed paranoid locking.
> - removed noop detatch code.
> 
> > I'd also suggest to move it out of EXPERIMENTAL - we dont really do that for core 
> > kernel features as most distros enable CONFIG_EXPERIMENTAL so it's a rather 
> > meaningless distinction. Since the feature is default-n, people will get the old 
> > scheduler by default but can also choose this desktop-centric scheduling mode.
> > 
> > I'd even argue to make it default-y, because this patch clearly cures a form of 
> > kbuild cancer.
> 
> You top dogs can make the default call.. it it's accepted that is ;-)
> 
> Marcus:  care to try the below?  Works fine for me (but so did first
> cut).  It depends on the attached patch, and applied to virgin shiny new
> 2.6.36.

Works fine interactively, but I still get the same kernel BUG on reboot
time as before. Would a photo of the trace help you?

-- 
Markus
