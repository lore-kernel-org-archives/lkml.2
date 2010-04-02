Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0DBSpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:45:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab0DBSpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:45:39 -0400
Date: Fri, 2 Apr 2010 20:43:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
       Greg KH <greg@kroah.com>, Catalin Marinas <catalin.marinas@arm.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, stable@kernel.org
Subject: Re: [PATCH 1/1] tty: release_one_tty() forgets to put pids
Message-ID: <20100402184349.GA32229@redhat.com>
References: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp> <tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com> <20100331151719.8a92b302.akpm@linux-foundation.org> <20100402160447.GA19920@redhat.com> <20100402160512.GB19920@redhat.com> <alpine.LFD.2.00.1004021040320.3634@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004021040320.3634@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Linus Torvalds wrote:
>
> On Fri, 2 Apr 2010, Oleg Nesterov wrote:
> >
> > release_one_tty(tty) can be called when tty still has a reference
> > to pgrp/session. In this case we leak the pid.
>
> Hmm. Maybe we should have cleared this in tty_release() already. We
> already do some of the session clearing there (but we clear the session in
> the _tasks_ associated with the tty, not the tty session pointer).

Yes, probably we can free them earlier.

But I am very nervous about this change, I tried to defer put_pid()
as much as possible, in case something else uses ->prgp/session
before free_tty_struct().

Oleg.

