Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab1EPNVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:21:51 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:39807 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753829Ab1EPNVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:21:50 -0400
Date: Mon, 16 May 2011 15:21:23 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_SEIZE should not stop  [Re: [PATCH 02/11] ptrace:
 implement PTRACE_SEIZE]
Message-ID: <20110516132123.GA13544@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110515155602.GD31855@host1.jankratochvil.net>
 <20110515162630.GG23665@htj.dyndns.org>
 <20110515171512.GA24047@host1.jankratochvil.net>
 <20110515172505.GL23665@htj.dyndns.org>
 <20110515194829.GA27023@host1.jankratochvil.net>
 <20110516083113.GN23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516083113.GN23665@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Mon, 16 May 2011 10:31:13 +0200, Tejun Heo wrote:
> First of all, I don't think hitting different trap spots would be that
> difficult.  Handling different traps after SEIZE might not be easy but
> could just be something which needs to be done anyway.  I'm reluctant
> to treat the initial trap differently because it's essentially
> identical to what happens when a program does PTRACE_INTERRUPT.  It's
> just something the program should be able to deal with, somewhat like
> read(2) may return shorter amount of data than provided buffer.

If not clear I would like also PTRACE_INTERRUPT to deliver the INTERRUPT event
always as the first one, if it is not clear.

tracer            tracee                                foreign process
---------------   ------                                ---------------
attaches tracee                                        
normal run                                             
                                                        tkill(tracee, SIGUSR1)
                  stopped, to report SIGUSR1 to tracer
PTRACE_INTERRUPT  (but tracee is already stopped)
waitpid(tracee)

Currently that waitpid will report SIGUSR1 first and then the INTERRUPT trap.

I suggest - if possible - that tracer will get that INTERRUPT trap first.

But you made the optimization that the INTERRUPT gets suppressed in such case.
Which improves performance for the cost of more complicated debuggers.

I guess after PTRACE_SEIZE if the first signal/event is not INTERRUPT there
will not be any INTERRUPT later, as you said.


Thanks,
Jan
