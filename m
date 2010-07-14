Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0GNCP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 22:15:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34777 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0GNCPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 22:15:24 -0400
X-Authority-Analysis: v=1.1 cv=eWk9bc5BAcy1KEyGm/gc5mmqTM7Cp/ADlcqpp9MTMWU= c=1 sm=0 a=YKZikld1fm8A:10 a=UBIxAjGgU1YA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=DfNHnWVPAAAA:8 a=QnIE056V78Ksjp_6yw8A:9 a=CYcrMIZWTZfe3dFatuTFGKK6MpcA:4 a=CjuIK1q_8ugA:10 a=lBRciGGoxdUA:10 wl=env:18 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Tue, 13 Jul 2010 21:17:20 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Yama: turn process ancestry check into function
Message-ID: <20100714021720.GA17686@hallyn.com>
References: <20100713173339.GA6104@outflux.net>
 <201007140019.o6E0J9gQ060582@www262.sakura.ne.jp>
 <20100714003049.GO6104@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714003049.GO6104@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (kees.cook@canonical.com):
> On Wed, Jul 14, 2010 at 09:19:09AM +0900, Tetsuo Handa wrote:
> > > +	if (mode == PTRACE_MODE_ATTACH &&
> > > +	    ptrace_scope &&
> > > +	    !task_is_descendant(current, child) &&
> > > +	    !capable(CAP_SYS_PTRACE))
> > > +		rc = -EPERM;
> > 
> > I don't know how heavy capable(CAP_SYS_PTRACE) is.
> > But checking !capable(CAP_SYS_PTRACE) before
> > !task_is_descendant(current, child) might be lighter.
> 
> That's the order I had before, but in looking at some of the other code, it
> seemed like moving it to the end made more logical sense.  Since checking
> PTRACE attach isn't a common or time-sensitive operation, I figured trying
> to tune it wasn't critical.

Yes the reason to keep it like this is that capable(CAP_SYS_PTRACE)
will set PF_SUPERPRIV if it passes.  You don't want to do that unless
the capability was actually required.

-serge
