Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab0D0SIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:08:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43686 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab0D0SIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NkgJ6x1huuaior6cEO1RJdnasjfrLcv4TyVFM9zrH90P8gpgAIqT5hUW9j7tKj4UQM
         MPpuwNuJR6waIxPt/Yvnfxo8zLWNVjRmf0UL+ysBAOoVrWhcNYKEm0WE7e24xCIr6WwE
         Wa0O2vQK8W/mriZvzJbP9Tpu6cGo4vLoNDucM=
Date: Tue, 27 Apr 2010 20:07:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] lockdep: Fix redundant_hardirqs_on incremented with
	irqs enabled
Message-ID: <20100427180749.GB5586@nowhere>
References: <20100415200414.1ef705c8.sfr@canb.auug.org.au> <1271338670-4537-1-git-send-regression-fweisbec@gmail.com> <20100427173227.7ec29329.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427173227.7ec29329.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 05:32:27PM +1000, Stephen Rothwell wrote:
> Hi Frederic,
> 
> On Thu, 15 Apr 2010 15:37:50 +0200 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> > When a path restore the flags while irqs are already enabled, we
> > update the per cpu var redundant_hardirqs_on in a racy fashion
> > and debug_atomic_inc() warns about this situation.
> > 
> > In this particular case, we need to explictly disable the irqs before
> > updating this stat var in order to update it safely.
> > 
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: David Miller <davem@davemloft.net>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > ---
> >  kernel/lockdep.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> Ping?  Any movement on this?


Ingo, if you have no problems with these two patches, could you please
apply them?

Thanks.

