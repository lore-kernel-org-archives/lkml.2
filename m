Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1EDANe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 20:13:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55348 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab1EDANc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 20:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nJYEXyiUQWtOhiECWy+Vsgjce5klWtGtABNBhi2MZgFHgHwgeB9FjG8XuPwBjTs5rD
         m4+355mHnnefM58MMfHgMTZ5hRkRxyLHybuDtKljeauPJBNuDJ9/37x+G8CgjI/MKmY+
         Da7gTe3jekyxN+bGXPvNrn2afRGdv4yqBoSRQ=
Date: Wed, 4 May 2011 02:13:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86: Allow the user not to build hw_breakpoints
Message-ID: <20110504001327.GJ2678@nowhere>
References: <1303923602-2923-4-git-send-email-fweisbec@gmail.com>
 <4DB854AA.6070101@zytor.com>
 <20110427182633.GB1753@nowhere>
 <008d59a3-bd23-4cb3-8a73-1640137e3ac4@email.android.com>
 <20110427195004.GA3654@nowhere>
 <4DC020D9.3050000@zytor.com>
 <20110503231241.GG2678@nowhere>
 <4DC0925E.20507@zytor.com>
 <20110503235434.GI2678@nowhere>
 <4DC09613.7030201@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC09613.7030201@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 04:56:03PM -0700, H. Peter Anvin wrote:
> On 05/03/2011 04:54 PM, Frederic Weisbecker wrote:
> > On Tue, May 03, 2011 at 04:40:14PM -0700, H. Peter Anvin wrote:
> >> On 05/03/2011 04:12 PM, Frederic Weisbecker wrote:
> >>>>
> >>>> It really is very bad... without breakpoints, you lose almost all
> >>>> debugging support.
> >>>
> >>> Right, so it should be fine for embedded environment to disable breakpoints.
> >>> It depends on CONFIG_EXPERT now.
> >>
> >> Uh... even embedded environments need to be able to debug.
> > 
> > For development yeah, but is it needed for production evironments?
> > 
> 
> Most of the time people don't want to debug something other than they're
> going to ship.


Well, it's like systems that don't care about having BUG(), sysctl, futexes, etc...
support in the kernel, or whatever standard feature that makes sense most of the time
but sometimes you simply don't need it.

Also consider that as a first step to be able to build a !CONFIG_PERF_EVENTS
kernel. If people show strong interest in beeing able to build a kernel
with breakpoints but without perf events, then I'll invest more efforts in
breaking the dependency.
