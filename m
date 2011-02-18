Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1BRVMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 16:12:02 -0500
Received: from host1.dyn.jankratochvil.net ([89.250.240.48]:55985 "EHLO
	host1.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062Ab1BRVMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 16:12:00 -0500
Date: Fri, 18 Feb 2011 22:11:40 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110218211140.GA2066@host1.dyn.jankratochvil.net>
References: <20110204105343.GA12133@htj.dyndns.org>
 <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
 <20110216215157.GA6054@host1.dyn.jankratochvil.net>
 <201102170437.51382.vda.linux@googlemail.com>
 <20110217191952.GA13611@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217191952.GA13611@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 20:19:52 +0100, Oleg Nesterov wrote:
> > > That is after PTRACE_DETACH(0) the process should remain `T (stopped)'
> > > iff the process was `T (stopped)' before PTRACE_ATTACH.
> > >  - PTRACE_DETACH(0)       should preserve `T (stopped)'.
> >
> > I assume you are thinking about PTRACE_ATTACH + wait():SIGSTOP
> > + PTRACE_DETACH(0) sequence.
> 
> plus it should be stopped before attach, I assume. Otherwise this
> not true with the current code.

I did not talk about the current code.  I was making a proposal of new
behavior (which should not break existing software).

If PTRACE_ATTACH was done on process with `T (stopped)' then after
PTRACE_DETACH(0) again the process should be `T (stopped)'.


Regards,
Jan
