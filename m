Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab0F3MjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 08:39:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61292 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab0F3MjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 08:39:21 -0400
X-Authority-Analysis: v=1.1 cv=hVjE12FRt4v4sD2HVuppbi620CRC5en4UNTr7KPd1ng= c=1 sm=0 a=BpbFXrSub_kA:10 a=GQCbJdZ--msA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=DfNHnWVPAAAA:8 a=2zKFJmWSJVO2KywTfbAA:9 a=qEP96ZfGZv183IuboDMA:7 a=8SOwWJhL0N-fcsQLs7cf6k7sbrEA:4 a=CjuIK1q_8ugA:10 a=lBRciGGoxdUA:10 wl=env:18 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Wed, 30 Jun 2010 07:40:06 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Yama: add PTRACE exception tracking
Message-ID: <20100630124006.GA18155@hallyn.com>
References: <20100630003844.GE4837@outflux.net>
 <20100630004027.GG4837@outflux.net>
 <20100630035609.GA16307@hallyn.com>
 <20100630052752.GL4837@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630052752.GL4837@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (kees.cook@canonical.com):
> Hi Serge,
> 
> On Tue, Jun 29, 2010 at 10:56:09PM -0500, Serge E. Hallyn wrote:
> > Quoting Kees Cook (kees.cook@canonical.com):
> > > Some application suites have external crash handlers that depend on
> > > being able to use PTRACE to generate crash reports (KDE, Chromium, etc).
> > > Since the inferior process generally knows the PID of the debugger,
> > > it can use PR_SET_PTRACER to allow a specific PID and its descendants
> > > to perform the PTRACE instead of only a direct ancestor.
> > > 
> > > Signed-off-by: Kees Cook <kees.cook@canonical.com>
> > > ---
> > 
> > Hi Kees - very nice, overall.  One little note though:
> 
> Thanks for looking it over!
> 
> > >  	rc = cap_ptrace_access_check(child, mode);
> > 
> > This means that if capable(CAP_SYS_PTRACE) we'll always shortcut
> > here, so
> > 
> > > +	if (mode == PTRACE_MODE_ATTACH &&
> > > +	    ptrace_scope &&
> > > +	    !capable(CAP_SYS_PTRACE) &&
> > > +	    !task_is_descendant(current, child) &&
> > > +	    !ptracer_exception_found(current, child))
> > > +		rc = -EPERM;
> > 
> > You don't need the CAP_SYS_PTRACE check here AFAICS.
> 
> I don't think that's true -- the capable(CAP_SYS_PTRACE) tests
> are always done in the negative since we only ever abort with error

Haha, you're right, I looked at that wrong  :)

-serge
