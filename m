Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0GNAay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:30:54 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55746 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab0GNAax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:30:53 -0400
Date: Tue, 13 Jul 2010 17:30:49 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Yama: turn process ancestry check into function
Message-ID: <20100714003049.GO6104@outflux.net>
References: <20100713173339.GA6104@outflux.net>
 <201007140019.o6E0J9gQ060582@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007140019.o6E0J9gQ060582@www262.sakura.ne.jp>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 09:19:09AM +0900, Tetsuo Handa wrote:
> Kees Cook wrote:
> > +static int task_is_descendant(struct task_struct *parent,
> > +			      struct task_struct *child)
> > +{
> > +	int rc = 0;
> > +	struct task_struct *walker = child;
> > +
> > +	if (!parent || !child)
> > +		return 0;
> 
> parent (== current) is !NULL and
> child (in original code) is !NULL.
> You can remove this check unless you are planning to call
> this function from other places.

I'd like the flexibility to call it with NULLs.  But yes, at present, it
never will be NULL.

> > +	if (mode == PTRACE_MODE_ATTACH &&
> > +	    ptrace_scope &&
> > +	    !task_is_descendant(current, child) &&
> > +	    !capable(CAP_SYS_PTRACE))
> > +		rc = -EPERM;
> 
> I don't know how heavy capable(CAP_SYS_PTRACE) is.
> But checking !capable(CAP_SYS_PTRACE) before
> !task_is_descendant(current, child) might be lighter.

That's the order I had before, but in looking at some of the other code, it
seemed like moving it to the end made more logical sense.  Since checking
PTRACE attach isn't a common or time-sensitive operation, I figured trying
to tune it wasn't critical.

-Kees

-- 
Kees Cook
Ubuntu Security Team
