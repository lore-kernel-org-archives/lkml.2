Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab0KKAfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:35:17 -0500
Received: from ozlabs.org ([203.10.76.45]:38851 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab0KKAfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:35:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Delegate unknown module parameters to interested parties
Date: Thu, 11 Nov 2010 11:05:08 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic-pae; KDE/4.5.1; i686; ; )
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
References: <0d30dc$k4dmjb@orsmga001.jf.intel.com> <201011101621.28946.rusty@rustcorp.com.au> <1289397360.12418.119.camel@gandalf.stny.rr.com>
In-Reply-To: <1289397360.12418.119.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011111105.09255.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010 12:26:00 am Steven Rostedt wrote:
> On Wed, 2010-11-10 at 16:21 +1030, Rusty Russell wrote:
> > On Wed, 10 Nov 2010 01:09:21 am Steven Rostedt wrote:
> > > [ Added Rusty "Module God" Russell ]
> > 
> > And I also wrote the parameter parsing code, so sending to me is probably
> > a good idea.
> > 
> > So, what's this for?  You want trace= as a standard module parameter
> 
> Yep, this way we could even enable tracepoints that are in the init
> section.

*Exactly* how would it be used though?  Please provide a synopsis for
someone unaware of what tracing does these days?

Because we could compile an extra module_parm() into the module using
modpost, for example, at a cost of an extra 16/32 bytes per module.

> But, personally, I like the generic addition. Perhaps others will hook into
> it without fear of having to hack the module code, which can be quite
> intimidating to some.

We *all* want to build infrastructure; when other coders are forced to use
it we rise up the kernel dominance hierarchy. Ook ook!  (Every Unix app has
its own config language for the same reason: the author distils the mental
sweat of the users into some kind of Elixer of Coder Hubris).

Yet abstractions obfuscate: let's resist our primal urges to add another
speed hump on the lengthening road to kernel expertese.

And this one's classicly easy: in single uses cases we always get the
infrastructure wrong for future users anyway, so let's not do it until
we have more than one user.

Cheers,
Rusty.
