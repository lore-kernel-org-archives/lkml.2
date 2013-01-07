Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab3AGO6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:58:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab3AGO6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:58:44 -0500
Date: Mon, 7 Jan 2013 09:58:32 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com
Subject: Re: [PATCH] MODSIGN: Don't taint unless signature enforcing is
 enabled
Message-ID: <20130107145832.GA12363@hansolo.jdub.homelinux.org>
References: <20130104191205.GD27554@hansolo.jdub.homelinux.org>
 <87bod14x44.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bod14x44.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 11:39:47AM +1030, Rusty Russell wrote:
> Josh Boyer <jwboyer@redhat.com> writes:
> > With module signing enabled but not in enforcing mode, we don't consider
> > unsigned modules to be an error.  However, we only mark sig_ok as true if
> > a signature verified.  This causes the module to be tainted with the
> > TAINT_FORCED_MODULE flag.
> 
> Wait, what?  So, what does CONFIG_MODULE_SIG=y with MODULE_SIG_FORCE=n
> mean?  Why not just call that CONFIG_USELESS_BLOAT? :)

You can still enable enforcing mode with that configuration by passing
sig_enforce=1 as a kernel parameter.  Some distros default to this
configuration.

> >  That in turn taints the kernel, which also disables lockdep.
> 
> Yeah, lockdep is oversensitive.  This has been argued before, take it up
> with Ingo.  Perhaps we need a taint flag bit to indicate that lockdep
> should actually be disabled?

Well, sure maybe.  Frank already pointed out that the OOT taint doesn't
disable lockdep.  Having something more general would be good.  If there
isn't an easy way to do that, adding a TAINT_UNSIGNED to be used instead
of TAINT_FORCED_MODULE might work.  I've CC'd Ingo and Peter.

> > Tainting the module and kernel when we don't consider something to be an
> > error seems excessive.  This marks sig_ok as true if we aren't in enforcing
> > mode.
> 
> If we were to do this, please follow Plauger's Law: "Don't patch bad
> code - rewrite it."
> 
> In this case, rip out the now-useless sig_ok field.

OK.  I'll respin with that change if nothing else seems workable.

josh
