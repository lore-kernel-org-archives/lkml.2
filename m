Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1J0BoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 21:44:01 -0400
Received: from ozlabs.org ([203.10.76.45]:36662 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab1J0BoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 21:44:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>
Cc: Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not built in-tree
In-Reply-To: <20111026130834.GA6387@elliptictech.com>
References: <1319461948.31243.31.camel@deadeye> <4EA57CBF.2050901@xenotime.net> <87k47tpvvm.fsf@rustcorp.com.au> <20111025153855.GA24779@elliptictech.com> <1319558749.11727.6.camel@deadeye> <20111025165142.GA25354@elliptictech.com> <20111025200455.GA6376@kroah.com> <20111025201723.GA25063@redhat.com> <20111025205410.GA7479@kroah.com> <20111026130834.GA6387@elliptictech.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 27 Oct 2011 11:41:37 +1030
Message-ID: <874nyvnsqe.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011 09:08:34 -0400, Nick Bowler <nbowler@elliptictech.com> wrote:
> On 2011-10-25 22:54 +0200, Greg KH wrote:
> > On Tue, Oct 25, 2011 at 04:17:24PM -0400, Dave Jones wrote:
> > > On Tue, Oct 25, 2011 at 10:04:55PM +0200, Greg Kroah-Hartman wrote:
> > >  > On Tue, Oct 25, 2011 at 12:51:42PM -0400, Nick Bowler wrote:
> > >  > > This is not the case: lockdep works fine with staging modules.
> > >  > 
> > >  > Yes, that was fixed a few kernel versions ago.
> > >  > 
> > >  > Now you might want to update that fix for the TAINT_OOT_MODULE flag as
> > >  > well, if you feel it is needed.
> > > 
> > > I'm assuming you mean this patch ?
> > > 
> > > commit 7816c45bf13255157c00fb8aca86cb64d825e878
> > > Author: Roland Vossen <rvossen@broadcom.com>
> > > Date:   Thu Apr 7 11:20:58 2011 +0200
> > > 
> > >     modules: Enabled dynamic debugging for staging modules
> > 
> > Hm, this is the patch I was thinking about yes.  But as you point out:
> [...]
> > Perhaps the lockdep thing is totally different.  I don't know about that
> > check.
> 
> Lockdep is disabled (for the whole system) by add_taint itself.  The
> relevant commit that fixes TAINT_CRAP appears to be this one (circa
> 2.6.30):
> 
>   commit 574bbe782057fdf0490dc7dec906a2dc26363e20
>   Author: Frederic Weisbecker <fweisbec@gmail.com>
>   Date:   Sat Apr 11 03:17:18 2009 +0200
>   
>       lockdep: continue lock debugging despite some taints
> 
> I didn't know about the dynamic debug problem.  Is there more breakage
> that we haven't found yet?  Remind me why we're trying to cripple out
> of tree module users?

Gah, people are overloading taint.

It doesn't mean "don't do stuff", it means "note the taint when
something goes wrong".

I think we need a "taint_string()" function, and instead of lockdep
disabling itself it should note the taint string in its reports.
Similarly for anything else (oops already does this).

Dynamic debugging should just crash like anything else if they force a
module load and get it wrong: it's the least of their problems.

If noone hugely objects, I'll create a patch series...

Thanks,
Rusty.
